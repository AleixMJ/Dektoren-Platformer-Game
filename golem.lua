

local Golem = {}

Golem.__index = Golem
local Player = require("player")

ActiveGolems = {}

function Golem.new(x,y)
    instance = setmetatable({}, Golem)
    instance.x = x
    instance.y = y
    instance.r = 0
    instance.offsetY = -9
    instance.speed = 250
    instance.xVel = instance.speed

    instance.state = "walk"
    instance.damage = 2

    instance.animation = {timer = 0, rate = 0.1}
    instance.animation.walk = {total = 4, current = 1, img = Golem.walkAnim}
    instance.animation.draw = instance.animation.walk.img[1]

    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y,"dynamic")
    instance.physics.body:setFixedRotation(true)
    instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.body:setMass(0)
    table.insert(ActiveGolems, instance)

end

function Golem.loadAssets()
    Golem.walkAnim = {}
        for i=1, 4 do
            Golem.walkAnim[i]= love.graphics.newImage("assets/golem/walk/"..i..".png")
        end
    Golem.width = Golem.walkAnim[1]:getWidth()
    Golem.height = Golem.walkAnim[1]:getHeight()

end

function Golem:update(dt)
  self:syncPhysics()
  self:animate(dt)
end


function Golem:flipDirection()
    self.xVel = -self.xVel

end



function Golem:animate(dt)
    self.animation.timer = self.animation.timer + dt
    if self.animation.timer > self.animation.rate then
       self.animation.timer = 0
       self:setNewFrame()
    end
 end
 
 function Golem:setNewFrame()
    local anim = self.animation[self.state]
    if anim.current < anim.total then
       anim.current = anim.current + 1
    else
       anim.current = 1
    end
    self.animation.draw = anim.img[anim.current]
 end

function Golem:syncPhysics()
    self.x, self.y = self.physics.body:getPosition()
    self.physics.body:setLinearVelocity(self.xVel, 200)
end

function Golem:draw()
    local scaleX = 1
    if self.xVel < 0 then
        scaleX = -1
    end
    love.graphics.draw(self.animation.draw, self.x, self.y + self.offsetY, self.r,scaleX,1, self.width /2, self.height /2)
end


function Golem.updateAll(dt)
    for i, instance in ipairs(ActiveGolems) do
        instance:update(dt)
    end


end

function Golem.removeAll()
    for i,v in ipairs(ActiveGolems) do
        v.physics.body:destroy()
    end
    ActiveGolems = {}
end


function Golem.drawAll()
    for i, instance in ipairs(ActiveGolems) do
        instance:draw()
    end
end

function Golem.beginContact(a, b, collision)
    for i, instance in ipairs(ActiveGolems) do
        if a == instance.physics.fixture or b == instance.physics.fixture then
            if a == Player.physics.fixture or b == Player.physics.fixture then
                Player:takeDamage(3)
            end

            instance:flipDirection()
        end
    end
end


return Golem