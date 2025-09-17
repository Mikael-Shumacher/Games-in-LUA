function love.load()
	anim8 = require 'libraries/anim8'
	love.graphics.setDefaultFilter("nearest", "nearest")

	sti = require 'libraries/sti'
	gameMap = sti('maps/Map.lua')

	camera = require 'libraries/camera'
	cam = camera()

	player = {}
	player.x = 400 
	player.y = 200
	player.speed = 2
	love.mouse.setVisible(false)
	background = love.graphics.newImage("assets/background.png")
	player.spriteSheet = love.graphics.newImage("assets/player-sheet.png")
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
		isMoving = true
	elseif love.keyboard.isDown("w") then
		player.y = player.y - player.speed
		player.anim = player.animations.up
		isMoving = true
	elseif love.keyboard.isDown("d") then
		player.x = player.x + player.speed
		player.anim = player.animations.right
		isMoving = true
	elseif love.keyboard.isDown("a") then
		player.x = player.x - player.speed
		player.anim = player.animations.left
		isMoving = true
	else 
		-- stop
		player.anim:gotoFrame(2)
		isMoving = false
	end
	if love.keyboard.isDown("lshift") then
		player.speed = 4
	else 
		player.speed = 2
	end


	player.anim:update(dt)
	cam:lookAt(player.x, player.y)

	local w = love.graphics.getWidth()
	local h = love.graphics.getHeight()

	local mapW = gameMap.width * gameMap.tilewidth
	local mapH = gameMap.height * gameMap.tileheight
	if cam.x > (mapW - w/2) then
		cam.x = (mapW - w/2)
	end

	if cam.y > (mapH - h/2) then
		cam.y = (mapH - h/2)
	end

end

function love.draw()
	cam:attach()
		gameMap:drawLayer(gameMap.layers["Ground"])
		gameMap:drawLayer(gameMap.layers["Tree"])
		local x, y = love.mouse.getPosition()
		love.graphics.rectangle("fill", x, y, 10, 10)
		player.anim:draw(player.spriteSheet, player.x, player.y, nil, 4, nil, 6, 9)
	--	love.graphics.draw(img, x,y)
	cam:detach()
end
