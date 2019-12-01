WaterPunch = Object:extend()

function WaterPunch:new(x, y, direction)
    self.x = x
    self.y = y
    self.width = 16
    self.height = 8
    self.scaleX = direction
    
    world:add(self, self.x, self.y, self.width, self.height)
    self.sprite = love.graphics.newImage('art/basicgame.png')
    self.grid = anim8.newGrid(self.width, self.height, self.sprite:getWidth(), self.sprite:getHeight())
    self.anim = anim8.newAnimation(self.grid(4, 9), 0.1)
    self.lifeTime = 3
    self.vx = 0
    self.vy = 0
    self.damageYet = false
end

function WaterPunch:update(dt)
    self.anim:update(dt)
    
    local function waterPunchFilter(item, other)
        if other.isBlock then return 'cross' 
        elseif other.isScorpion then return 'cross' end
    end
    
    local goalX, goalY = self.x + self.vx * dt, self.y + self.vy * dt
    local actualX, actualY, cols, len = world:move(self, goalX, goalY, waterPunchFilter)
    self.x, self.y = actualX, actualY
    
    for i = 1, len do
        local other = cols[i].other
        if other.isScorpion then
            if self.damageYet == false then
                table.insert(listOfPopUps, PopUp(other.x + 8 + math.random(-2, 2), self.y, 5, 10, 2.5, 'yellow', 1))
                other.health = other.health - 5
                other.healthBarOpacity = 100
                other.burnTime = 0
                --addRandomCoin(self.x, self.y, love.math.random(2, 3))
                self.damageYet = true
            end
            self:boom()
        end
    end
    
    
    self.lifeTime = self.lifeTime - 1
    if self.lifeTime <= 0 then
        self:boom()
    end
end

function WaterPunch:boom()
    for waterpunchnum, waterpunchnow in ipairs(listOfBullets) do
	      if waterpunchnow == self then
            world:remove(self)
            table.remove(listOfBullets, waterpunchnum) 
            break 
        end
    end
end

function WaterPunch:draw()
    self.anim:draw(self.sprite, self.x + self.width / 2, self.y + self.height / 2, nil, self.scaleX, 1, 8, 4)
    --love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
end