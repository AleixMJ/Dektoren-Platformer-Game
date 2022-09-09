

local Slime = {}

Slime.__index = Slime
local Player = require("player")

ActiveSlimes = {}

function Slime.new(x,y)
    instance = setmetatable({}, Slime)
    instance.x = x
    instance.y = y
    instance.r = 0
    instance.offsetY = -9
    instance.speed = 50
    instance.xVel = instance.speed

    instance.state = "walk"
    instance.damage = 1

    instance.animation = {timer = 0, rate = 0.1}
    instance.animation.walk = {total = 11, current = 1, img = Slime.walkAnim}
    instance.animation.draw = instance.animation.walk.img[1]

    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y,"dynamic")
    instance.physics.body:setFixedRotation(true)
    instance.physics.shape = love.physics.newRectangleShape(instance.width * 0.8, instance.height * 0.5)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.body:setMass(20)
    table.insert(ActiveSlimes, instance)

end

function Slime.loadAssets()
    Slime.walkAnim = {}
        for i=1, 11 do
            Slime.walkAnim[i]= love.graphics.newImage("assets/slime/walk/"..i..".png")
        end

    Slime.hurtAnim = {}    
        for i=1, 6 do
            Slime.hurtAnim[i]= love.graphics.newImage("assets/slime/hurt/"..i..".png")
    end

    Slime.width = Slime.walkAnim[1]:getWidth()
    Slime.height = Slime.walkAnim[1]:getHeight()

end

function Slime:update(dt)
  self:syncPhysics()
  self:animate(dt)
end


function Slime:flipDirection()
    self.xVel = -self.xVel

end



function Slime:animate(dt)
    self.animation.timer = self.animation.timer + dt
    if self.animation.timer > self.animation.rate then
       self.animation.timer = 0
       self:setNewFrame()
    end
 end
 
 function Slime:setNewFrame()
    local anim = self.animation[self.state]
    if anim.current < anim.total then
       anim.current = anim.current + 1
    else
       anim.current = 1
    end
    self.animation.draw = anim.img[anim.current]
 end

function Slime:syncPhysics()
    self.x, self.y = self.physics.body:getPosition()
    self.physics.body:setLinearVelocity(self.xVel, 100)
end

function Slime:draw()
    local scaleX = 1
    if self.xVel < 0 then
        scaleX = -1
    end
    love.graphics.draw(self.animation.draw, self.x, self.y + self.offsetY, self.r,scaleX,1, self.width /2, self.height /2)
end


function Slime.updateAll(dt)
    for i, instance in ipairs(ActiveSlimes) do
        instance:update(dt)
    end


end

function Slime.removeAll()
    for i,v in ipairs(ActiveSlimes) do
        v.physics.body:destroy()
    end
    ActiveSlimes = {}
end


function Slime.drawAll()
    for i, instance in ipairs(ActiveSlimes) do
        instance:draw()
    end
end

function Slime.beginContact(a, b, collision)
    for i, instance in ipairs(ActiveSlimes) do
        if a == instance.physics.fixture or b == instance.physics.fixture then
            if a == Player.physics.fixture or b == Player.physics.fixture then
                Player:takeDamage(instance.damage)
            end

            instance:flipDirection()
        end
    end
end


return Slime