white= {255,255,255,255}
black={0,0,0,255}
blue={51,51,255,255}
green={51,102,0,255}
red = {255,0,0,255}
orange = {255,128,0,255}
yellow = {255,255,0,255}
grey = {96,96,96,255}
gravity=600
top = false
bottom = false
left = false
right = false
niveau = 3
jump = false
WIDTH = 800
HEIGHT = 600
imenu = true
istart = false
ioption = false
fullScreen = false
font = love.graphics.newFont("alexis.ttf",20)

LevelBase = require 'levelBase'
Level = require 'level'
Player = require 'player'
Laser = require 'laser'
Menu = require 'menu'



function love.load()

	level = Level.new(niveau)
	player = Player.new()
	laser = Laser.new()
	menu = Menu.new()
	level:create()
	love.graphics.setColor(grey)
	love.window.setMode(WIDTH,HEIGHT)
	love.window.setTitle("Bounce the ball")

	menu:createButton(WIDTH/2-50,HEIGHT/10,150,50,"START",black,red,1)
	menu:createButton(WIDTH/2-50,HEIGHT/10+200,150,50,"OPTIONS",black,red,1)
	menu:createButton(WIDTH/6,HEIGHT/2,150,50,"FULL SCREEN",black,red,2)
	menu:createButton(WIDTH/6+200,HEIGHT/2,150,50,"OPTION2",black,red,2)
	menu:createButton(WIDTH-200,HEIGHT-200,150,50,"RETOUR",black,yellow,2)


end

function love.update(dt)

	if not imenu or istrart then
		level:collideAll(player)
		level:collisionLaser(laser,player.x,player.y)
		player:move(dt)
		laser:update(dt,player.x,player.y,player.size)
		if love.mouse.isDown("l") then
			laser:create(love.mouse.getX(),love.mouse.getY(),player.x,player.y,player.size)
		end
	end
		if imenu or ioption then
		menu:touch(love.mouse.getX(),love.mouse.getY())

	end

end

function love.draw()

	if not imenu and istart then
		level:draw(player.x,player.y,player.size)
		player:draw()
		laser:draw()
		if info then
			love.graphics.print("FPS "..tostring(love.timer.getFPS()),10,10)
		end


	elseif imenu then
		love.graphics.setColor(grey)
		love.graphics.rectangle("fill",0,0,WIDTH,HEIGHT)
		menu:draw(1)

	elseif ioption then

		love.graphics.setColor(grey)
		love.graphics.rectangle("fill",0,0,WIDTH,HEIGHT)
		menu:draw(2)
	end
end

function love.quit()
	print("thanks for having played")
end

function love.mousepressed(x,y,button)
	if button == "l" then
		menu:click(x,y)
	end 
end

function love.keypressed(key)
	if key=="escape" then
		love.event.quit()

	elseif key=="r" then
		love.load()
		imenu = true
		istart = false

	elseif key == "i" then
		if info then
			info = false
		else info = true
		end
	elseif key == "s" then
		if imenu then
			imenu = false
			istart = true
		end

	elseif key=="z" then
		jump = true

	end

end


