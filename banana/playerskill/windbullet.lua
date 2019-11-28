WindBullet1 = Object:extend()

function WindBullet1:new(x, y, direction)
    self.x = x
    self.y = y
    self.scaleX = direction
    self.width = 8
    self.height = 8
    self.sprite = love.graphics.newImage('art/windbullet1.png')
    self.lifeTime = 100
    if self.scaleX == 1 then self.vx = 50 elseif self.scaleX == -1 then self.vx = -50 end
    self.vy = 0
    world:add(self, self.x, self.y, self.width, self.height)
    Timer.after(5, function() self:boom() end)
end

function WindBullet1:update(dt)
    local function windBullet1Filter(item, other)
        if other.isBlock then return 'touch' 
        elseif other.isScorpion then return 'cross' end
    end
    
    local goalX, goalY = self.x + self.vx * dt, self.y + self.vy * dt
    local actualX, actualY, cols, len = world:move(self, goalX, goalY, windBullet1Filter)
    self.x, self.y = actualX, actualY
    
    for i = 1, len do
        local other = cols[i].other
        if other.isScorpion then
            if self.scaleX == 1 self.x < other.x then
                other.vx = 100
                other.state = 'back'
            end
            if self.scaleX == -1 self.x > other.x then
                other.vx = -100
                other.state = 'back'
            end
            self:boom()
        end
    end
end

function WindBullet1:boom()
     for winbullet1num, winbullet1now in ipairs(listOfBullets) do
	      if winbullet1now == self then
            world:remove(self)
            table.remove(listOfBullets, winbullet1num) 
            break 
        end
    end
end

function WindBullet1:draw()
    love.graphics.draw(self.sprite, self.x + self.width / 2, self.y + self.height / 2, nil, self.scaleX, 1, 4, 4)
    --love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
end