PopUp = Object:extend()

function PopUp:new(x, y, damage, size, duration, color, speed)
    self.x = x
    self.y = y
    self.damage = damage
    self.size = size
    self.font = love.graphics.newFont(self.size)
    --self.font = love.graphics.newFont('font/pcsenior.ttf', self.size)
    --[[self.font = love.graphics.newImageFont('font/font1.png',
    " abcdefghijklmnopqrstuvwxyz" ..
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
    "123456789.,!?-+/():;%&`'*#=[]\"", self.size)]]--
    self.opacity = 0
    self.duration = duration
    self.color = color
    self.speed = speed
end

function PopUp:update(dt)
    self.opacity = self.opacity + self.duration
    self.y = self.y - self.speed
    if self.opacity > 100 then
        self:boom()
    end
end

function PopUp:boom()
    for popnum, popnow in ipairs(listOfPopUps) do
	      if popnow == self then
            table.remove(listOfPopUps, popnum) 
            break 
        end
    end
end

function PopUp:draw()
    love.graphics.setFont(self.font)
    if self.color == 'white' then
        love.graphics.setColor(1, 1, 1, self.opacity)
    elseif self.color == 'yellow' then
        love.graphics.setColor(248/255, 252/255, 0, self.opacity)  
    elseif self.color == 'purple' then
        love.graphics.setColor(202/255, 0, 252/255, self.opacity)  
    elseif self.color == 'red' then
        love.graphics.setColor(1, 0, 0, self.opacity)  
    end
    love.graphics.print(self.damage, self.x, self.y)
end