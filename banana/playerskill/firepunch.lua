FirePunch = Object:extend()

function FirePunch:new(x, y, direction)
    self.x = x
    self.y = y
    self.scaleX = direction
    self.width = 16
    self.height = 8
    
    world:add(self, self.x, self.y, self.width, self.height)
    self.sprite = love.graphics.newImage('art/basicgame.png')
    self.grid = anim8.newGrid(self.width, self.height, self.sprite:getWidth(), self.sprite:getHeight())
    self.anim = anim8.newAnimation(self.grid(2, 9), 0.1)
    self.lifeTime = 3
    self.vx = 0
    self.vy = 0
    self.damageYet = false
end

function FirePunch:update(dt)
    self.anim:update(dt)
    
    local function firePunchFilter(item, other)
        if other.isBlock then return 'cross' 
        elseif other.isScorpion then return 'cross' end
    end
    
    local goalX, goalY = self.x + self.vx * dt, self.y + self.vy * dt
    local actualX, actualY, cols, len = world:move(self, goalX, goalY, firePunchFilter)
    self.x, self.y = actualX, actualY
    
    for i = 1, len do
        local other = cols[i].other
        for i = 1, len do
        local other = cols[i].other
        if other.isScorpion then
            if self.damageYet == false then
                table.insert(listOfPopUps, PopUp(other.x + 8 + math.random(-2, 2), self.y, 10, 10, 2.5, 'yellow', 1))
                other.health = other.health - 10
                other.healthBarOpacity = 100
                other.burnTime = 150
                addRandomCoin(self.x, self.y, love.math.random(2, 3))
                self.damageYet = true
            end
            self:boom()
        end
    end
    end
    
    
    self.lifeTime = self.lifeTime - 1
    if self.lifeTime <= 0 then
        self:boom()
    end
end

function FirePunch:boom()
    for firepunchnum, firepunchnow in ipairs(listOfBullets) do
	      if firepunchnow == self then
            world:remove(self)
            table.remove(listOfBullets, firepunchnum) 
            break 
        end
    end
end

function FirePunch:draw()
    self.anim:draw(self.sprite, self.x + self.width / 2, self.y + self.height / 2, nil, self.scaleX, 1, 8, 4)
    --love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
end