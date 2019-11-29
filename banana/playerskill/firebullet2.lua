FireBullet2 = Object:extend()

function FireBullet2:new(x, y, direction)
    self.x = x
    self.y = y
    self.width = 16
    self.height = 16
    self.scaleX = direction
    self.sprite = love.graphics.newImage('art/firebullet2.png')
    self.vy = 0
    if self.scaleX == 1 then
        self.vx = 70
    elseif self.scaleX == -1 then
        self.vx = -70
    end
    world:add(self, self.x, self.y, self.width, self.height)
    self.firebullet2Timer = Timer.new()
    self.firebullet2Timer:after(5, function() self.firebullet2Timer:clear() self:boom() end)
    self.damageYet = false
end

function FireBullet2:update(dt)
    local function fireBullet2Filter(item, other)
        if other.isBlock then return 'cross' 
        elseif other.isScorpion then return 'cross' 
        elseif other.isBullet1 then return 'cross' end
    end
    
    local goalX, goalY = self.x + self.vx * dt, self.y + self.vy * dt
    local actualX, actualY, cols, len = world:move(self, goalX, goalY, fireBullet2Filter)
    self.x, self.y = actualX, actualY
    
    for i = 1, len do
        local other = cols[i].other
        if other.isScorpion then
            if self.damageYet == false then
                table.insert(listOfPopUps, PopUp(other.x + 8 + math.random(-2, 2), self.y, 15, 10, 2.5, 'yellow', 1))
                other.health = other.health - 15
                other.healthBarOpacity = 100
                other.burnTime = 300
                addRandomCoin(self.x, self.y, love.math.random(2, 3))
                self.damageYet = true
            end
            self:boom()
        end
    end
    
    self.firebullet2Timer:update(dt)
end

function FireBullet2:boom()
    for firebullet2num, firebullet2now in ipairs(listOfBullets) do
        if firebullet2now == self then
            world:remove(self)
            table.remove(listOfBullets, firebullet2num) 
            break 
        end
    end
end

function FireBullet2:draw()
    love.graphics.draw(self.sprite, self.x + self.width / 2, self.y + self.height / 2, nil, self.scaleX, 1, 8, 8)
    --love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
end