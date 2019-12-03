FreezeEffect = Object:extend()

function FreezeEffect:new(x, y, lifeTime, decreaseSpeed)
    self.width = 16
    self.height = 16
    self.x = x
    self.y = y
    self.sprite = love.graphics.newImage('art/bubbles.png')
    self.grid = anim8.newGrid(self.width, self.height, self.sprite:getWidth(), self.sprite:getHeight())
    self.anim = anim8.newAnimation(self.grid(1, '17-20'), 0.1, 'pauseAtEnd')
    self.lifeTime = 300
    self.vx = 0
    self.vy = 200
    world:add(self, self.x, self.y, self.width, self.height)
    self.lifeTime = lifeTime
    self.freezeEffectTimer = Timer.new()
    self.freezeEffectTimer:after(self.lifeTime, function() self.freezeEffectTimer:clear() self:boom() end)
    self.damageYet = false
    self.opacity = 1
    
end

function FreezeEffect:update(dt)
    self.anim:update(dt)
    
    local function freezeEffectFilter(item, other)
        if other.isBlock then return 'slide' 
        elseif other.isScorpion then return 'cross' end
    end
    
    local goalX, goalY = self.x + self.vx * dt, self.y + self.vy * dt
    local actualX, actualY, cols, len = world:move(self, goalX, goalY, freezeEffectFilter)
    self.x, self.y = actualX, actualY
    
    --for i = 1, len do
    --    local other = cols[i].other
        --if other.isScorpion then
        --    if self.damageYet == false then
        --        --other.vy = -150
        --        self.damageYet = true
        --    end
        --end
    --end
    self.opacity = self.opacity - 1/300
    self.freezeEffectTimer:update(dt)
end

function FreezeEffect:boom()
    for freezeeffectnum, freezeeffectnow in ipairs(listOfEffectObjects) do
	      if freezeeffectnow == self then
            world:remove(self)
            self.freezeEffectTimer:clear()
            table.remove(listOfEffectObjects, freezeeffectnum) 
            break 
        end
    end
end

function FreezeEffect:draw()
    love.graphics.setColor(1, 1, 1, self.opacity)
    self.anim:draw(self.sprite, self.x, self.y)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
end