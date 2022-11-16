Actor = Actor or require "src/actor"
local Player = Actor:extend()
local Vector = Vector or require "src/vector"
--local GrapplingHook = GrapplingHook or require "src/GrapplingHook"

Player = {} 

function Player:new()
   --Player.super.new(self,"src/textures/PackNinja/IndividualSprites/adventurer-idle-00.png",400,500,20,1,0)
   self.image = "src/textures/player/Player1/walking1.png"
   self.x = 270
   self.y = 5000
   self.startX = self.x
   self.startY = self.y
   self.width = 32
   self.height = 32
   self.xVel = 0
   self.yVel = 100
   self.maxSpeed = 200
   self.acceleration = 3500
   self.friction = 3000
   self.gravity = 1500
   self.jumpAmount = -500
   

   self.color = {
      red = 1,
      green = 1,
      blue = 1,
      speed = 3,
   }

   self.graceTime = 0 
   self.graceDuration = 0.1

   self.alive = true
   
   
   
   self.direction = "right"
   self.state = "idle"
   self.grounded = false

   

   self:loadAssets {}

   self.physics = {}
   self.physics.body = love.physics.newBody(World, self.x, self.y, "dynamic")
   self.physics.body:setFixedRotation(true)
   self.physics.shape = love.physics.newRectangleShape(self.width / 2.3, self.height/1.5)
   self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
end

function Player:update(dt)
   --Player.super.update(self,dt)
   self:unTint(dt)
   self:respawn()
   self:setState()
   self:setDirection()
   self:decreaseGraceTime(dt)
   self:animate(dt)
   self:syncPhysics()
  

  
   self:move(dt)
      
  
   self:applyGravity(dt)

end

function Player:setState()
   if self.attacking then
   self.state = "attack"
   elseif not self.grounded and not self.grabbed then
      self.state = "air"
   elseif self.xVel == 0 then
      self.state = "idle"
   elseif self.grabbed then
      self.state = "grapple"
   else
      self.state = "run"
   end
end

function Player:setDirection()
   if self.xVel <0 then
      self.direction = "left"
   elseif self.xVel>0 then
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

function Player:decreaseGraceTime(dt)
   if not self.grounded then
      self.graceTime = self.graceTime - dt
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

function Player:loadAssets()
   self.animation = { timer = 0, rate = 0.1 }
   self.animation.run = { total = 6, current = 1, img = {} }
   for i = 1, self.animation.run.total do
      self.animation.run.img[i] = love.graphics.newImage("src/textures/player/Player1/walking" .. i .. ".png")
   end

   self.animation.idle = { total = 5, current = 1, img = {} }
   for i = 1, self.animation.idle.total do
      self.animation.idle.img[i] = love.graphics.newImage("src/textures/player/Player1/idle" .. i ..".png")
   end

   self.animation.air = { total = 1, current = 1, img = {} }
   for i = 1, self.animation.air.total do
      self.animation.air.img[i] = love.graphics.newImage("src/textures/player/Player1/jump" .. i ..".png")
   end

   self.animation.draw = self.animation.idle.img[1]
   self.animation.width = self.animation.draw:getWidth()
   self.animation.height = self.animation.draw:getHeight()


end


function Player:die()
   self.alive = false
   print("u died")
end

function Player:tintRed()
   self.color.green = 0
   self.color.blue = 0
end

function Player:respawn()
   if not self.alive then
      love.load()
   end
end

function Player:unTint(dt)
   self.color.red = math.min(self.color.red + self.color.speed * dt, 1)
   self.color.green = math.min(self.color.green + self.color.speed * dt, 1)
   self.color.blue = math.min(self.color.blue + self.color.speed * dt, 1)
end

function Player:applyGravity(dt)
   if not self.grounded then
      self.yVel = self.yVel + self.gravity * dt
   end
end

function Player:move(dt)
   if love.keyboard.isDown("d", "right") then
      self.xVel = math.min(self.xVel + self.acceleration * dt, self.maxSpeed)
   elseif love.keyboard.isDown("a", "left") then
      self.xVel = math.max(self.xVel - self.acceleration * dt, -self.maxSpeed)
   else
      self:applyFriction(dt)
   end
end

function Player:applyFriction(dt)
   if self.xVel > 0 then
      self.xVel = math.max(self.xVel - self.friction * dt, 0)
   elseif self.xVel < 0 then
      self.xVel = math.min(self.xVel + self.friction * dt, 0)
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
   self.graceTime = self.graceDuration
end

function Player:jump(key)
   if (key == "space") then
      if self.graceTime>0 or self.grounded then
         self.yVel = self.jumpAmount
         self.grounded = false
         self.graceTime = 0 
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
   love.graphics.draw(self.animation.draw, self.x, self.y, 0, scaleX, 1, self.animation.width / 2, self.animation.height/1.5)
   love.graphics.setColor(1,1,1,1)


end

return Player
