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
	heart = love.graphics.newImage("heart.png"),
	quad = {},
	i = nil,
	life = 10,
	alive = true,
	time = 0,
	untouchable = false,
	hit = false,
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
	self.life = 5
	self.alive  = true

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

	if not love.keyboard.isDown("q") then
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

function Player:touch(mob,level)
	--	print(self.untouchable)
	for i=1, mob.a.n-1 do
		if mob.a[i] ~= nil then
			if mob.a[i].alive then
				if not self.untouchable then
					if level.collide(self.x,self.y,self.size,self.size,
						mob.a[i].x,mob.a[i].y,mob.a.width,mob.a.height) then
						if self.life > 0 then
							self.life = self.life - 1
							self.hit = true
							self.untouchable = true
							print(self.life)
						end
					end
				end
			end
		end


	end

end

function Player:death()
	if self.alive then
		if self.life <=0 then
			self.alive = false
			self.fin = true
			print("YOU ARE DEAD")
		end 
	end
end

function Player:invicible(dt)
	if self.hit then
		self.time = self.time + dt
		if self.time > 2 then
			self.hit = false
			self.untouchable = false
			self.time = 0
		end
	end
end

function Player:displayLife()
	if self.alive then
		love.graphics.setColor(white)
		for i=1,self.life do
			love.graphics.draw(self.heart,10+(self.heart:getWidth()+10)*i,10)
		end
	end


end


return Player
