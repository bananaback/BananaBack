Scorpion = Object:extend()

function Scorpion:new(x, y, targetX1, tarGetX2)
    self.x = x 
    self.y = y
    self.targetX1 = self.x - targetX1
    self.targetX2 = self.x + tarGetX2
    self.width = 16
    self.height = 16
    self.sprite = love.graphics.newImage('art/basicgame.png')
    self.grid = anim8.newGrid(self.width, self.height, self.sprite:getWidth(), self.sprite:getHeight())
    self.animations = {}
    self.animations.idle = anim8.newAnimation(self.grid('1-2', 4), 0.1)
    self.anim = self.animations.idle
    world:add(self, self.x, self.y, self.width, self.height)
    self.vx = 0
    self.vy = 200
    self.state = 'moveleft'
    self.scaleX = 1
    self.isScorpion = true
    self.health = 100
    self.healthBarOpacity = 0
    self.switchTime = 2.2
    self.talkTime = 0.65
    
    self.burnTime = 0
    self.isBurning = false
    self.burnTimer = Timer.new()
    self.burnTimer:every(0.2, function() 
        if self.isBurning then
            self.health = self.health - 0.1
            self.healthBarOpacity = 100
            table.insert(listOfPopUps, PopUp(self.x + self.width / 2 + love.math.random(-8, 8), self.y + self.height / 2 + love.math.random(-8, 8), '(#)', 5, 2.5, 'orange', 0.2))
        end end)
end

function Scorpion:update(dt)
    if self.burnTime > 0 then
        self.burnTime = self.burnTime - 1
        self.isBurning = true
    else
        self.isBurning = false
    end
    
    
    
    local function scorpionFilter(item, other)
        if other.isBlock then return 'slide' end
    end
    local goalX, goalY = self.x + self.vx * dt, self.y + self.vy * dt
    local actualX, actualY, cols, len = world:move(self, goalX, goalY, scorpionFilter)
    self.x, self.y = actualX, actualY
    
    
    
    if self.switchTime > 0 then
        self.switchTime = self.switchTime - dt
    else
        self.switchTime = 2.2

        -- Handle state transitions at timer expiry
        if self.state ~= 'back' then
        if self.state == 'moveleft' then
            self.state = 'idleleft'
        elseif self.state == 'moveright' then
            self.state = 'idleright'
        elseif self.state == 'idleleft' then
            self.state = 'moveleft'
        else -- must be 'idleright' as it's the only remaining possibility
            self.state = 'moveright'
        end
        end
    end

    -- Handle state transitions when hitting the end
    if self.state == 'moveleft' and self.x <= self.targetX1 then
      self.state = 'moveright'
    elseif self.state == 'moveright' and self.x >= self.targetX2 then
      self.state = 'moveleft'
    end
    
    if self.state ~= 'back' then
    if self.state == 'moveleft' then
        self.vx = -25
        self.scaleX = -1
    elseif self.state == 'moveright' then
        self.vx = 25
        self.scaleX = 1
    else -- must be one of the idle states
        self.vx = 0 
        if self.talkTime > 0 then
            self.talkTime = self.talkTime - dt
        else
            self.talkTime = 0.3
            table.insert(listOfPopUps, PopUp(self.x + math.random(-8, 24), self.y - math.random(-4, 4), 'z', 7, 2, 'purple', 0.5))
        end
    end
  else
        Timer.after(1, function() 
            local rand = love.math.random(0, 1, 2)
            if rand == 0 then 
                self.state = 'moveleft' 
            elseif rand == 1 then
                self.state = 'moveright' 
            elseif rand == 2 then
                self.state = 'idleleft'
            else
                self.state = 'idleright'
            end
            end)
        if self.vx < 0 then self.vx = self.vx+ 1 end
        if self.vx > 0 then self.vx = self.vx - 1 end
    end

    if self.vx ~= 0 then
        self.anim:update(dt)
    end
    
    if self.healthBarOpacity > 0 then
        self.healthBarOpacity = self.healthBarOpacity - 1
    end
    
    if self.health <= 0 then
        table.insert(listOfPopUps, PopUp(self.x, self.y, 'Bye!', 10, 2, 'blue', 1))
        self:boom()
    end
    
    self.burnTimer:update(dt)
end

function Scorpion:boom()
    for scornum, scornow in ipairs(listOfEnemies) do
	      if scornow == self then
            self.burnTimer:clear()
            world:remove(self)
            table.remove(listOfEnemies, scornum) 
            break 
        end
    end
end


function Scorpion:draw()
    self.anim:draw(self.sprite, self.x + self.width / 2, self.y + self.height / 2, nil, self.scaleX, 1, 8, 8)
    --love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    love.graphics.setColor(50 / 255, 168 / 255, 82 / 255, self.healthBarOpacity)
    love.graphics.rectangle('fill', self.x - 4, self.y - 4, 24 * (self.health/100), 2)
    ----test----
    local x,y,w,h = world:getRect(self)
    love.graphics.setColor(1, 1, 1)
    --love.graphics.rectangle('line', x, y, w, h)
end