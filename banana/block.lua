Block = Object:extend()

function Block:new(x, y, name)
    self.x = x
    self.y = y
    self.width = 16
    self.height = 16
    
    
    world:add(self, self.x, self.y, self.width, self.height)
    self.sprite = love.graphics.newImage('art/tiles.png')
    self.grid = anim8.newGrid(16, 16, self.sprite:getWidth(), self.sprite:getHeight())
    self.animations = {}
    self.animations.tile1 = anim8.newAnimation(self.grid(2, 4), 0.1)
    self.animations.tile2 = anim8.newAnimation(self.grid(21, 2), 0.1)
    self.name = name
    if self.name == 'dirtmid' then
        self.anim = self.animations.tile1
        self.isBlock = true
        self.isWater = false
    elseif self.name == 'water' then
        self.anim = self.animations.tile2
        self.isWater = true
        self.isBlock = false
    else
      
    end
end

function Block:update(dt)
    self.anim:update(dt)
end

function Block:draw()
    love.graphics.setColor(255, 255, 255)
    self.anim:draw(self.sprite, self.x, self.y)
end