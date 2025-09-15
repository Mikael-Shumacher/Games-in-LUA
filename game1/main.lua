function love.load()
	player = {}
	player.x = 400 
	player.y = 200
	player.speed = 2
	love.mouse.setVisible(false)
	player.sprite = love.graphics.newImage("asserts/parrot.png")
	background = love.graphics.newImage("asserts/background.png")
	enemy = love.graphics.newImage("asserts/bird.png")
--	img = love.graphics.newImage("mouse.png")
end

function love.update(dt)
	cursor = love.mouse.getCursor()
	if love.keyboard.isDown("s") then
		player.y = player.y + player.speed
	end
	if love.keyboard.isDown("w") then
		player.y = player.y - player.speed
	end
	if love.keyboard.isDown("d") then
		player.x = player.x + player.speed
	end
	if love.keyboard.isDown("a") then
		player.x = player.x - player.speed
	end
end

function love.draw()
	love.graphics.draw(background, 0, 0)
	love.graphics.draw(player.sprite, player.x, player.y)
	local x, y = love.mouse.getPosition()
	love.graphics.rectangle("fill", x, y, 10, 10)
--	love.graphics.draw(img, x,y)
end
