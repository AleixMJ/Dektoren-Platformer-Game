

local Coin = {}
Coin.__index = Coin
local ActiveCoins = {}
local Player = require("player")

function Coin.new(x,y)
    instance = setmetatable({}, Coin)
    instance.x = x
    instance.y = y
    instance.r = 0
    instance.state = "idle"

    instance.toBeRemoved = false
    
    instance.animation = {timer = 0, rate = 0.1}
    instance.animation.idle = {total = 4, current = 1, img = Coin.idleAnim}
    instance.animation.draw = instance.animation.idle.img[1]

    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y,"static")
    instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.fixture:setSensor(true)
    table.insert(ActiveCoins, instance)

end

function Coin.loadAssets()
    Coin.idleAnim = {}
        for i=1, 4 do
            Coin.idleAnim[i]= love.graphics.newImage("assets/coin/"..i..".png")
        end
    Coin.width = Coin.idleAnim[1]:getWidth()
    Coin.height = Coin.idleAnim[1]:getHeight()
end

function Coin:animate(dt)
    self.animation.timer = self.animation.timer + dt
    if self.animation.timer > self.animation.rate then
       self.animation.timer = 0
       self:setNewFrame()
    end
 end
 
 function Coin:setNewFrame()
    local anim = self.animation[self.state]
    if anim.current < anim.total then
       anim.current = anim.current + 1
    else
       anim.current = 1
    end
    self.animation.draw = anim.img[anim.current]
 end


function Coin:remove()
    for i, instance in ipairs(ActiveCoins) do
        if instance == self then
            self.physics.body:destroy()
            Player:incrementCoins()
            print(Player.coins)
            table.remove(ActiveCoins, i)
        end
    end
end

function Coin:update(dt)
    self:checkRemove()
    self:animate(dt)

end

function Coin:checkRemove()
    if self.toBeRemoved then
      self:remove()
    end
end

function Coin.removeAll()
    for i,v in ipairs(ActiveCoins) do
        v.physics.body:destroy()
    end
    ActiveCoins = {}
end

function Coin:draw()
    love.graphics.draw(self.animation.draw, self.x, self.y, self.r,1,1, self.width /2, self.height /2)
end


function Coin.updateAll(dt)
    for i, instance in ipairs(ActiveCoins) do
        instance:update(dt)
    end


end


function Coin.drawAll()
    for i, instance in ipairs(ActiveCoins) do
        instance:draw()
    end
end

function Coin.beginContact(a, b, collision)
    for i, instance in ipairs(ActiveCoins) do
        if a == instance.physics.fixture or b == instance.physics.fixture then
            if a == Player.physics.fixture or b == Player.physics.fixture then
                instance.toBeRemoved = true
                return true
            end
        end
    end
end

return Coin