Coin = Object:extend()

function Coin:new(x, y, typeOfCoin, speedX, speedcoin)
    self.x = x
    self.y = y
    self.type = typeOfCoin
    self.width = 8
    self.height = 8
    self.speedCoin = speedcoin
    
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
    if self.speedCoin == 'slow' then
        self.vy = 50
        self.vylosingSpeed = 1
        self.vxlosingSpeed = 0.02
    elseif self.speedCoin == 'medium' then
        self.vy = 100
        self.vylosingSpeed = 2
        self.vxlosingSpeed = 0.04
    elseif self.speedCoin == 'fast' then
        self.vy = 100
        self.vylosingSpeed = 4
        self.vxlosingSpeed = 0.04
    end
    world:add(self, self.x, self.y, self.width, self.height)
    self.bounceTime = 0
    self.isCoin = true
    self.lastlong = 30
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
    ---- tao them gia tri chia 2
    if self.vy < 100 then
        self.vy = self.vy + self.vylosingSpeed
    end
    if math.abs(self.vx) > 0 then
        if self.vx < 0 then self.vx = self.vx + self.vxlosingSpeed end
        if self.vx > 0 then self.vx = self.vx - self.vxlosingSpeed end
    end
    self.lastlong = self.lastlong - dt 
    if self.lastlong < 0 then
        self:boom()
    end
end

function Coin:boom()
    for coinnum, coinnow in ipairs(listOfCoins) do
	      if coinnow == self then
            world:remove(self)
            table.remove(listOfCoins, coinnum) 
            break 
        end
    end
end

function Coin:draw()
    love.graphics.setColor(1, 1, 1)
    self.anim:draw(self.sprite, self.x, self.y)
end