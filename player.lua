local Player = {}



function Player:load()
   self.x = 100
   self.y = MapHeight - 100
   self.startX = self.x
   self.startY = self.y
   self.width = 10
   self.height = 40
   self.xVel = 0
   self.yVel = 0
   self.maxSpeed = 200
   self.acceleration = 4000
   self.friction = 3500
   self.gravity = 1500
   self.jumpAmount = -400
   self.coins = 0
   self.health = {current = 3, max = 3}

   self.graceTime = 0
   self.graceDuration = 0.5

   self.color = {
      red = 1,
      green = 1,
      blue = 1,
      speed = 3,
   }

   self.alive = true
   self.grounded = false
   self.canDoubleJump = true
   self.climbing = false
   self.freeToMove = true

   self.direction = "right"
   self.state = "idle"

   self:loadAssets()

   self.physics = {}
   self.physics.body = love.physics.newBody(World, self.x, self.y, "dynamic")
   self.physics.body:setFixedRotation(true)
   self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
   self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
   self.physics.body:setGravityScale(0)

   Sounds = {}
   Sounds.takeDamage = love.audio.newSource("sounds/takeDamage.mp3", "static")
   Sounds.gameOver = love.audio.newSource("sounds/gameOver.mp3", "static")
   Sounds.coin = love.audio.newSource("sounds/coin.wav", "static")
   Sounds.jump = love.audio.newSource("sounds/jump.mp3", "static")
   end

function Player:loadAssets()
   self.animation = {timer = 0, rate = 0.1}

   self.animation.run = {total = 8, current = 1, img = {}}
   for i=1, self.animation.run.total do
      self.animation.run.img[i] = love.graphics.newImage("assets/player/run/"..i..".png")
   end

   self.animation.idle = {total = 6, current = 1, img = {}}
   for i=1, self.animation.idle.total do
      self.animation.idle.img[i] = love.graphics.newImage("assets/player/idle/"..i..".png")
   end

   self.animation.jump = {total = 3, current = 1, img = {}}
   for i=1, self.animation.jump.total do
      self.animation.jump.img[i] = love.graphics.newImage("assets/player/jump/"..i..".png")
   end

   self.animation.climb = {total = 8, current = 1, img = {}}
   for i=1, self.animation.climb.total do
      self.animation.climb.img[i] = love.graphics.newImage("assets/player/climb/"..i..".png")
   end

   self.animation.draw = self.animation.idle.img[1]
   self.animation.width = self.animation.draw:getWidth()
   self.animation.height = self.animation.draw:getHeight()
end


function Player:die(dt)
   Sounds.takeDamage:stop()
   Sounds.gameOver:play()
   Player.alive = false
   print("Player died")
   self:wait(3)
end


function Player:fall(dt)
   if self.y > MapHeight then
      self:die(dt)
   end

end

function Player:gameOver(dt)
   if self.health.current < 1 then
      self:die(dt)
         end

end

function Player:takeDamage(amount)
   self:tintRed()
   Sounds.takeDamage:play()
   if self.health.current - amount > 0 then
      self.health.current = self.health.current - amount
   else
      self.health.current = 0
   end
end


function Player:respawn()
   if not Player.alive then
      Player:resetPosition()
      Player.health.current = Player.health.max
      Player.alive = true
   end

end

function Player:resetPosition()
   Player.physics.body:setPosition(self.startX, MapHeight - 100)
end

function Player:tintRed()
   self.color.green = 0
   self.color.blue = 0

end

function Player:incrementCoins(dt)
   Sounds.coin:stop()
   Sounds.coin:play()
   self.coins = self.coins + 1

end

function Player:update(dt)
   self:unTint(dt)
   self:respawn()
   self:setState()
   self:setDirection()
   self:animate(dt)
   self:decreaseGraceTime(dt)
   self:syncPhysics()
   self:move(dt)
   self:applyGravity(dt)
   self:fall(dt)
   self:gameOver(dt)
end


function Player:unTint(dt)
   self.color.red = math.min(self.color.red + self.color.speed * dt, 1)
   self.color.green = math.min(self.color.green + self.color.speed * dt, 1)
   self.color.blue = math.min(self.color.blue + self.color.speed * dt, 1)

end

function Player:setState()
   if not self.grounded then
      self.state = "jump"
   elseif self.climbing == true then
      self.state = "climb"
   elseif self.xVel == 0 then
      self.state = "idle"
   else
      self.state = "run"
   end
end

function Player:setDirection()
   if self.xVel < 0 then
      self.direction = "left"
   elseif self.xVel > 0 then
      self.direction = "right"
   end
end

function Player:animate(dt)
   self.animation.timer = self.animation.timer + dt
   if self.animation.timer > self.animation.rate then
      self.animation.timer = 0
      self:setNewFrame()
   end
end

function Player:setNewFrame()
   local anim = self.animation[self.state]
   if anim.current < anim.total then
      anim.current = anim.current + 1
   else
      anim.current = 1
   end
   self.animation.draw = anim.img[anim.current]
end

function Player:decreaseGraceTime(dt)
   if not self.grounded then
      self.graceTime = self.graceTime - dt
   end
end

function Player:applyGravity(dt)
   if not self.grounded and not self.climbing then
      self.yVel = self.yVel + self.gravity * dt
   end
end

function Player:move(dt)
   if self.freeToMove then
      if love.keyboard.isDown("d", "right") then
         self.xVel = math.min(self.xVel + self.acceleration * dt, self.maxSpeed)
      elseif love.keyboard.isDown("a", "left") then
         self.xVel = math.max(self.xVel - self.acceleration * dt, -self.maxSpeed)
      else
         self:applyFriction(dt)
      end
   end
end

function Player:applyFriction(dt)
   if self.xVel > 0 then
      if self.xVel - self.friction * dt > 0 then
         self.xVel = self.xVel - self.friction * dt
      else
         self.xVel = 0
      end
   elseif self.xVel < 0 then
      if self.xVel + self.friction * dt < 0 then
         self.xVel = self.xVel + self.friction * dt
      else
         self.xVel = 0
      end
   end
end

function Player:syncPhysics()
   self.x, self.y = self.physics.body:getPosition()
   self.physics.body:setLinearVelocity(self.xVel, self.yVel)
end

function Player:beginContact(a, b, collision)
   if self.grounded == true then return end
   local nx, ny = collision:getNormal()
   if a == self.physics.fixture then
      if ny > 0 then
         self:land(collision)
      elseif ny < 0 then
         self.yVel = 0
      end
   elseif b == self.physics.fixture then
      if ny < 0 then
         self:land(collision)
      elseif ny > 0 then
         self.yVel = 0
      end
   end
end



function Player:land(collision)
   self.currentGroundCollision = collision
   self.yVel = 0
   self.grounded = true
   self.canDoubleJump = true
end

function Player:jump(key)
    if (key == "w" or key == "up" or key == "space") then
        if self.grounded then
            self.yVel = self.jumpAmount
            Sounds.jump:play()
            self.graceTime = self.graceDuration
        elseif self.canDoubleJump and self.graceTime > 0 then
            self.canDoubleJump = false
            self.yVel = self.jumpAmount * 0.85
            Sounds.jump:play()
        end
    end
end

function Player:endContact(a, b, collision)
   if a == self.physics.fixture or b == self.physics.fixture then
      if self.currentGroundCollision == collision then
         self.grounded = false
      end
   end
end

function Player:draw()
   local scaleX = 1
   if self.direction == "left" then
      scaleX = -1
   end
   love.graphics.setColor(self.color.red, self.color.green, self.color.blue)
   love.graphics.draw(self.animation.draw, self.x, self.y, 0, scaleX, 1, self.animation.width / 2, self.animation.height / 2)
   love.graphics.setColor(1,1,1,1)
end


function Player:wait(seconds)
   local start = os.time()
   repeat until os.time() > start + seconds
 end

return Player

