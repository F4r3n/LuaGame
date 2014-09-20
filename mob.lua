Mob = {

	a = {
		x = nil,
		y = nil,
		life = 5,
		width = 30,
		height = 30,
		attack = 0,
		alive = true
	},


	b = {
		x = nil,
		y = nil,
		life = nil,
		width = nil,
		height = nil,
		attack = nil
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
			if self.matrix[i][j] == 0  and self.matrix[i+1][j] == 1 and math.random(0,1)==1 then
				self.a[nb]={}
				self.a[nb].x = 100*(j-1)+100-self.a.height
				self.a[nb].y = 100*(i-1)+100-self.a.width
				self.a[nb].alive = true
				self.a[nb].life = 5

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
						end
					end
				end
			end
		end
	end
end




return Mob
