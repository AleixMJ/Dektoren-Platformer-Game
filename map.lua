local Map = {}
local STI = require("sti")
local Box = require("box")
local Spikes = require("spikes")
local Coin = require("coin")
local Vampire = require("vampire")
local Slime = require("slime")
local Golem = require("golem")
local Platform = require("platform")
local Player = require("player")
local Camera = require("camera")


function Map:load()
    self.currentLevel = 1

    World = love.physics.newWorld(0,2000)
    World:setCallbacks(beginContact, endContact)
    

    self:init()
    
end

function Map:init()
    self.level = STI("map/"..self.currentLevel..".lua", {"box2d"})

    self.level:box2d_init(World)
    self.solidLayer = self.level.layers.solid
    self.groundLayer = self.level.layers.ground
    self.entityLayer = self.level.layers.entity
    self.climbLayer = self.level.layers.climb
 

    self.solidLayer.visible = false
    self.entityLayer.visible = false
    self.climbLayer.visible = false
    MapWidth = self.groundLayer.width * 16
    MapHeight = self.groundLayer.height * 16
    MapClimbable = self.climbLayer
    
    
    background = love.graphics.newImage("map/background/"..self.currentLevel..".png")
    self:spawnEntities()
    
    love.audio.stop()
    Music = {}
    Music.music = love.audio.newSource("sounds/music/"..self.currentLevel..".mp3", "stream")
    Music.music:setLooping(true)
    Music.music:play()
   

end

function Map:next()
    self:clean()
    self.currentLevel = self.currentLevel + 1
    self:init()
    Player:resetPosition()
    Camera:setPosition(Camera.x,Camera.y)
end

function Map:clean()
    self.level:box2d_removeLayer("solid")
    Coin.removeAll()
    Platform.removeAll()
    Slime.removeAll()
    Vampire.removeAll()
    Golem.removeAll()
    Spikes.removeAll()
    Box.removeAll()
end

function Map:update(dt)
    if Player.x > MapWidth -10 then
        self:next()
    end

    if Player.alive == false then
        self:restart()
    end
end

function Map:spawnEntities()
    for i,v in ipairs(self.entityLayer.objects) do
        if v.class == "box" then
            Box.new(v.x + v.width / 2, v.y + v.height /2)
        elseif v.class == "coin" then
            Coin.new(v.x, v.y)
        elseif v.class == "spikes" then
            Spikes.new(v.x + v.width / 2, v.y + v.height /2)
        elseif v.class == "slime" then
            Slime.new(v.x + v.width / 2, v.y + v.height /2)
        elseif v.class == "golem" then
            Golem.new(v.x + v.width / 2, v.y + v.height /2)
        elseif v.class == "vampire" then
            Vampire.new(v.x + v.width / 2, v.y + v.height /2)
        elseif v.class == "platform" then
            Platform.new(v.x + v.width / 2, v.y + v.height /2)
        end
    end
end

function Map:restart()
    self:clean()
    self:init()
    Player.coins = 0

end

return Map