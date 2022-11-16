Actor = Actor or require "src/actor"
local FinMenu = Actor:extend()

local w, h = love.graphics.getDimensions()

function FinMenu:new()
    --self.backgroundMusic = love.audio.newSource("src/music/SanAndreas.wav","static")
    --self.backgroundMusic:setVolume(0.2)
    --self.backgroundMusic:setLooping(true)
    --self.backgroundMusic:play()

    self.background = love.graphics.newImage("src/textures/background/background1.png")
    self.background2 = love.graphics.newImage("src/textures/background/background2.png")
    self.background3 = love.graphics.newImage("src/textures/background/background3.png")
    self.background4 = love.graphics.newImage("src/textures/background/background4a.png")

    self.player1 = love.graphics.newImage("src/textures/player/Player1/idle1.png")
    self.playerMirror = love.graphics.newImage("src/textures/player/MirroredPlayer/idle1.png")

    self.stick = love.graphics.newImage("src/textures/PixelFantasy_Caves_1.0/Palitroque.png")

    self.font = love.graphics.newFont("src/font/old.otf", 40)
    love.graphics.setFont(self.font)
    self.fontSize = 1

    self.title = "Deeper Reflection"
    self.titleX = w/7
    self.titleY = h/7.5

    self.imageStartPosX = w/2.75
    self.imageStartPosY = h/4
    self.startButtonPosX = w/2.45
    self.startButtonPosY = h/2

    self.imageQuitPosX = w/2.75
    self.imageQuitPosY = h/2
    self.quitButtonPosX = w/2.45
    self.quitButtonPosY = h - 175

    self.rectangleWidth, self.rectangleHeight = 250, 150
end

function FinMenu:update(dt)
    self.mousePositionX, self.mousePositionY = love.mouse.getPosition()

    if(love.mouse.isDown(1)) then
        if ((self.mousePositionX > self.startButtonPosX and self.mousePositionX < self.rectangleWidth + self.startButtonPosX) and (self.mousePositionY > self.startButtonPosY and self.mousePositionY < self.rectangleHeight + self.startButtonPosY)) then
            print("startinggame")
            gameStarted = true
            --self.backgroundMusic:stop()
            love.load()
            --MAP_LEVEL
        end
        if ((self.mousePositionX > self.quitButtonPosX and self.mousePositionX < self.rectangleWidth + self.quitButtonPosX) and (self.mousePositionY > self.quitButtonPosY and self.mousePositionY < self.rectangleHeight + self.quitButtonPosY)) then
            love.event.quit()
        end
    end
end

function FinMenu:draw()
    self.mousePositionX, self.mousePositionY = love.mouse.getPosition()

    love.graphics.draw(self.background, 0, 0, 0, 2.7, 2.7) -- this is for our future background, it should be always before the map
    love.graphics.draw(self.background2, 0, 0, 0, 2.7, 2.7)
    love.graphics.draw(self.background3, 0, 0, 0, 2.7, 2.7)
    love.graphics.draw(self.background4, 0, 0, 0, 2.7, 2.7)

    love.graphics.draw(self.player1, 400, 250, 0, -10, 10 )
    love.graphics.draw(self.playerMirror, 870, 250, 0, 10, 10 )

    love.graphics.draw(self.stick, 540, 480, 0, 1.2, 1.2 )
    love.graphics.draw(self.stick, 540, 650, 0, 1.2, 1.2 )

    love.graphics.print(self.title, self.titleX, self.titleY, 0, self.fontSize * 3, self.fontSize * 3) 

    if ((self.mousePositionX > self.startButtonPosX and self.mousePositionX < self.rectangleWidth + self.startButtonPosX) and (self.mousePositionY > self.startButtonPosY and self.mousePositionY < self.rectangleHeight + self.startButtonPosY)) then
        love.graphics.setColor(0, 1, 0, 1)
        love.graphics.print("start",self.startButtonPosX + 60, self.startButtonPosY + 40, 0, self.fontSize * 1.4 , self.fontSize * 1.4) 
        love.graphics.setColor(1, 1, 1, 1)
    else
        love.graphics.print("start",self.startButtonPosX + 60, self.startButtonPosY + 40, 0, self.fontSize * 1.4 , self.fontSize * 1.4) 
    end

    if ((self.mousePositionX > self.quitButtonPosX and self.mousePositionX < self.rectangleWidth + self.quitButtonPosX) and (self.mousePositionY > self.quitButtonPosY and self.mousePositionY < self.rectangleHeight + self.quitButtonPosY)) then
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.print("quit",self.quitButtonPosX + 68, self.quitButtonPosY + 23, 0, self.fontSize * 1.4 , self.fontSize * 1.4) 
        love.graphics.setColor(1, 1, 1, 1)
    else
        love.graphics.print("quit",self.quitButtonPosX + 68, self.quitButtonPosY + 23, 0, self.fontSize * 1.4 , self.fontSize * 1.4)
    end
    
    if gameWon then
        love.graphics.print("Congrats!!", 30 , h-150, 0, self.fontSize *1.8, self.fontSize *1.8)
    end

    --love.graphics.rectangle("line", self.startButtonPosX, self.startButtonPosY, self.rectangleWidth, self.rectangleHeight)
    --love.graphics.rectangle("line", self.quitButtonPosX, self.quitButtonPosY, self.rectangleWidth, self.rectangleHeight)

end



return FinMenu