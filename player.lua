local Player = {
	x = nil,
	y = nil,
	size = nil,
	speed = 300,
	xVelocity = 0,
	yVelocity = 0,
	jumpVelocity = -400,
	orix = nil,
	oriy = nil,
	side = {},
	top = {},
	img = love.graphics.newImage("Achilles2.png"),
	quad = {},
	i = nil,
	dir = 1.5

}

Player.__index=Player


function Player.new()
	local self = setmetatable({},Player)
	self.x = 800
	self.y = 600
	self.size = 67
	self.side = {}
	self.top = {}
	self.i = 1
	self.quad = {love.graphics.newQuad(5,72,35,43,self.img:getWidth(),self.img:getHeight()),
	love.graphics.newQuad(45,72,35,43,self.img:getWidth(),self.img:getHeight()),
	love.graphics.newQuad(86,72,40,43,self.img:getWidth(),self.img:getHeight()),
	love.graphics.newQuad(127,72,35,43,self.img:getWidth(),self.img:getHeight()),
	love.graphics.newQuad(168,72,35,43,self.img:getWidth(),self.img:getHeight()),
	love.graphics.newQuad(209,72,35,43,self.img:getWidth(),self.img:getHeight()),
	love.graphics.newQuad(250,72,35,43,self.img:getWidth(),self.img:getHeight()),
	love.graphics.newQuad(291,72,35,43,self.img:getWidth(),self.img:getHeight()),
	love.graphics.newQuad(327,72,40,43,self.img:getWidth(),self.img:getHeight()),
	love.graphics.newQuad(372,72,35,43,self.img:getWidth(),self.img:getHeight()),
	love.graphics.newQuad(411,72,35,43,self.img:getWidth(),self.img:getHeight()),
	love.graphics.newQuad(450,72,35,43,self.img:getWidth(),self.img:getHeight())
}


return self
end

function Player:draw()
--	love.graphics.setColor(white)
--	love.graphics.rectangle("fill",WIDTH/2,HEIGHT/2,self.size,self.size)
--	print(self.img:getWidth(),self.quad[self.i])
	love.graphics.setColor(white)

	if self.dir < 0 then
		love.graphics.draw(self.img,self.quad[self.i],WIDTH/2+self.size,HEIGHT/2,0,self.dir,1.5)

	else
		love.graphics.draw(self.img,self.quad[self.i],WIDTH/2,HEIGHT/2,0,self.dir,1.5)

	end

end

function Player:move(dt)

	if left and right and not top then
		self.y = self.y - 1
	end

	if love.keyboard.isDown("d") or love.keyboard.isDown("right") then

		timer = (1/5+timer)%2

		self.i = (self.i+math.floor(timer))%12
		self.dir =-1.5

		if math.floor(timer) == 1 then
			timer = 0
		end

		if self.i == 0 then
			self.i = 1
		end
		if not right then
			self.xVelocity = self.speed
			left = false

		elseif right then  
			self.xVelocity = 0
		--	self.x = self.x - 1
			right = false
		end

	end


	if love.keyboard.isDown("q") or love.keyboard.isDown("left") then

		timer = (1/5+timer)%2

		self.i = (self.i+math.floor(timer))%12
		self.dir =1.5

		if math.floor(timer) == 1 then
			timer = 0
		end

		if self.i == 0 then
			self.i =1
		end
		if not left then 
			self.xVelocity = -1*self.speed
			right = false

		elseif left then 
			self.xVelocity = 0
			--	self.x = self.x + 1
			left = false
		end
	end

	if left then
		self.xVelocity = 0
	--	self.x = self.x + 1
	--	left = false

	end

	if right then
		self.xVelocity = 0
	--	self.x = self.x - 1 
	--	right = false

	end

	if top then
		self.yVelocity = 0
		top = false
	--	self.y = self.y +1
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

	if not bottom then
		self.yVelocity = self.yVelocity + gravity*dt
	end


	self.y = self.y + self.yVelocity*dt
	--Eviter glissement
	if  bottom then
		self.xVelocity = 0
	end
	bottom = false

end



return Player
