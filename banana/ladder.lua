Ladder = Object:extend()

function Ladder:new(x, y)
    self.x = x
    self.y = y
    
    world:add(self, self.x, self.y , 16, 32)
    
    self.sprite = love.graphics.newImage('art/ladder.png')
    self.grid = anim8.newGrid(16, 32, 32, 32)
    self.animations = {}
    self.animations.yellow = anim8.newAnimation(self.grid(1, 1), 0.1)
    self.animations.gray = anim8.newAnimation(self.grid(2, 1), 0.1)
    self.anim = self.animations.yellow
    self.isLadder = true
end

function Ladder:update(dt)
    self.anim:update(dt)
end

function Ladder:draw()
    love.graphics.setColor(255, 255, 255)
    self.anim:draw(self.sprite, self.x, self.y)
end