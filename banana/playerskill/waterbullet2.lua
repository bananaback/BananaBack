WaterBullet2 = Object:extend()

function WaterBullet2:new(x, y, direction)
    self.x = x
    self.y = y
    self.width = 16
    self.height = 16
    self.scaleX = direction
    self.sprite = love.graphics.newImage('art/waterbullet2.png')
    self.vy = 0
    if self.scaleX == 1 then
        self.vx = 50
    elseif self.scaleX == -1 then
        self.vx = -50
    end
    world:add(self, self.x, self.y, self.width, self.height)
    self.waterbullet2Timer = Timer.new()
    self.waterbullet2Timer:after(5, function() self.waterbullet2Timer:clear() self:boom() end)
    self.damageYet = false
end

function WaterBullet2:update(dt)
    local function waterBullet2Filter(item, other)
        if other.isBlock then return 'cross' 
        elseif other.isScorpion then return 'cross' 
        elseif other.isWaterBullet1 then return 'cross'
        elseif other.isWaterBullet2 then return 'cross' end
    end
    
    local goalX, goalY = self.x + self.vx * dt, self.y + self.vy * dt
    local actualX, actualY, cols, len = world:move(self, goalX, goalY, waterBullet2Filter)
    self.x, self.y = actualX, actualY
    
    for i = 1, len do
        local other = cols[i].other
        if other.isWaterBullet1 then other:boom() end
        if other.isScorpion then
            other.burnTime = 0
            if self.damageYet == false then
                other.health = other.health - 5
                other.healthBarOpacity = 100
                table.insert(listOfPopUps, PopUp(other.x + 8 + math.random(-2, 2), self.y, 5, 10, 2.5, 'yellow', 1))
                self.damageYet = true
            end
            self:boom()
        end
    end
    
    self.waterbullet2Timer:update(dt)
end

function WaterBullet2:boom()
    for waterbullet2num, waterbullet2now in ipairs(listOfBullets) do
        if waterbullet2now == self then
            world:remove(self)
            self.waterbullet2Timer:clear()
            table.remove(listOfBullets, waterbullet2num) 
            break 
        end
    end
end

function WaterBullet2:draw()
    love.graphics.draw(self.sprite, self.x + self.width / 2, self.y + self.height / 2, nil, self.scaleX, 1, 8, 8)
    --love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
end