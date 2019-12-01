FireBullet1 = Object:extend()

function FireBullet1:new(x, y, direction)
    self.x = x
    self.y = y
    self.width = 8
    self.height = 8
    self.scaleX = direction
    self.sprite = love.graphics.newImage('art/firebullet1.png')
    self.vy = 0
    if self.scaleX == 1 then
        self.vx = 50
    elseif self.scaleX == -1 then
        self.vx = -50
    end
    world:add(self, self.x, self.y, self.width, self.height)
    self.firebullet1Timer = Timer.new()
    self.firebullet1Timer:after(5, function() self.firebullet1Timer:clear() self:boom() end)
    self.damageYet = false
end

function FireBullet1:update(dt)
    local function fireBullet1Filter(item, other)
        if other.isBlock then return 'cross' 
        elseif other.isScorpion then return 'cross' 
        elseif other.isBullet1 then return 'cross' end
    end
    
    local goalX, goalY = self.x + self.vx * dt, self.y + self.vy * dt
    local actualX, actualY, cols, len = world:move(self, goalX, goalY, fireBullet1Filter)
    self.x, self.y = actualX, actualY
    
    for i = 1, len do
        local other = cols[i].other
        if other.isScorpion then
            if self.damageYet == false then
                table.insert(listOfPopUps, PopUp(other.x + 8 + math.random(-2, 2), self.y, 10, 10, 2.5, 'yellow', 1))
                other.health = other.health - 10
                other.healthBarOpacity = 100
                other.burnTime = 210
                --addRandomCoin(self.x, self.y, love.math.random(2, 3))
                self.damageYet = true
            end
            self:boom()
        end
    end
    
    self.firebullet1Timer:update(dt)
end

function FireBullet1:boom()
    for firebullet1num, firebullet1now in ipairs(listOfBullets) do
        if firebullet1now == self then
            world:remove(self)
            self.firebullet1Timer:clear()
            table.remove(listOfBullets, firebullet1num) 
            break 
        end
    end
end

function FireBullet1:draw()
    love.graphics.draw(self.sprite, self.x + self.width / 2, self.y + self.height / 2, nil, self.scaleX, 1, 4, 4)
    --love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
end