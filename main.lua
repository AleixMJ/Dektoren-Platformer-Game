love.graphics.setDefaultFilter("nearest","nearest")
local Player = require("player")
local GUI = require("gui")
local Box = require("box")
local Spikes = require("spikes")
local Coin = require("coin")
local Slime = require("slime")
local Golem = require("golem")
local Vampire = require("vampire")
local Platform = require("platform")
local Camera = require("camera")
local Map = require("map")


function love.load()
    Slime.loadAssets()
    Golem.loadAssets()
    Vampire.loadAssets()
    Coin.loadAssets()
    Map:load()
    Player:load()
    GUI:load()

    
end

function love.update(dt)
    World:update(dt)
    Player:update(dt)
    Box.updateAll(dt)
    Platform.updateAll(dt)
    Spikes.updateAll(dt)
    Vampire.updateAll(dt)
    Coin.updateAll(dt)
    Slime.updateAll(dt)
    Golem.updateAll(dt)
    GUI:update(dt)
    Camera:setPosition(Player.x, Player.y)
    Map:update()
  end

function love.draw()
    love.graphics.draw(background)
    Map.level:draw(-Camera.x, -Camera.y, Camera.scale, Camera.scale)
    Camera:apply()
    Player:draw()
    Spikes:drawAll()
    Vampire:drawAll()
    Box:drawAll()
    Platform:drawAll()
    Coin:drawAll()
    Slime:drawAll()
    Golem.drawAll()
    Camera:clear()
    
    GUI:draw()
end

function love.keypressed(key)
    Player:jump(key)
end


function beginContact(a, b, Collision)
    if Coin.beginContact(a, b, Collision) then return end
    if Spikes.beginContact(a, b, Collision) then return end
    Slime.beginContact(a, b, Collision)
    Vampire.beginContact(a, b, Collision)
    Golem.beginContact(a, b, Collision)
    Player:beginContact(a, b, Collision)

end

function endContact(a, b, Collision)
    Player: endContact(a, b, Collision)
end
