WaterBullet1 = Object:extend()

function WaterBullet1:new(x, y, direction)
    self.x = x
    self.y = y
    self.width = 8
    self.height = 8
    self.scaleX = direction
    self.sprite = love.graphics.newImage('art/waterbullet1.png')
    self.vy = 0
    if self.scaleX == 1 then
        self.vx = 30
    elseif self.scaleX == -1 then
        self.vx = -30
    end
    world:add(self, self.x, self.y, self.width, self.height)
    self.waterbullet1Timer = Timer.new()
    self.waterbullet1Timer:after(5, function() self.waterbullet1Timer:clear() self:boom() end)
    self.damageYet = false
    self.isWaterBullet1 = false
end

function WaterBullet1:update(dt)
    local function waterBullet1Filter(item, other)
        if other.isBlock then return 'cross' 
        elseif other.isScorpion then return 'cross' 
        elseif other.isWaterBullet1 then return 'cross' end
    end
    
    local goalX, goalY = self.x + self.vx * dt, self.y + self.vy * dt
    local actualX, actualY, cols, len = world:move(self, goalX, goalY, waterBullet1Filter)
    self.x, self.y = actualX, actualY
    
    for i = 1, len do 
        local other = cols[i].other
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
    
    self.waterbullet1Timer:update(dt)
end

function WaterBullet1:boom()
    for waterbullet1num, waterbullet1now in ipairs(listOfBullets) do
        if waterbullet1now == self then
            world:remove(self)
            self.waterbullet1Timer:clear()
            table.remove(listOfBullets, waterbullet1num) 
            break 
        end
    end
end

function WaterBullet1:draw()
    love.graphics.draw(self.sprite, self.x + self.width / 2, self.y + self.height / 2, nil, self.scaleX, 1, 4, 4)
    --love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
end