Player = Player or require "src/Player"
Camera = Camera or require"src/Camera"
FinMenu = FinMenu or require"src/FinMenu"
Spikes = Spikes or require"src/Spikes"
Chest = Chest or require"src/Chest"
StartMenu = StartMenu or require"src/StartMenu"
PlayerMirror = PlayerMirror or require"src/PlayerMirror"

gameWon = false
gameStarted = false
haveSpikes = false

actorList = {} --Lista de elementos de juego

local STI = require("src/sti")
love.graphics.setDefaultFilter("nearest", "nearest")

function love.load()

  if not gameStarted then
    StartMenu:new()
  elseif gameWon then
    
      FinMenu:new()
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
  Map.layers.obstacles.visible = false
  
  MapHeight = Map.layers.grounded.height * 16
  background = love.graphics.newImage("src/textures/background/background1.png") -- this is for our future background
  background2 = love.graphics.newImage("src/textures/background/background2.png")
  background3 = love.graphics.newImage("src/textures/background/background3.png")
  background4 = love.graphics.newImage("src/textures/background/background4a.png")
  
  PlayerMirror:new()  
  Player:new()
  
  spawnEntities()
  
  local font = love.graphics.newFont("src/font/old.otf", 40)
  love.graphics.setFont(font)

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
  elseif gameWon then
    FinMenu:update(dt)
  else
      
    
  World:update(dt)
  Player:update(dt)
  PlayerMirror:update(dt)  
  Spikes.updateAll(dt)
  Chest.updateAll(dt)
  Camera:setPosition(0, Player.y-100)
  end
  
end

function love.draw()
  --for _,v in ipairs(actorList) do
  --v:draw()
  --end
  if not gameStarted then
    StartMenu:draw()
  elseif gameWon then
    FinMenu:draw()
  else
  

  love.graphics.draw(background, 0, 0, 0, 3.2, 3.2) -- this is for our future background, it should be always before the map
  love.graphics.draw(background2, 0, 0, 0, 3.2, 3.2)
  love.graphics.draw(background3, 0, 0, 0, 3.2, 3.2)
  love.graphics.draw(background4, 0, 0, 0, 3.2, 3.2)
    
  
  Map:draw(-Camera.x, -Camera.y, Camera.scale, Camera.scale)
  
  
  
  Camera:apply()
  
  love.graphics.print("you're lost!",230, 70, 0, 0.27 , 0.27)
  love.graphics.print("don't lose your partner!",420, 250, 0, 0.27 , 0.27)
  
  Player:draw()
  PlayerMirror:draw()  
  Spikes.drawAll()
  Chest.drawAll()

  Camera:clear()
  end
end

function love.keypressed(key)
  --for _,v in ipairs(actorList) do
  if gameStarted then

  
    Player:jump(key)
    PlayerMirror:jump(key)
   
    if key == "escape" then
      gameStarted = false
      love.load()
      Spikes:removeAll()
    end
  end
end

function beginContact(a, b, collision)
  if gameStarted then
  Chest.beginContact(a, b, collision)
  Spikes.beginContact(a, b, collision)
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

function spawnEntities()
  if gameStarted then
  for i,v in ipairs(Map.layers.obstacles.objects) do
    if haveSpikes then
      if v.type == "spike" then
        Spikes.new(v.x + v.width / 2, v.y + v.height / 2)
      end
    end
    if v.type == "chest" then
      Chest.new(v.x + v.width / 2, v.y + v.height / 2)
    end
  end
  end
end
