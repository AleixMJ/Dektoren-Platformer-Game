
local Player = require("player")
local Spikes = {img = love.graphics.newImage("assets/spikes.png")}
Spikes.__index = Spikes

Spikes.width = Spikes.img:getWidth()
Spikes.height = Spikes.img:getHeight()
ActiveSpikes = {}

function Spikes.new(x,y)
    instance = setmetatable({}, Spikes)
    instance.x = x
    instance.y = y

    instance.damage = 1

    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y,"static")
    instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.fixture:setSensor(true)
    table.insert(ActiveSpikes, instance)

end

function Spikes:update(dt)
  
end

function Spikes:draw()
    love.graphics.draw(self.img, self.x, self.y, 0,1,1, self.width /2, self.height /2)
end


function Spikes.updateAll(dt)
    for i, instance in ipairs(ActiveSpikes) do
        instance:update(dt)
    end


end

function Spikes.removeAll()
    for i,v in ipairs(ActiveSpikes) do
        v.physics.body:destroy()
    end
    ActiveSpikes = {}
end

function Spikes.drawAll()
    for i, instance in ipairs(ActiveSpikes) do
        instance:draw()
    end
end

function Spikes.beginContact(a, b, collision)
    for i, instance in ipairs(ActiveSpikes) do
        if a == instance.physics.fixture or b == instance.physics.fixture then
            if a == Player.physics.fixture or b == Player.physics.fixture then
                Player:takeDamage(instance.damage)
                return true
            end
        end
    end
end

return Spikes