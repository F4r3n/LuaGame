local Menu = {

	button = {
		x = nil,
		y = nil,
		width = nil,
		height = nil,
		colorT = nil,
		colorBG = nil,
		colorTemp = nil,
		string = nil,
		hover = nil,
		click = nil,
		menu = nil
	},


	n = 1


}

Menu.__index = Menu

function Menu.new()
	local self = setmetatable({},Menu)
	self.n = 1
	return self
end

function Menu:createButton(x,y,width,height,string,color1,color2,rang)

	self.button[self.n] = {}
	self.button[self.n].x = x
	self.button[self.n].y = y
	self.button[self.n].width = width
	self.button[self.n].height = height
	self.button[self.n].string  = string
	self.button[self.n].colorT = color1
	self.button[self.n].colorBG = color2
	self.button[self.n].colorTemp = color2

	self.button[self.n].menu = rang


	self.n = self.n + 1
end

function Menu:draw(rang)
	for _, button in ipairs(self.button) do
		--	print(button.x)
		if button.menu == rang then
			love.graphics.setFont(font)

			if button.hover then
				love.graphics.setColor(button.colorTemp)
			else
				love.graphics.setColor(button.colorBG)

			end

			love.graphics.rectangle("fill",button.x,button.y,button.width,button.height)
			love.graphics.setColor(button.colorT)
			love.graphics.printf(button.string,button.x,button.y+button.height/5,150,"center")
		end

	end
end

function Menu.Inside(x1,y1,w1,h1,x2,y2)
	return x1 < x2 and
	x2 < x1+w1 and
	y1 < y2 and
	y2 < y1+h1
end

function Menu:touch(x,y)
	for i,button in ipairs(self.button) do

		if Menu.Inside(button.x,button.y,button.width,button.height,x,y) then
			button.hover = true
			button.colorTemp = orange

		else button.hover = false
			--	button.colorBG = red
		end
	end
end

function Menu:click(x,y)

	for i,button in ipairs(self.button) do
		if Menu.Inside(button.x,button.y,button.width,button.height,x,y) and i==1 then
			istart = true
			imenu = false


		end

		if Menu.Inside(button.x,button.y,button.width,button.height,x,y) and i==2 then
			imenu = false
			ioption = true


		end


		if Menu.Inside(button.x,button.y,button.width,button.height,x,y) and i==3 then
			--	imenu = false
			--	ioption = true
			if fullScreen then
				fullScreen = false
			else
				fullScreen = true
			end
			love.window.setFullscreen(fullScreen)

		end


		if Menu.Inside(button.x,button.y,button.width,button.height,x,y) and i==5 then
			imenu = true
			ioption = false


		end
	end
end


return Menu
