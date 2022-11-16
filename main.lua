Player = Player or require "src/Player"
Camera = Camera or require"src/Camera"
--EnemyGoblin = EnemyGoblin or require"src/EnemyGoblin"
--EnemySkeleton = EnemySkeleton or require"src/EnemySkeleton"
--HUD = HUD or require"src/HUD"
StartMenu = StartMenu or require"src/StartMenu"
PlayerMirror = PlayerMirror or require"src/PlayerMirror"

gameWon = false
gameStarted = false

actorList = {} --Lista de elementos de juego

local STI = require("src/sti")
love.graphics.setDefaultFilter("nearest", "nearest")

function love.load()

  if not gameStarted then
    StartMenu:new()
  else

  --backgroundMusic = love.audio.newSource("src/music/BigPoppa.wav","static")
  --backgroundMusic:setVolume(0.2)
  --backgroundMusic:setLooping(true)
  --backgroundMusic:play()

  Map = STI("src/map/Map1.lua", { "box2d" })
  World = love.physics.newWorld(0, 0) -- takes x and y velocity for the World, for example to create gravity
  World:setCallbacks(beginContact, endContact)
  Map:box2d_init(World)
  Map.layers.solid.visible = false -- colliders non visible
 -- Map.layers.entity.visible = false
  
  --MapWidth = Map.layers.ground.width * 24
  --background = love.graphics.newImage("src/textures/background/background_layer_1.png") -- this is for our future background
  --background2 = love.graphics.newImage("src/textures/background/background_layer_2.png")
  --background3 = love.graphics.newImage("src/textures/background/background_layer_3.png")

  --EnemyGoblin.loadAssets()
  --EnemySkeleton.loadAssets()
  PlayerMirror:new()  
  Player:new()
  --HUD:load()

  --spawnEntities()
  --local p = Player()
  --table.insert(actorList,p)
  end
end

function love.update(dt)
  --for _,v in ipairs(actorList) do
  --v:update(dt)
  --end

  if not gameStarted then
    StartMenu:update(dt)
  else

  World:update(dt)
  Player:update(dt)
  PlayerMirror:update(dt)  
  --EnemyGoblin.updateAll(dt)
  --EnemySkeleton.updateAll(dt)
  Camera:setPosition(Player.x, 0)
  --HUD:update(dt)
  end
end

function love.draw()
  --for _,v in ipairs(actorList) do
  --v:draw()
  --end
  if not gameStarted then
    StartMenu:draw()
  else

  --love.graphics.draw(background, 0, 0, 0, 5, 5) -- this is for our future background, it should be always before the map
  --love.graphics.draw(background2, 0, 0, 0, 5, 5)
  --love.graphics.draw(background3, 0, 0, 0, 5, 5)

  Map:draw(-Camera.x, -Camera.y, Camera.scale, Camera.scale)


  Camera:apply()

  Player:draw()
  PlayerMirror:draw()  
  --EnemyGoblin.drawAll()
  --EnemySkeleton.drawAll()

  Camera:clear()
  --HUD:draw()
  end
end

function love.keypressed(key)
  --for _,v in ipairs(actorList) do
  if gameStarted then

  
    Player:jump(key)
    PlayerMirror:jump(key)
   
  end
end

function beginContact(a, b, collision)
  if gameStarted then
  --EnemyGoblin.beginContact(a, b, collision)
  --EnemySkeleton.beginContact(a, b, collision)
  if a == Player.physics.fixture or b == Player.physics.fixture then
    Player:beginContact(a, b, collision)  
  end
  if a == PlayerMirror.physics.fixture or b == PlayerMirror.physics.fixture then
    PlayerMirror:beginContact(a, b, collision)  
  end
end
end

function endContact(a, b, collision)
  if gameStarted then
  Player:endContact(a, b, collision)
  PlayerMirror:endContact(a,b,collision)
  end
  
end

--function spawnEntities()
--  if gameStarted then
--  for i,v in ipairs(Map.layers.entity.objects) do
--    if v.type == "enemyGoblin" then
--      EnemyGoblin:new(v.x + v.width / 2, v.y + v.height / 2)
--    end
--    if v.type == "enemySkeleton" then
--      EnemySkeleton:new(v.x + v.width / 2, v.y + v.height / 2)
--    end
--  end
--end
--end
