Mob = {

	a = {
		x = nil,
		y = nil,
		life = 5,
		width = 30,
		height = 30,
		attack = 0
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
			if self.matrix[i][j] == 0  and self.matrix[i+1][j] == 1 then
				self.a[nb]={}
				self.a[nb].x = 100*(j-1)+100-self.a.height
				self.a[nb].y = 100*(i-1)+100-self.a.width

				nb = nb+1
			end
		end
	end


end

function Mob:draw(x,y,size)
	
	love.graphics.setColor(white)
	for i=1,nb-1 do
		love.graphics.rectangle("fill",self.a[i].x+WIDTH/2-x,self.a[i].y+HEIGHT/2-y,self.a.width,self.a.height)
	end

end


return Mob
