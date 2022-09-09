local Camera = {
    x = 0,
    y = 0,
    scale = 2,
}

function Camera:apply()
    love.graphics.push()
    love.graphics.scale(self.scale,self.scale)
    love.graphics.translate(-self.x, -self.y)
end

function Camera:clear()
    love.graphics.pop()
end

function Camera:setPosition(x, y)
    self.x = x - love.graphics.getWidth() / 2 / self.scale
    self.y = y - love.graphics.getHeight() / 2 / self.scale
    local rightScreen = self.x + love.graphics.getWidth() / 2
    local topScreen = love.graphics.getHeight() / 2

    if self.x < 0 then
        self.x = 0
    elseif rightScreen > MapWidth then
        self.x = MapWidth - love.graphics.getWidth() /2
    end

    if self.y > (MapHeight - topScreen) then
        self.y = MapHeight - topScreen
 
    end
end


return Camera