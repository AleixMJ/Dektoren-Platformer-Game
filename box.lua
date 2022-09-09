

local Box = {img = love.graphics.newImage("assets/box.png")}
Box.__index = Box

Box.width = Box.img:getWidth()
Box.height = Box.img:getHeight()
ActiveBoxes = {}

function Box.new(x,y)
    instance = setmetatable({}, Box)
    instance.x = x
    instance.y = y
    instance.r = 0


    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y,"dynamic")
    instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.body:setMass(20)
    table.insert(ActiveBoxes, instance)

end

function Box:update(dt)
  self:syncPhysics()
end

function Box:syncPhysics()
    self.x, self.y = self.physics.body:getPosition()
    self.r = self.physics.body:getAngle()
end

function Box:draw()
    love.graphics.draw(self.img, self.x, self.y, self.r,1,1, self.width /2, self.height /2)
end


function Box.updateAll(dt)
    for i, instance in ipairs(ActiveBoxes) do
        instance:update(dt)
    end


end

function Box.removeAll()
    for i,v in ipairs(ActiveBoxes) do
        v.physics.body:destroy()
    end

    ActiveBoxes = {}
end

function Box.drawAll()
    for i, instance in ipairs(ActiveBoxes) do
        instance:draw()
    end
end

return Box