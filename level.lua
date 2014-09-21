local Level={
	index = nil,
	matrix = nil,
	box = {
		ground = {
			size = nil,
			x = nil,
			y = nil,

		},

		other = {
			size = nil,
			x = nil,
			y = nil

		},
			
		start = {
			size = nil,
			x = nil,
			y = nil

		},

	fin = {
			size = nil,
			x = nil,
			y = nil
		},


		g = nil,
		o = nil,
		s = nil,
		f = nil
	},
	jx = nil,
	jy = nil
}

Level.__index=Level


function Level.new(index)
	local self = setmetatable({},Level)
	self.index=index;

	self.matrix=LevelBase[index*2-1]
	return self
end

function Level:create()
	groundI=1
	otherI=1
	startI=1
	self.box[1]={}
	self.box[1].n = 1
	self.box[2]={}
	self.box[2].o = 1
	self.box[3]={}
	self.box[3].s = 1
	self.box[4]={}
	self.box[4].f = 1


	for i=1,#self.matrix do
		for j=1,#self.matrix[i] do
			if self.matrix[i][j] == 1 then
				self.box[1][groundI]={ground = {size=100,x=100*(j-1),y=100*(i-1)}}
				self.box[1].n = self.box[1].n +1
				groundI = groundI+1
			elseif self.matrix[i][j] == 0 then
				self.box[2][otherI]={other = {size=100,x=100*(j-1),y=100*(i-1)}}
				otherI = otherI + 1
				self.box[2].o = self.box[2].o +1

			elseif self.matrix[i][j] == 3 then
				self.box[3][startI]={start = {size=100,x=100*(j-1),y=100*(i-1)}}
				startI = startI + 1
				self.jx = 100*(j-1)
				self.box[3].s = self.box[3].s +1
				self.jy = 100*(i-1)
			
			elseif self.matrix[i][j] == 4 then
				self.box[4][self.box[4].f]={fin = {size=100,x=100*(j-1),y=100*(i-1)}}
				self.box[4].f = self.box[4].f + 1


			end
		end
	end
end


function Level:draw(x,y,size)

	for i=1,self.box[2].o-1 do

		love.graphics.setColor(blue)
		love.graphics.rectangle("fill",self.box[2][i].other.x-x+WIDTH/2,self.box[2][i].other.y-y+HEIGHT/2,self.box[2][i].other.size,self.box[2][i].other.size)
	end

	for i=1,groundI-1 do
		love.graphics.setColor(green)
		love.graphics.rectangle("fill",self.box[1][i].ground.x-x+WIDTH/2,self.box[1][i].ground.y-y+HEIGHT/2,self.box[1][i].ground.size,self.box[1][i].ground.size)
	end

	for i=1,startI-1 do

		love.graphics.setColor(dblue)
		love.graphics.rectangle("fill",self.box[3][i].start.x-x+WIDTH/2,self.box[3][i].start.y-y+HEIGHT/2,self.box[3][i].start.size,self.box[3][i].start.size)
	end


	for i=1,self.box[4].f-1 do

		love.graphics.setColor(grey)
		love.graphics.rectangle("fill",self.box[4][i].fin.x-x+WIDTH/2,self.box[4][i].fin.y-y+HEIGHT/2,self.box[4][i].fin.size,self.box[4][i].fin.size)
	end
end

function Level.collide(x1,y1,w1,h1,x2,y2,w2,h2)
	return x1 < x2+w2 and
	x2 < x1+w1 and
	y1 < y2+h2 and
	y2 < y1+h1
end

function Level:collideAll(player)
	for i=1,groundI-1 do
		if Level.collide(player.x,player.y,player.size,player.size,
			self.box[1][i].ground.x,self.box[1][i].ground.y,self.box[1][i].ground.size,self.box[1][i].ground.size) then
			self:collideSide(player.x,player.y,player.size,i)
		end
	end
end

function Level:collideSide(x,y,size,i)

	--top
	if Level.collide(x+5,y,size-10,5,
		self.box[1][i].ground.x,self.box[1][i].ground.y,self.box[1][i].ground.size,self.box[1][i].ground.size) then
		top = true
	end

	if Level.collide(x+size-5,y+5,5,size - 10,
		self.box[1][i].ground.x,self.box[1][i].ground.y,self.box[1][i].ground.size,self.box[1][i].ground.size) then
		right = true
	end


	if Level.collide(x+5,y+size-5,size-10,5,
		self.box[1][i].ground.x,self.box[1][i].ground.y,self.box[1][i].ground.size,self.box[1][i].ground.size) then
		bottom = true
	end


	if Level.collide(x,y+5,5,size-10,
		self.box[1][i].ground.x,self.box[1][i].ground.y,self.box[1][i].ground.size,self.box[1][i].ground.size) then
		left = true
	end

end

function Level:collisionLaser(laser,x,y)
	for j=1,groundI-1 do
		if laser.n > 1 then 
			for i=1, laser.n-1 do
				if level.collide(laser.pos[i].x,laser.pos[i].y,laser.size,laser.size,
					self.box[1][j].ground.x-x+WIDTH/2,self.box[1][j].ground.y-y+HEIGHT/2,self.box[1][j].ground.size,self.box[1][j].ground.size) and laser.pos[i].ok then
					laser.pos[i].ok = false
				end
			end

		end
	end
end

return Level
