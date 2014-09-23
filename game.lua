local Game = {

	score = nil,
	niveau = nil,
	time = nil,
	fin = false


}

Game.__index = Game


LevelBase = require 'levelBase'
Level = require 'level'
Player = require 'player'
Laser = require 'laser'
Mob = require 'mob'

function Game.new()
	local self = setmetatable({},Game)
	self.niveau = 3

	level = Level.new(self.niveau)
	player = Player.new()
	laser = Laser.new()
	menu = Menu.new()
	mob = Mob.new(self.niveau)


	level:create()
	mob:create()
	player.x = level.jx
	player.y = level.jy
	self.time = 0
	self.fin = false

	return self
end


function Game:update(dt)

	if not self.fin and player.alive then
		self.time = self.time + dt
		love.graphics.setBackgroundColor(blue)
		level:collideAll(player)
		level:collisionLaser(laser,player.x,player.y)
		mob:collideGround(level)
		mob:move(dt)
		player:move(dt)
		laser:update(dt,player.x,player.y,player.size)
		mob:hit(laser,player.x,player.y,level)
		self:win()
		player:touch(mob,level)
		player:invicible(dt)
		player:death()

	elseif not player.alive then
		self.time= self.time
	end

end

function Game:nextLevel()
	self.fin = false
	self.time = 0
	self.niveau = self.niveau + 1
	level = Level.new(self.niveau)
	player = Player.new()
	laser = Laser.new()
	mob = Mob.new(self.niveau)


	level:create()
	mob:create()
	player.x = level.jx
	player.y = level.jy


end

function Game:draw()



	if self.fin and player.alive then
		self:result()

	elseif not player.alive then
		self:deadResult()
	else
		level:draw(player.x,player.y,player.size)
		player:draw()
		laser:draw()
		mob:draw(player.x,player.y,player.size)

		player:displayLife()
		if info then
			love.graphics.print("FPS "..tostring(love.timer.getFPS()),10,10)
		end

		love.graphics.print("Timer "..tostring(math.floor(self.time)),WIDTH/2,10)
	end

end

function Game:win()

	for i=1, level.box[4].f-1 do
		if level.collide(player.x,player.y,player.size,player.size,
			level.box[4][i].fin.x,level.box[4][i].fin.y,level.box[4][i].fin.size,level.box[4][i].fin.size) then
			self.fin = true
		end
	end

end

function Game:result()


	love.graphics.setColor(grey)
	love.graphics.rectangle("fill",0,0,WIDTH,HEIGHT)

	love.graphics.setColor(red)

	love.graphics.setFont(font2)
	love.graphics.print("YOU WIN ",WIDTH/2-100,HEIGHT/2-100)
	love.graphics.setFont(font)
	love.graphics.print(math.floor(self.time),WIDTH/2,HEIGHT/2+20)
	love.graphics.print("Vous avez tué "..(mob.a.tot-1).." sur "..mob.a.n-1,WIDTH/2,HEIGHT/2+40)


end

function Game:deadResult()


	love.graphics.setColor(grey)
	love.graphics.rectangle("fill",0,0,WIDTH,HEIGHT)
	

	love.graphics.setColor(red)

	love.graphics.setFont(font2)
	love.graphics.print("YOU are Dead ",WIDTH/2-100,HEIGHT/2-100)
	love.graphics.setFont(font)
	love.graphics.print(math.floor(self.time),WIDTH/2,HEIGHT/2+20)
	love.graphics.print("Vous avez tué "..(mob.a.tot-1).." sur "..mob.a.n-1,WIDTH/2,HEIGHT/2+40)


end
return Game

