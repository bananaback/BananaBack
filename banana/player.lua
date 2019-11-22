Player = Object:extend()
-- 16 * 24
function Player:new()
    self.x = 100
    self.y = 200
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
    self.animations.attack = anim8.newAnimation(self.grid2(1, 2), 0.1)
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
end

function Player:update(dt)
    self.anim:update(dt)
    -----
    local function playerFilter(item, other)
        if other.isBlock then return 'slide' 
        elseif other.isLadder then return 'cross' 
        elseif other.isWater then return 'cross' 
        elseif other.isScorpion then return 'cross' end
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
                    self.x = self.x - 20
                    self.vy = -250
                elseif self.x > other.x then
                    self.x = self.x + 20
                    self.vy = -250
                end
                self.hurtDuration = 100
                print('ouch')
            end
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
    elseif self.isGrounded == false and self.touchLadder == false then self.state = 'jump'
    elseif self.attacking and self.hurting == false then self.state = 'attack' 
    elseif self.climbing then self.state = 'climbing'
    end
    ---- ngang nhau
    if self.state == 'hurt' then self.anim = self.animations.hurt
    elseif self.state == 'idle' then self.anim = self.animations.idle 
    elseif self.state == 'walk' then self.anim = self.animations.walk
    elseif self.state == 'jump' then self.anim = self.animations.jump
    elseif self.state == 'attack' then self.anim = self.animations.attack
    elseif self.state == 'climbing' then self.anim = self.animations.climb
    end
end

function Player:draw()
    love.graphics.setColor(1, 1, 1)
    self.anim:draw(self.sprite, self.x + self.width / 2, self.y + self.height / 2, nil, self.scaleX, 1, 8, 12)
    --love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
end