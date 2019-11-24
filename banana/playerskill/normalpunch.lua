NormalPunch = Object:extend()

function NormalPunch:new(x, y, direction)
    self.x = x
    self.y = y
    self.width = 16
    self.height = 8
    self.scaleX = direction
    
    world:add(self, self.x, self.y, self.width, self.height)
    self.sprite = love.graphics.newImage('art/basicgame.png')
    self.grid = anim8.newGrid(self.width, self.height, self.sprite:getWidth(),self.sprite:getHeight())
    self.anim = anim8.newAnimation(self.grid(1, 9), 0.1)
    self.lifeTime = 3
    self.vx = 0
    self.vy = 0
end

function NormalPunch:update(dt)
    self.anim:update(dt)
    
    local function normalPunchFilter(item, other)
        if other.isBlock then return 'cross' 
        elseif other.isScorpion then return 'cross' end
        
    end
    local goalX, goalY = self.x + self.vx * dt, self.y + self.vy * dt
    local actualX, actualY, cols, len = world:move(self, goalX, goalY, normalPunchFilter)
    self.x, self.y = actualX, actualY
    
    for i = 1, len do
        local other = cols[i].other
        if other.isScorpion then
            if self.scaleX == other.scaleX then
                table.insert(listOfPopUps, PopUp(other.x + 8 + math.random(-2, 2), self.y, 1, 5, 2.5, 'white', 1))
                other.health = other.health - 1
                other.healthBarOpacity = 100
            elseif self.scaleX ~= other.scaleX then
                table.insert(listOfPopUps, PopUp(other.x + 8 + math.random(-2, 2), self.y, 3, 10, 2.5, 'yellow', 1))
                other.health = other.health - 3
                other.healthBarOpacity = 100
                addRandomCoin(self.x, self.y, love.math.random(1, 2))
            end
            self:boom()
            
        end
    end
    
    self.lifeTime = self.lifeTime - 1
    if self.lifeTime <= 0 then
        self:boom()
    end
end

function addRandomCoin(x, y, coinNum)
    spawnX = x
    spawnY = y
    coinNumber = coinNum
    t = {-6, -5, 5, 6}
    t2 = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18}
    t3 = {"fast", "medium", "slow"}
    --- ranNum to To determine the type of coin to be created
    --- Series t contains the X velocities of the generated coin
    for i = 1, coinNumber do
        table.insert(listOfCoins, Coin(spawnX, spawnY, t2[love.math.random(1, #t2)], t[love.math.random(1, #t)], t3[love.math.random(1, #t3)]))
    end
end

function NormalPunch:boom()
    for norpunchnum, norpunchnow in ipairs(listOfBullets) do
	      if norpunchnow == self then
            world:remove(self)
            table.remove(listOfBullets, norpunchnum) 
            break 
        end
    end
end

function NormalPunch:draw()
    self.anim:draw(self.sprite, self.x + self.width / 2, self.y + self.height / 2, nil, self.scaleX, 1, 8, 4)
    --love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
end