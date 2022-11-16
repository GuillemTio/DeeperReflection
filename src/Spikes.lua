local Spike = {img = love.graphics.newImage("src/textures/spikes/spikeFinal.png")}
Spike.__index = Spike

Spike.width = Spike.img:getWidth()
Spike.height = Spike.img:getHeight()

local ActiveSpikes = {}
local Player = require("src/Player")

function Spike.removeAll()
   for i,v in ipairs(ActiveSpikes) do
      v.physics.body:destroy()
      table.remove(ActiveSpikes,i)
   end

   ActiveSpikes = {}
end

function Spike.new(x,y)
   local instance = setmetatable({}, Spike)
   instance.x = x
   instance.y = y

   instance.physics = {}
   instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "static")
   instance.physics.shape = love.physics.newRectangleShape(instance.width / 16, instance.height / 6)
   instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
   instance.physics.fixture:setSensor(true)
   table.insert(ActiveSpikes, instance)
end

function Spike:update(dt)

end

function Spike:draw()
   love.graphics.draw(self.img, self.x, self.y, 0, 0.2, 0.25, self.width / 2, self.height / 2)
end

function Spike.updateAll(dt)
   for i,instance in ipairs(ActiveSpikes) do
      instance:update(dt)
   end
end

function Spike.drawAll()
   for i,instance in ipairs(ActiveSpikes) do
      instance:draw()
   end
end

function Spike.beginContact(a, b, collision)
   for i,instance in ipairs(ActiveSpikes) do
      if a == instance.physics.fixture or b == instance.physics.fixture then
         if a == Player.physics.fixture or b == Player.physics.fixture then
            Player:die()
            return true
         end
         if a == PlayerMirror.physics.fixture or b == PlayerMirror.physics.fixture then
            PlayerMirror:die()
            return true
         end
      end
   end
end

return Spike