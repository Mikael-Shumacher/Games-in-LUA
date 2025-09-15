function love.load()
	player = {}
	velocity = 2
	player.x = 400 
	player.y = 200
	x, y, w,h = 0, 0, 60, 20
end

function love.update(dt)
	w = w+20
	h = h+20
	if love.keyboard.isDown("s") then
		player.y = player.y + velocity
	end
	if love.keyboard.isDown("w") then
		player.y = player.y - velocity
	end
	if love.keyboard.isDown("d") then
		player.x = player.x + velocity
	end
	if love.keyboard.isDown("a") then
		player.x = player.x - velocity
	end
end

function love.draw()
	love.graphics.setColor(0, 100, 100)
	love.graphics.rectangle("fill", x, y, w, h)
	love.graphics.setColor(100, 0, 0)
	love.graphics.circle("fill", player.x, player.y, 10)
end
