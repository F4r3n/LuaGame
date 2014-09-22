Mob = {

	a = {
		x = nil,
		y = nil,
		life = 5,
		width = 30,
		height = 30,
		attack = 0,
		alive = true,
		bottom = false,
		left = false,
		right = false,
		top = false,
		xVelocity = 0,
		yVelocity = 0,
		speed = 200 ,
		n = 1,
		tot = 1

	},


	b = {

		x = nil,
		y = nil,
		life = 5,
		width = 30,
		height = 30,
		attack = 0,
		alive = true,
		bottom = true,
		left = true,
		right = true
	},

	index = nil,
	matrix = nil

}


Mob.__index = Mob

function Mob.new(level)
	local self  = setmetatable({},Mob)
	self.index = level
	self.matrix = LevelBase[2*level-1]
	return self
end

function Mob:create()
	nb = 1
	for i=1,#self.matrix-1 do
		for j=1,#self.matrix[i] do
			if self.matrix[i][j] == 0  and self.matrix[i+1][j] == 1 and math.random(0,10)==1 then
				self.a[nb]={}
				self.a[nb].x = 100*(j-1)+100-self.a.height
				self.a[nb].y = 100*(i-1)+100-self.a.width
				self.a[nb].alive = true
				self.a[nb].life = 5
				self.a[nb].yVelocity = 0
				self.a[nb].xVelocity = 0
				self.a[nb].top = false
				self.a[nb].bottom = false
				self.a[nb].right = false
				self.a[nb].left = false
				self.a.n = self.a.n+1


				nb = nb+1
			end
		end
	end


end

function Mob:draw(x,y,size)

	love.graphics.setColor(white)
	for i=1,nb-1 do
		if self.a[i] ~=nil then
			if self.a[i].alive then
				love.graphics.rectangle("fill",self.a[i].x+WIDTH/2-x,self.a[i].y+HEIGHT/2-y,self.a.width,self.a.height)
			end
		end
	end

end


function Mob:hit(laser,x,y,level)
	for j=1, nb-1 do
		if laser.n > 1 then
			for i=1,laser.n-1 do
				if self.a[j] ~= nil then
					if	level.collide(laser.pos[i].x,laser.pos[i].y,laser.size,laser.size,
						self.a[j].x-x+WIDTH/2,self.a[j].y-y+HEIGHT/2,self.a.height,self.a.width) and laser.pos[i].ok and self.a[j].alive then
						laser.pos[i].ok = false
						self.a[j].life = self.a[j].life - 1
						if self.a[j].life <=0 then
							self.a[j].alive = false
							table.remove(self.a,j)
							nb = nb -1
							self.a.n = self.a.n + 1
							self.a.tot = self.a.tot + 1
						end
					end
				end
			end
		end
	end
end

function Mob:collideGround(level)
	for j=1,level.box[1].n-1 do
		for i=1,nb-1 do
			if self.a[i].alive then
			if Level.collide(self.a[i].x+5,self.a[i].y,self.a.width-10,5,
				level.box[1][j].ground.x,level.box[1][j].ground.y,level.box[1][j].ground.size,level.box[1][j].ground.size) then
				self.a[i].top = true
			--	print("top")
			end

			if Level.collide(self.a[i].x+self.a.width-5,self.a[i].y+5,5,self.a.height-10,
				level.box[1][j].ground.x,level.box[1][j].ground.y,level.box[1][j].ground.size,level.box[1][j].ground.size) then
				self.a[i].right = true
			--	print("right")
			end
			if Level.collide(self.a[i].x+5,self.a[i].y+self.a.height-5,self.a.width-10,5,
				level.box[1][j].ground.x,level.box[1][j].ground.y,level.box[1][j].ground.size,level.box[1][j].ground.size) then
				self.a[i].bottom = true
			--	print("bottom")
			end
			if Level.collide(self.a[i].x,self.a[i].y+5,5,self.a.height-10,
				level.box[1][j].ground.x,level.box[1][j].ground.y,level.box[1][j].ground.size,level.box[1][j].ground.size) then
				self.a[i].left = true
			--	print("left")
			end
		end
		end
	end
end

function Mob:move(dt)
	for i=1,nb-1 do
		if self.a[i].alive then



			if self.a[i].left and self.a[i].right then
				self.a[i].left = false
				self.a[i].right = false
			end


			--	self.a[i].yVelocity = 0
			local dir = math.random(0,15)
			if dir == 0 and not self.a[i].left then
				self.a[i].xVelocity = -1*self.a.speed
				self.a[i].right = false
			end

			if dir == 1 and not self.a[i].right then
				self.a[i].xVelocity = self.a.speed
				self.a[i].left = false

			end

			if dir ==0 and self.a[i].left then
				self.a[i].xVelocity = self.a.speed
				self.a[i].left = false
			end

			if dir ==1 and self.a[i].right then
				self.a[i].xVelocity = -1*self.a.speed
				self.a[i].right = false

			end

			if self.a[i].bottom then
				self.a[i].yVelocity = 0
				self.a[i].y = self.a[i].y-1
				self.a[i].bottom = false
			end

			if self.a[i].left then
				self.a[i].xVelocity = 0
				self.a[i].right = false

			end
			if self.a[i].right then
				self.a[i].xVelocity = 0
				self.a[i].left = false
			end

			if self.a[i].top then
				self.a[i].yVelocity = 0
				self.a[i].bottom = false

			end

			self.a[i].bottom = false


			self.a[i].yVelocity = self.a[i].yVelocity + gravity*dt
			self.a[i].y = self.a[i].y + self.a[i].yVelocity*dt

			self.a[i].x = self.a[i].x+self.a[i].xVelocity*dt
		end
	end
end





return Mob
