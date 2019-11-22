Coin = Object:extend()

function Coin:new(x, y, typeOfCoin, speedX)
    self.x = x
    self.y = y
    self.type = typeOfCoin
    self.width = 8
    self.height = 8
    
    self.sprite = love.graphics.newImage('art/money.png')
    self.grid = anim8.newGrid(self.width, self.height, self.sprite:getWidth(), self.sprite:getHeight())
    if self.type == 1 then
    self.anim = anim8.newAnimation(self.grid(4, 1), 0.1)
    elseif self.type == 2 then
    self.anim = anim8.newAnimation(self.grid(5, 1), 0.1)
    elseif self.type == 3 then
    self.anim = anim8.newAnimation(self.grid(6, 1), 0.1)
    elseif self.type == 4 then
    self.anim = anim8.newAnimation(self.grid(2, 2), 0.1)
    elseif self.type == 5 then
    self.anim = anim8.newAnimation(self.grid(3, 2), 0.1)
    elseif self.type == 6 then
    self.anim = anim8.newAnimation(self.grid(4, 2), 0.1)
    elseif self.type == 7 then
    self.anim = anim8.newAnimation(self.grid(5, 2), 0.1)
    elseif self.type == 8 then
    self.anim = anim8.newAnimation(self.grid(6, 2), 0.1)
    elseif self.type == 9 then
    self.anim = anim8.newAnimation(self.grid(2, 3), 0.1)
    elseif self.type == 10 then
    self.anim = anim8.newAnimation(self.grid(3, 3), 0.1)
    elseif self.type == 11 then
    self.anim = anim8.newAnimation(self.grid(4, 3), 0.1)
    elseif self.type == 12 then
    self.anim = anim8.newAnimation(self.grid(5, 3), 0.1)
    elseif self.type == 13 then
    self.anim = anim8.newAnimation(self.grid(6, 3), 0.1)
    elseif self.type == 14 then
    self.anim = anim8.newAnimation(self.grid(2, 4), 0.1)
    elseif self.type == 15 then
    self.anim = anim8.newAnimation(self.grid(3, 4), 0.1)
    elseif self.type == 16 then
    self.anim = anim8.newAnimation(self.grid(4, 4), 0.1)
    elseif self.type == 17 then
    self.anim = anim8.newAnimation(self.grid(5, 4), 0.1)
    elseif self.type == 18 then
    self.anim = anim8.newAnimation(self.grid(6, 4), 0.1)
  end
    self.vx = speedX
    self.vy = 50
    world:add(self, self.x, self.y, self.width, self.height)
    self.bounceTime = 0
    self.isCoin = true
end

function Coin:update(dt)
    self.anim:update(dt)
    local function coinFilter(item, other)
        if other.isBlock then return 'slide' end
    end
    local goalX, goalY = self.x + self.vx * dt, self.y + self.vy * dt
    local actualX, actualY, cols, len = world:move(self, goalX, goalY, coinFilter)
    self.x, self.y = actualX, actualY
    
    for i=1,len do
        local other = cols[i].other
        if other.isBlock then
            if self.bounceTime < 10 then
                self.bounceTime = self.bounceTime + 1
                self.vy = -((self.vy/3*2) + math.random(1, self.vy/3))
            end
        end
    end
    
    if self.vy < 50 then
        self.vy = self.vy + 1
    end
    if math.abs(self.vx) > 0 then
        if self.vx < 0 then self.vx = self.vx + 0.02 end
        if self.vx > 0 then self.vx = self.vx - 0.02 end
    end
end

function Coin:draw()
    love.graphics.setColor(1, 1, 1)
    self.anim:draw(self.sprite, self.x, self.y)
end