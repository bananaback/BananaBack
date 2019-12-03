WindBullet2 = Object:extend()

function WindBullet2:new(x, y, direction)
    self.x = x
    self.y = y
    self.scaleX = direction
    self.sprite = love.graphics.newImage('art/windbullet2.png')
    if self.scaleX == 1 then
        self.vx = 70
    elseif self.scaleX == -1 then
        self.vx = -70
    end
    self.vy = 0
    self.width = 16
    self.height = 16
    world:add(self, self.x, self.y, self.width, self.height)
    self.bullet2Timer = Timer.new()
    self.bullet2Timer:after(5, function() self.bullet2Timer:clear() self:boom() end)
    self.damageYet = false
end

function WindBullet2:update(dt)
    local function windBullet2Filter(item, other)
        if other.isBlock then return 'cross' 
        elseif other.isScorpion then return 'cross' 
        elseif other.isBullet1 then return 'cross' end
    end
    
    local goalX, goalY = self.x + self.vx * dt, self.y + self.vy * dt
    local actualX, actualY, cols, len = world:move(self, goalX, goalY, windBullet2Filter)
    self.x, self.y = actualX, actualY
    
     for i = 1, len do
        local other = cols[i].other
        if other.isBullet1 then
            other:boom()
        end
        if other.isScorpion then
            if self.scaleX == 1 and self.x < other.x then
                --other.vx = 100
                other.state = 'back'
            end
            if self.scaleX == -1 and self.x > other.x then
                --other.vx = -100
                other.state = 'back'
            end
            if self.damageYet == false then
                table.insert(listOfPopUps, PopUp(other.x + 8 + math.random(-2, 2), self.y, 5, 10, 2.5, 'yellow', 1))
                other.health = other.health - 5
                other.healthBarOpacity = 100
                other.vy = -150    
                --table.insert(listOfEffectObjects, WindBlow(other.x, other.y))
                --addRandomCoin(self.x, self.y, love.math.random(1, 2))
                self.damageYet = true
            end
            self:boom()
        end
    end
    
    self.bullet2Timer:update(dt)
end

function WindBullet2:boom()
    for windbullet2num, windbullet2now in ipairs(listOfBullets) do
        if windbullet2now == self then
            world:remove(self)
            self.bullet2Timer:clear()
            table.remove(listOfBullets, windbullet2num) 
            break 
        end
    end
end

function WindBullet2:draw()
    love.graphics.draw(self.sprite, self.x + self.width / 2, self.y + self.height /2, nil, self.scaleX, 1, 8, 8)
    --love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
end