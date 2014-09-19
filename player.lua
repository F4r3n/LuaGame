local Player = {
	x = nil,
	y = nil,
	size = nil,
	speed = 300,
	xVelocity = 0,
	yVelocity = 0,
	jumpVelocity = -400,
	orix = nil,
	oriy = nil

}

Player.__index=Player


function Player.new()
	local self = setmetatable({},Player)
	self.x = 800
	self.y = 600
	self.size = 50
--	self.orix = 650/2
--	self.oriy= 200
	return self
end

function Player:draw()
	love.graphics.setColor(white)
	love.graphics.rectangle("fill",WIDTH/2,HEIGHT/2,self.size,self.size)
end

function Player:move(dt)

	if left and right and not top then
		self.y = self.y - 1
	end

	if love.keyboard.isDown("d") or love.keyboard.isDown("right") then

		if not right then
			self.xVelocity = self.speed

		elseif right then  
			self.xVelocity = 0
			self.x = self.x - 1
			right = false
		end

	end


	if love.keyboard.isDown("q") or love.keyboard.isDown("left") then
		if not left then 
			self.xVelocity = -1*self.speed
		elseif left then 
			self.xVelocity = 0
			self.x = self.x + 1
			left = false
		end
	end

	if left then
		self.xVelocity = 0

		self.x = self.x + 1
		left = false
	end

	if right then
		self.xVelocity = 0
		self.x = self.x - 1 
		right = false
	end

	if top then
		self.yVelocity = 0
		top = false
		self.y = self.y +1
	end

	if bottom then
		self.yVelocity = 0

	end

	if not bottom and self.xVelocity > 0 then 
		self.xVelocity = self.xVelocity - gravity*dt/6
	end

	if not bottom and self.xVelocity < 0 then 
		self.xVelocity = self.xVelocity + gravity*dt/6
	end

	if jump and bottom then
		bottom = false
		if not top then 
			self.yVelocity = self.jumpVelocity
		end
		jump = false
	end
	-- ne pas pouvoir sauter lorsque l'on a appuyé sur la touche de saut et que l'on va toucher le sol
	if jump and not bottom then 
		jump = false
	end

	self.x = self.x + self.xVelocity*dt
	self.y = self.y + self.yVelocity*dt
	self.yVelocity = self.yVelocity + gravity*dt

	if  bottom then
		self.xVelocity = 0
	end
	bottom = false

end

function Player:location()

	self.y = self.y + 3*self.size
	self.x = self.x - self.size

end


return Player
