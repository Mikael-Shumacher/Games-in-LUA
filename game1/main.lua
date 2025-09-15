function love.load()
	anim8 = require 'libraries/anim8'
	love.graphics.setDefaultFilter("nearest", "nearest")

	player = {}
	player.x = 400 
	player.y = 200
	player.speed = 2
	love.mouse.setVisible(false)
	player.sprite = love.graphics.newImage("asserts/parrot.png")
	background = love.graphics.newImage("asserts/background.png")
	enemy = love.graphics.newImage("asserts/bird.png")
	player.spriteSheet = love.graphics.newImage("asserts/player-sheet.png")
	player.grid = anim8.newGrid(12, 18, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())
	player.animations = {}
	player.animations.down = anim8.newAnimation(player.grid('1-4', 1), 0.2)

	player.animations.left = anim8.newAnimation(player.grid('1-4', 2), 0.2)

	player.animations.right = anim8.newAnimation(player.grid('1-4', 3), 0.2)

	player.animations.up = anim8.newAnimation(player.grid('1-4', 4), 0.4)

	player.anim = player.animations.down
end

function love.update(dt)
	local isMoving = false
	cursor = love.mouse.getCursor()
	if love.keyboard.isDown("s") then
		player.y = player.y + player.speed
		player.anim = player.animations.down
	elseif love.keyboard.isDown("w") then
		player.y = player.y - player.speed
		player.anim = player.animations.up
	elseif love.keyboard.isDown("d") then
		player.x = player.x + player.speed
		player.anim = player.animations.right
	elseif love.keyboard.isDown("a") then
		player.x = player.x - player.speed
		player.anim = player.animations.left
	else 
		-- stop
		player.anim:gotoFrame(2)
	end
	if love.keyboard.isDown("lshift") then
		player.speed = 4
	end


	player.anim:update(dt)
end

function love.draw()
	love.graphics.draw(background, 0, 0)
	local x, y = love.mouse.getPosition()
	love.graphics.rectangle("fill", x, y, 10, 10)
	player.anim:draw(player.spriteSheet, player.x, player.y, nil, 3)
--	love.graphics.draw(img, x,y)
end
