WindPunch = Object:extend()

function WindPunch:new(x, y, direction)
    self.x = x
    self.y = y
    self.scaleX = direction
    self.width = 16
    self.height = 8
    
    world:add(self, self.x, self.y, self.width, self.height)
    self.sprite = love.graphics.newImage('art/basicgame.png')
    self.grid = anim8.newGrid(self.width, self.height, self.sprite:getWidth(), self.sprite:getHeight())
    self.anim = anim8.newAnimation(self.grid(6, 9), 0.1)
    self.lifeTime = 33
    self.vx = 0
    self.vy = 0
    self.damageYet = false
end

function WindPunch:update(dt)
    self.anim:update(dt)
    
    local function windPunchFilter(item, other)
        if other.isBlock then return 'cross' 
        elseif other.isScorpion then return 'cross' end
    end
    
    local goalX, goalY = self.x + self.vx * dt, self.y + self.vy * dt
    local actualX, actualY, cols, len = world:move(self, goalX, goalY, windPunchFilter)
    self.x, self.y = actualX, actualY
    
    for i = 1, len do
        local other = cols[i].other
        if other.isScorpion then
            if self.scaleX == -1 and self.x > other.x then
                other.vx = -70
                other.state = 'back'
            end
            if self.scaleX == 1 and self.x < other.x then
                other.vx = 70
                other.state = 'back'
            end
            if self.damageYet == false then
                table.insert(listOfPopUps, PopUp(other.x + 8 + math.random(-2, 2), self.y, 3, 10, 2.5, 'yellow', 1))
                other.health = other.health - 0.3
                other.healthBarOpacity = 100
                addRandomCoin(self.x, self.y, love.math.random(1, 2))
                self.damageYet = true
            end
        end
    end
    
    
    self.lifeTime = self.lifeTime - 1
    if self.lifeTime <= 0 then
        self:boom()
    end
end

function WindPunch:boom()
    for winpunchnum, winpunchnow in ipairs(listOfBullets) do
	      if winpunchnow == self then
            world:remove(self)
            table.remove(listOfBullets, winpunchnum) 
            break 
        end
    end
end

function WindPunch:draw()
    self.anim:draw(self.sprite, self.x + self.width / 2, self.y + self.height / 2, nil, self.scaleX, 1, 8, 4)
end