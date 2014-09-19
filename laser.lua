local Laser = {

	pos = {
		x = nil,
		y = nil,
		orix=nil,
		oriy=nil,
		px =nil,
		py = nil,
		vx = nil,
		vy = nil,
		ok = true
	},
	size = 10,
	speed = 400,
	n = 1

}
Laser.__index = Laser

function Laser.new()
	local self = setmetatable({},Laser)
	size = 10
	return self
end

function Laser:create(x1,y1,x,y,size)

	--	if x1 - WIDTH/2 < 100 and y1 - HEIGHT/2 < 100 then
	self.pos[self.n]= {}
	self.pos[self.n].x = WIDTH/2+size/2-self.size/2
	self.pos[self.n].y = HEIGHT/2+size/2-self.size/2
	self.pos[self.n].orix = x
	self.pos[self.n].oriy = y
	self.pos[self.n].px =x
	self.pos[self.n].py =y
	self.pos[self.n].ok = true

	--print(x1-WIDTH/2,y1-HEIGHT/2)
	--	print(x,y)
	local vx = x1-WIDTH/2-size/2
	local vy = y1-HEIGHT/2-size/2
	local max
	if math.abs(vx) > math.abs(vy) then
		max = vx
	else max = vy
	end

	self.pos[self.n].vx =(vx)/math.abs(max)
	self.pos[self.n].vy =(vy)/math.abs(max)

	--print(self.pos[self.n].vx,self.pos[self.n].vy)
	self.n = self.n +1
	--	end
end

function Laser:draw()

			love.graphics.setColor(red)
	if self.n > 1 then 
		for i=1, self.n-1 do
			if self.pos[i].ok then

			love.graphics.rectangle("fill",self.pos[i].x,self.pos[i].y,self.size,self.size);

		end
	end
	end

end

function Laser:update(dt,x,y,size)
	if self.n > 1 then 
		for i=1, self.n-1 do
			if self.pos[i].ok then
			self.pos[i].x = self.pos[i].orix-x+WIDTH/2+size/2-self.size/2
			self.pos[i].y = self.pos[i].oriy-y+HEIGHT/2+size/2-self.size/2
			--	print(self.pos[i].x,self.pos[i].y)

			self.pos[i].orix=self.pos[i].orix+self.speed*dt*self.pos[i].vx
			self.pos[i].oriy=self.pos[i].oriy+self.speed*dt*self.pos[i].vy

			end
			--	print(self.pos[i].x)	

		end
	end
end




return Laser
