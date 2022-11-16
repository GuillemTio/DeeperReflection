local Chest = {img = love.graphics.newImage("src/textures/chest/chest01.png")}
Chest.__index = Chest



Chest.width = Chest.img:getWidth()
Chest.height = Chest.img:getHeight()

local ActiveChest = {}
local Player = require("src/Player")

function Chest.new(x,y)
   local instance = setmetatable({}, Chest)
   instance.x = x
   instance.y = y

   instance.physics = {}
   instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "static")
   instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
   instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
   instance.physics.fixture:setSensor(true)
   table.insert(ActiveChest, instance)
end

function Chest:update(dt)

end

function Chest:draw()
   love.graphics.draw(self.img, self.x, self.y, 0, 1, 1, self.width / 2, self.height / 2)
end

function Chest.updateAll(dt)
   for i,instance in ipairs(ActiveChest) do
      instance:update(dt)
   end
end

function Chest.drawAll()
   for i,instance in ipairs(ActiveChest) do
      instance:draw()
   end
end

function Chest.beginContact(a, b, collision)
   for i,instance in ipairs(ActiveChest) do
      if a == instance.physics.fixture or b == instance.physics.fixture then
         if a == Player.physics.fixture or b == Player.physics.fixture then
            
                gameWon = true
                love.load()                
                return true
             
         end
      end
   end
end

return Chest