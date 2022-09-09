
local Vampire = {}

Vampire.__index = Vampire
local Player = require("player")

ActiveVampires = {}

function Vampire.new(x,y)
    instance = setmetatable({}, Vampire)
    instance.x = x
    instance.y = y
    instance.r = 0
    instance.offsetY = -9
    instance.speed = 150
    instance.xVel = instance.speed

    instance.state = "flight"
    instance.damage = 1

    instance.animation = {timer = 0, rate = 0.1}
    instance.animation.flight = {total = 8, current = 1, img = Vampire.flightAnim}
    instance.animation.draw = instance.animation.flight.img[1]

    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y,"kinematic")
    instance.physics.body:setFixedRotation(true)
    instance.physics.shape = love.physics.newRectangleShape(instance.width * 0.8, instance.height * 0.5)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.body:setMass(0)
    table.insert(ActiveVampires, instance)

end

function Vampire.loadAssets()
    Vampire.flightAnim = {}
        for i=1, 8 do
            Vampire.flightAnim[i]= love.graphics.newImage("assets/vampire/flight/"..i..".png")
        end

    Vampire.width = Vampire.flightAnim[1]:getWidth()
    Vampire.height = Vampire.flightAnim[1]:getHeight()

end

function Vampire:update(dt)
  self:syncPhysics()
  self:animate(dt)
  self:flipDirection(dt)
end


function Vampire:flipDirection(dt)
    if self.x > MapWidth -20 then
        self.xVel = -150
    elseif self.x < 20 then
        self.xVel = 150
    end
 
 end



function Vampire:animate(dt)
    self.animation.timer = self.animation.timer + dt
    if self.animation.timer > self.animation.rate then
       self.animation.timer = 0
       self:setNewFrame()
    end
 end
 
 function Vampire:setNewFrame()
    local anim = self.animation[self.state]
    if anim.current < anim.total then
       anim.current = anim.current + 1
    else
       anim.current = 1
    end
    self.animation.draw = anim.img[anim.current]
 end

function Vampire:syncPhysics()
    self.x, self.y = self.physics.body:getPosition()
    self.physics.body:setLinearVelocity(self.xVel, 0)
end

function Vampire:draw()
    local scaleX = 1
    if self.xVel < 0 then
        scaleX = -1
    end
    love.graphics.draw(self.animation.draw, self.x, self.y + self.offsetY, self.r,scaleX,1, self.width /2, self.height /2)
end


function Vampire.updateAll(dt)
    for i, instance in ipairs(ActiveVampires) do
        instance:update(dt)
    end


end

function Vampire.removeAll()
    for i,v in ipairs(ActiveVampires) do
        v.physics.body:destroy()
    end
    ActiveVampires = {}
end


function Vampire.drawAll()
    for i, instance in ipairs(ActiveVampires) do
        instance:draw()
    end
end

function Vampire.beginContact(a, b, collision)
    for i, instance in ipairs(ActiveVampires) do
        if a == instance.physics.fixture or b == instance.physics.fixture then
            if a == Player.physics.fixture or b == Player.physics.fixture then
                Player:takeDamage(instance.damage)
            end

            instance:flipDirection()
        end
    end
end


return Vampire