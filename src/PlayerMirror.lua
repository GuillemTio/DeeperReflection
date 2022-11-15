Actor = Actor or require "src/actor"
local PlayerMirror = Actor:extend()
local Vector = Vector or require "src/vector"
--local GrapplingHook = GrapplingHook or require "src/GrapplingHook"

PlayerMirror = {} 

function PlayerMirror:new()
   --Player.super.new(self,"src/textures/PackNinja/IndividualSprites/adventurer-idle-00.png",400,500,20,1,0)
   self.image = "src/textures/PackNinja/IndividualSprites/adventurer-idle-00.png"
   self.x = 300
   self.y = 100
   self.startX = self.x
   self.startY = self.y
   self.width = 50
   self.height = 37
   self.xVel = 0
   self.yVel = 100
   self.maxSpeed = 200
   self.acceleration = 3500
   self.friction = 3000
   self.gravity = 1500
   self.jumpAmount = -500
   self.health = {current = 5, max = 5}
   self.attackRangeX = 40
   self.attackRangeY = 30

   self.color = {
      red = 1,
      green = 1,
      blue = 1,
      speed = 3,
   }

   self.graceTime = 0 
   self.graceDuration = 0.1

   self.alive = true
   self.attacking = false
   self.damageDone = false
   self.grappleactive = false
   self.grabbed = false
   self.direction = "right"
   self.state = "idle"
   self.grounded = false

   self.godModeActive = false

   self:loadAssets {}

   self.physics = {}
   self.physics.body = love.physics.newBody(World, self.x, self.y, "dynamic")
   self.physics.body:setFixedRotation(true)
   self.physics.shape = love.physics.newRectangleShape(self.width / 2.3, self.height)
   self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
end

function PlayerMirror:update(dt)
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

function PlayerMirror:setState()
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

function PlayerMirror:setDirection()
   if self.xVel <0 then
      self.direction = "left"
   elseif self.xVel>0 then
      self.direction = "right"
   end
end

function PlayerMirror:animate(dt)
   self.animation.timer = self.animation.timer + dt
   if self.animation.timer > self.animation.rate then
      self.animation.timer = 0
      self:setNewFrame()
   end
end

function PlayerMirror:decreaseGraceTime(dt)
   if not self.grounded then
      self.graceTime = self.graceTime - dt
   end
end

function PlayerMirror:setNewFrame()
   local anim = self.animation[self.state]
   if anim.current < anim.total then
      anim.current = anim.current + 1
   else
      anim.current = 1
   end
   self.animation.draw = anim.img[anim.current]
end

function PlayerMirror:loadAssets()
   self.animation = { timer = 0, rate = 0.1 }
   self.animation.run = { total = 6, current = 1, img = {} }
   for i = 1, self.animation.run.total do
      self.animation.run.img[i] = love.graphics.newImage("src/textures/PackNinja/IndividualSprites/Run/" .. i .. ".png")
   end

   self.animation.idle = { total = 4, current = 1, img = {} }
   for i = 1, self.animation.idle.total do
      self.animation.idle.img[i] = love.graphics.newImage("src/textures/PackNinja/IndividualSprites/Idle/" .. i ..".png")
   end

   self.animation.air = { total = 2, current = 1, img = {} }
   for i = 1, self.animation.air.total do
      self.animation.air.img[i] = love.graphics.newImage("src/textures/PackNinja/IndividualSprites/Jump/" .. i ..".png")
   end

   
   self.animation.grapple = { total = 2, current = 1, img = {} }
   for i = 1, self.animation.grapple.total do
      self.animation.grapple.img[i] = love.graphics.newImage("src/textures/PackNinja/IndividualSprites/Grapple/" .. i ..".png")
   end

   self.animation.attack = { total = 4, current = 1, img = {} }
   for i = 1, self.animation.attack.total do
      self.animation.attack.img[i] = love.graphics.newImage("src/textures/PackNinja/IndividualSprites/Attack/" .. i ..".png")
   end

   self.animation.draw = self.animation.idle.img[1]
   self.animation.width = self.animation.draw:getWidth()
   self.animation.height = self.animation.draw:getHeight()


end

function PlayerMirror:takeDamage(amount)
   self:tintRed()
   if not self.godModeActive then
   if self.health.current - amount > 0 then
      self.health.current = self.health.current - amount
      if self.direction == "right" then
         self.xVel = self.xVel - 700
         self.yVel = self.yVel - 200
      else
         self.xVel = self.xVel + 700
         self.yVel = self.yVel - 300
      end
   else
      self.health.current = 0
      self:die()
   end
end

   print(self.health.current)
end

function Player:die()
   self.alive = false
   print("u died")
end

function Player:tintRed()
   self.color.green = 0
   self.color.blue = 0
end

function PlayerMirror:respawn()
   if not self.alive or self.y > 730 then
      EnemyGoblin.removeAll()
      EnemyEyes.removeAll()
      EnemySkeleton.removeAll()
      BossMushroom.removeAll()
      backgroundMusic:stop()
      love.load()
     

   end
end

function PlayerMirror:unTint(dt)
   self.color.red = math.min(self.color.red + self.color.speed * dt, 1)
   self.color.green = math.min(self.color.green + self.color.speed * dt, 1)
   self.color.blue = math.min(self.color.blue + self.color.speed * dt, 1)
end

function PlayerMirror:applyGravity(dt)
   if not self.grounded then
      self.yVel = self.yVel + self.gravity * dt
   end
end

function PlayerMirror:move(dt)
   if love.keyboard.isDown("a", "left") then
      self.xVel = math.min(self.xVel + self.acceleration * dt, self.maxSpeed)
   elseif love.keyboard.isDown("d", "right") then
      self.xVel = math.max(self.xVel - self.acceleration * dt, -self.maxSpeed)
   else
      self:applyFriction(dt)
   end
end

function PlayerMirror:applyFriction(dt)
   if self.xVel > 0 then
      self.xVel = math.max(self.xVel - self.friction * dt, 0)
   elseif self.xVel < 0 then
      self.xVel = math.min(self.xVel + self.friction * dt, 0)
   end
end

function PlayerMirror:syncPhysics()
   self.x, self.y = self.physics.body:getPosition()
   self.physics.body:setLinearVelocity(self.xVel, self.yVel)
end


function PlayerMirror:beginContact(a, b, collision)
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

function PlayerMirror:land(collision)
   self.currentGroundCollision = collision
   self.yVel = 0
   self.grounded = true
   self.graceTime = self.graceDuration
end

function PlayerMirror:jump(key)
   if (key == "space") then
      if self.graceTime>0 or self.grounded then
         self.yVel = self.jumpAmount
         self.grounded = false
         self.graceTime = 0 
      end
   end
end







function PlayerMirror:endContact(a, b, collision)
   if a == self.physics.fixture or b == self.physics.fixture then
      if self.currentGroundCollision == collision then
         self.grounded = false
      end
   end
end

function PlayerMirror:draw()


   local scaleX = 1
   if self.direction == "left" then
      scaleX = -1
   end

   love.graphics.setColor(self.color.red, self.color.green, self.color.blue)
   love.graphics.draw(self.animation.draw, self.x, self.y, 0, scaleX, 1, self.animation.width / 2, self.animation.height / 2)
   love.graphics.setColor(1,1,1,1)

   if self.grappleactive then
      GrapplingHook:draw()
   end
end

return PlayerMirror
