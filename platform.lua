
local Platform = {img = love.graphics.newImage("assets/platform.png")}
local Player = require("player")
Platform.__index = Platform

Platform.width = Platform.img:getWidth()
Platform.height = Platform.img:getHeight()
ActivePlatforms = {}


function Platform.new(x,y)
    instance = setmetatable({}, Platform)
    instance.x = x
    instance.y = y
    instance.r = 0
    instance.offsetY = -9
    instance.speed = -100
    instance.xVel = instance.speed
    instance.yVel = 0
    
    
    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y,"kinematic")
    instance.physics.body:setMass(10)
    instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    
    table.insert(ActivePlatforms, instance)

end

function Platform:update(dt)
    self:syncPhysics()
    self:flipDirection(dt)
end



function Platform:syncPhysics()
    self.x, self.y = self.physics.body:getPosition()
    self.physics.body:setLinearVelocity(self.xVel, 0)

end


function Platform:draw()
    love.graphics.draw(self.img, self.x, self.y, self.r,1,1, self.width /2, self.height /2)
end


function Platform.updateAll(dt)
    for i, instance in ipairs(ActivePlatforms) do
        instance:update(dt)
    end


end


function Platform:flipDirection(dt)
    if self.x > MapWidth -20 then
        self.xVel = -100
    elseif self.x < 20 then
        self.xVel = 100
    end
 
 end



function Platform.removeAll()
    for i,v in ipairs(ActivePlatforms) do
        v.physics.body:destroy()
    end
    ActivePlatforms = {}
end

function Platform.drawAll()
    for i, instance in ipairs(ActivePlatforms) do
        instance:draw()
    end
end

return Platform