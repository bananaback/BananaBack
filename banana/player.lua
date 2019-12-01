Player = Object:extend()
-- 16 * 24
function Player:new()
    self.x = 50
    self.y = 0
    self.width = 16
    self.height = 24
    self.scaleX = -1
    ------
    self.sprite = love.graphics.newImage('art/basicgame.png')
    self.sprite2 = love.graphics.newImage('art/slidewall.png')
    self.grid = anim8.newGrid(self.width, self.height, self.sprite:getWidth(), self.sprite:getHeight())
    self.grid2 = anim8.newGrid(24, 24, self.sprite:getWidth(), self.sprite:getHeight())
    self.grid3 = anim8.newGrid(16, 24, 16, 24)
    self.animations = {}
    self.animations.hurt = anim8.newAnimation(self.grid('1-2', 1), 0.1)
    self.animations.idle = anim8.newAnimation(self.grid(2, 1), 0.1) 
    self.animations.walk = anim8.newAnimation(self.grid('3-6', 1), 0.1)
    self.animations.jump = anim8.newAnimation(self.grid(7, 1), 0.1)
    self.animations.attack = anim8.newAnimation(self.grid2(6, 4), 0.1)
    self.animations.windattack = anim8.newAnimation(self.grid2(5, 5), 0.1)
    self.animations.waterattack = anim8.newAnimation(self.grid2(7, 5), 0.1)
    self.animations.fireattack = anim8.newAnimation(self.grid2(6, 5), 0.1)
    self.animations.climb = anim8.newAnimation(self.grid('8-9', 1), 0.1)
    self.anim = self.animations.idle
    ------
    world:add(self, self.x, self.y, self.width, self.height)
    ------
    self.vx = 0 
    self.vy = 200
    
    self.state = ""
    self.isGrounded = false
    self.relax = false
    self.walking = false
    self.attacking = false
    self.attackDuration = 0
    self.trueDistance = 0
    self.climbing = false
    self.hurtDuration = 0
    self.canMove = true
    
    -----
    self.image = love.graphics.newImage("art/playerbarss_1.png")
    self.mask = love.graphics.newImage("art/mymask.png")

    --quads, each quad contains between 1 and i bars
    self.quads = { }
    for i = 1, 20 do
        self.quads[i] = love.graphics.newQuad((i-1)*8, 0, 160 - i*8, 16, 160, 16)
    end
    self.quads[0] = love.graphics.newQuad(0, 0, 160, 16, 160, 16)
    
    self.health = 20
    self.blueEnergy = 20
    self.greenEnergy = 20
    --- alertbar
    self.alertbar = love.graphics.newImage('art/alertbar.png')
    self.alertgrid = anim8.newGrid(32, 20, self.alertbar:getWidth(), self.alertbar:getHeight())
    self.alertAnimations = {}
    self.alertAnimations.alert1 = anim8.newAnimation(self.alertgrid('1-2', 1), 0.1)
    self.alertAnimations.alert2 = anim8.newAnimation(self.alertgrid('3-4', 1), 0.1)
    self.alertAnimations.alert3 = anim8.newAnimation(self.alertgrid('5-6', 1), 0.1)

    self.alert1State = "pause"
    self.alert2State = "pause"
    self.alert3State = "pause"
    
    self.currentWeapon = "firePunch"
    
    self.alert1Timer = Timer.new()
    self.alert2Timer = Timer.new()
    self.alert3Timer = Timer.new()
    self.reloadGreenTimer = Timer.new()
    self.reloadGreenTimer:every(1, function() if self.greenEnergy < 20 then self.greenEnergy = self.greenEnergy + 1 end end)
    self.reloadBlueTimer = Timer.new()
    self.reloadBlueTimer:every(1, function() if self.blueEnergy < 20 then self.blueEnergy = self.blueEnergy + 1 end end)
    self.regenHealthTimer = Timer.new()
    self.regenHealthTimer:every(5, function() if self.health < 20 then self.health = self.health + 1 end end)
    
    self.burnTime = 0
    self.isBurning = true
    self.burnEffectTimer = Timer.new()
    self.burnEffectTimer:every(0.2, function() 
        if self.isBurning then
            --self.health = self.health - 0.1
            self.healthBarOpacity = 100
            table.insert(listOfPopUps, PopUp(self.x + self.width / 2 + love.math.random(-8, 8), self.y + self.height / 2 + love.math.random(-8, 8), '(#)', 5, 2.5, 'orange', 0.2))
            table.insert(listOfPopUps, PopUp(self.x + self.width / 2 + love.math.random(-8, 8), self.y + self.height / 2 + love.math.random(-8, 8), '(#)', 5, 2.5, 'orange', 0.2))
        end end)
      
    self.burnTimer = Timer.new()
    self.burnTimer:every(2, function() 
        if self.isBurning then
            if self.health > 0 then self.health = self.health - 1 end
            self.alert1State = "resume"
            self.alert1Timer:after(0.5, function() player.alert1State = "pause" end)
        end end)
end

function Player:update(dt)
    if self.burnTime > 0 then
        self.burnTime = self.burnTime - 1
        self.isBurning = true
    else
        self.isBurning = false
    end
    
    self.anim:update(dt)
    self.burnEffectTimer:update(dt)
    self.burnTimer:update(dt)
    self.alert1Timer:update(dt)
    self.alert2Timer:update(dt)
    self.alert3Timer:update(dt)
    self.reloadGreenTimer:update(dt)
    self.reloadBlueTimer:update(dt)
    self.regenHealthTimer:update(dt)
    self.alertAnimations.alert1:update(dt)
    self.alertAnimations.alert2:update(dt)
    self.alertAnimations.alert3:update(dt)

    if self.alert1State == "pause" then
        self.alertAnimations.alert1:pauseAtStart()  
    else 
        self.alertAnimations.alert1:resume()
    end
    if self.alert2State == "pause" then
        self.alertAnimations.alert2:pauseAtStart()  
    else 
        self.alertAnimations.alert2:resume()
    end
    if self.alert3State == "pause" then
        self.alertAnimations.alert3:pauseAtStart()  
    else 
        self.alertAnimations.alert3:resume()
    end
    -----
    local function playerFilter(item, other)
        if other.isBlock then return 'slide' 
        elseif other.isLadder then return 'cross' 
        elseif other.isWater then return 'cross' 
        elseif other.isScorpion then return 'cross' 
        elseif other.isCoin then return 'cross'end
    end
    
    ------
    if love.keyboard.isDown('a') and self.attacking == false and self.canMove then
        self.vx = -70
    elseif love.keyboard.isDown('d') and self.attacking == false and self.canMove then
        self.vx = 70
    else
        self.vx = 0
    end
    ---
    if self.touchLadder then
        self.anim:pause()
        if love.keyboard.isDown('w') and self.trueDistance < 23 then
            self.vy = -50
            self.anim:resume()
        elseif love.keyboard.isDown('s') then
            self.vy = 50
            self.anim:resume()
        else
            self.vy = 0
            self.anim:pause()
        end
        self.climbing = true
    else
        self.anim:resume()
        self.climbing = false
        if self.vy < 200 then
            self.vy = self.vy + 20
        end
    
    end
    -----
    local goalX, goalY = self.x + self.vx * dt, self.y + self.vy * dt 
    local actualX, actualY, cols, len = world:move(self, goalX, goalY, playerFilter)
    self.x, self.y = actualX, actualY
    -- deal with the collisions 
    if len == 0 then
        self.touchLadder = false
    end
    
    for i=1,len do
        local other = cols[i].other
        if other.isBlock and self.y < other.y then
            self.isGrounded = true
        end
        if other.isWater then
            
        else
            
        end
        if other.isScorpion then
            if self.hurting == false and (other.state == 'idleleft' or other.state == 'idleright') then
                if self.x < other.x then
                    --self.x = self.x - 20
                    --self.vy = -250
                elseif self.x > other.x then
                    --self.x = self.x + 20
                    --self.vy = -250
                end
                if self.health > 0 then 
                    self.health = self.health - 1
                end
                self.alert1State = "resume"
                self.alert1Timer:after(1, function() self.alert1State = "pause" end)
                self.hurtDuration = 100
                local listOfSaying = {"ouch", "it's hurt!", "becareful!", "I hate scorpion!"}
                table.insert(listOfPopUps, PopUp(self.x, self.y, '-1', 15, 3, 'red', 1))
                table.insert(listOfPopUps, PopUp(self.x, self.y, listOfSaying[math.random(1, #listOfSaying)], 10, 2, 'blue', 0.5))
                print('ouch')
            end
            if other.isBurning then
                self.burnTime = 150
            end
            if self.isBurning then
                other.burnTime = 150
            end
        end
        if other.isCoin and other.bounceTime >= 3 then
            table.insert(listOfPopUps, PopUp(other.x, other.y, '+1', 5, 2.5, 'yellow', 1))
            other:boom()
        end
    end
    -----
    local items, len = world:queryPoint(self.x + self.width / 2, self.y + self.height, filter)
    if len == 0 then
        self.touchLadder = false
        self.trueDistance = 0
    else
        for i = 1, len do 
            if items[i].isLadder then 
                self.touchLadder = true
                self.trueDistance = items[i].y - self.y
            end
        end
    end
    -----
    if self.isGrounded and self.vx == 0 and self.attacking == false then
        self.relax = true
    else
        self.relax = false
    end
    
    if self.isGrounded and love.keyboard.isDown('a') and self.attacking == false then
        self.walking = true 
        self.scaleX = -1
    elseif self.isGrounded and love.keyboard.isDown('d') and self.attacking == false then
        self.walking = true
        self.scaleX = 1
    else
        self.walking = false
    end
    
    if self.attackDuration > 0 then
        self.attacking = true
        self.attackDuration = self.attackDuration - 2
    else
        self.attacking = false
    end
    
    if self.hurtDuration > 0 then
        self.hurting = true
        self.hurtDuration = self.hurtDuration - 1
        --self.canMove = false
        
    else
        self.hurting = false
        --self.canMove = true
    end
    -----
    if self.hurting then self.state = 'hurt'
    elseif self.relax then self.state = 'idle'
    elseif self.walking then self.state = 'walk' 
    elseif self.isGrounded == false and self.touchLadder == false and self.attacking == false then self.state = 'jump'
    elseif self.attacking and self.hurting == false then self.state = 'attack' 
    elseif self.climbing then self.state = 'climbing'
    end
    ---- ngang nhau
    if self.state == 'hurt' then self.anim = self.animations.hurt
    elseif self.state == 'idle' then self.anim = self.animations.idle 
    elseif self.state == 'walk' then self.anim = self.animations.walk
    elseif self.state == 'jump' then self.anim = self.animations.jump
    elseif self.state == 'attack' then 
    if self.currentWeapon == 'windBullet1' or self.currentWeapon == 'windPunch' then
        self.anim = self.animations.windattack
    elseif self.currentWeapon == 'normalPunch' then
        self.anim = self.animations.attack
    elseif self.currentWeapon == 'fireBullet1' or self.currentWeapon == 'firePunch' then
        self.anim = self.animations.fireattack
    elseif self.currentWeapon == 'waterBullet1' or self.currentWeapon == 'waterPunch' then
        self.anim = self.animations.waterattack
    end
    elseif self.state == 'climbing' then self.anim = self.animations.climb
    end
end

function Player:draw()
    love.graphics.setColor(1, 1, 1)
    self.anim:draw(self.sprite, self.x + self.width / 2, self.y + self.height / 2, nil, self.scaleX, 1, 8, 12)
    --love.graphics.rectangle('line', self.x, self.y, self.width, self.height
end

function Player:draw2()
  love.graphics.setColor(1, 1, 1)
    local bars_1 = self.health -- math.ceil(health_1 * 20) --20 bars in total, inverted since we mask it
    local bars_2 = self.blueEnergy
    local bars_3 = self.greenEnergy
    --just some scaling
    love.graphics.push()
    love.graphics.scale(2)
    
    love.graphics.draw(self.image)
    
    --handle negative values and overflows
    if bars_1 >= 0 and bars_1 <= 20 then
        --i used the power of photoshop to get the position of the (first) bar relative to the base image
        love.graphics.draw(self.mask, self.quads[bars_1], 85 + 8*bars_1, 4)
    end
    if bars_2 >= 0 and bars_2 <= 20 then
        --i used the power of photoshop to get the position of the (first) bar relative to the base image
        love.graphics.draw(self.mask, self.quads[bars_2], 85 + 8*bars_2, 4+20)
    end
    if bars_3 >= 0 and bars_3 <= 20 then
        --i used the power of photoshop to get the position of the (first) bar relative to the base image
        love.graphics.draw(self.mask, self.quads[bars_3], 85 + 8*bars_3, 24 + 20)
    end
    love.graphics.pop()
    love.graphics.setColor(1, 1, 1)
    ---
    local font = love.graphics.newFont(32) -- the number denotes the font size
    love.graphics.setFont(font)
    love.graphics.print(self.currentWeapon, 750, 600)
    ---
    self.alertAnimations.alert1:draw(self.alertbar, 500-8, 4, nil, 2, 2)
    self.alertAnimations.alert2:draw(self.alertbar, 500-8, 44, nil, 2, 2)
    self.alertAnimations.alert3:draw(self.alertbar, 500-8, 84, nil, 2, 2)
    
end