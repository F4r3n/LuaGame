local Game = {

score = nil,
niveau = nil,
time = nil


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

	return self
end


function Game.update(dt)

		love.graphics.setBackgroundColor(blue)
		level:collideAll(player)
		level:collisionLaser(laser,player.x,player.y)
		mob:collideGround(level)
		mob:move(dt)
		player:move(dt)
		laser:update(dt,player.x,player.y,player.size)
		mob:hit(laser,player.x,player.y,level)

end

function Game.draw()

		level:draw(player.x,player.y,player.size)
		player:draw()
		laser:draw()
		mob:draw(player.x,player.y,player.size)
		if info then
			love.graphics.print("FPS "..tostring(love.timer.getFPS()),10,10)
		end

end

return Game

