
function love.load()
    -- Libraries
    wf = require "libraries/windfield"
    anim8 = require "libraries/anim8"

     -- Window 
    love.graphics.setDefaultFilter("nearest", "nearest")
    windowWidth = 1800
    windowHeight = 1000

    --Collisions and Physics 
    world = wf.newWorld(0, 10000)


    -- Player 
    player = {
        speed = 200,
        score = 0,
        heart = {
            sprite = love.graphics.newImage('assets/heart.png'),
            lifes = 3
        },
        angle = 0
    }
    player.collider = world:newRectangleCollider(windowWidth/2, windowHeight/2, 80, 80)
    player.collider:setFixedRotation(true)
    player.isGrounded = false

    --Player animations
    player.spriteSheet = love.graphics.newImage("assets/bird_sheets.png")
    player.grid = anim8.newGrid(160, 160, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())
    player.animations = {
        speed = 0.2
    }
    player.animations.stopleft = anim8.newAnimation(player.grid('1-2', 1), player.animations.speed)

    player.animations.stopright = anim8.newAnimation(player.grid('1-2', 2), player.animations.speed)

    player.animations.runleft = anim8.newAnimation(player.grid('3-4', 1), player.animations.speed)

    player.animations.runright = anim8.newAnimation(player.grid('3-4', 2), player.animations.speed)

	player.animations.downleft = anim8.newAnimation(player.grid('1-2', 3), player.animations.speed)

	player.animations.downright = anim8.newAnimation(player.grid('1-2', 4), player.animations.speed)

    player.animations.left = anim8.newAnimation(player.grid('3-4', 3), player.animations.speed)

	player.animations.right = anim8.newAnimation(player.grid('3-4', 4), player.animations.speed)

	player.anim = player.animations.left

    Side = 'left'

    -- Score
    love.graphics.setFont (love.graphics.newFont (50))
    font = love.graphics.getFont ()
    text = love.graphics.newText(font)
    text_score = love.graphics.newText(font)
    height = font:getHeight( )
    text:add( {{0,0,1}, "Score: "}, 0, 0)
    text_score:add( {{0,0,1}, player.score}, 0, 0)


    -- Ground and Collision
    ground = world:newRectangleCollider(0, windowHeight/2 + 255, windowWidth, 100)
    ground:setType('static')    
 

    -- Enemies2
    enemy = {
        speed = 2,
        x = 100,
        y = 100,
        sprite = love.graphics.newImage('assets/parrot.png')
    }

    -- Background
    background = {
        sprite = love.graphics.newImage('assets/background.jpg'),
        x = 0,
        y = 0
    }
    local bgWidth = background.sprite:getWidth()    background.x = 0
    background.y = 0
    local bgHeight = background.sprite:getHeight()
    bgScaleX = windowWidth/bgWidth
    bgScaleY = windowHeight/bgHeight  


end

function handlePlayerMovement(dt)
    local isMoving = false
    local vx, vy = 0, 0
    local px, py = player.collider:getLinearVelocity()

    local movingLeft = love.keyboard.isDown("a")
    local movingRight = love.keyboard.isDown("d")
    local movingUp = love.keyboard.isDown("w")
    local movingDown = love.keyboard.isDown("s")

    if movingUp then 
        vy = vy - player.speed 
        isMoving = true
    end
    if movingDown then 
        vy = vy + player.speed 
        isMoving = true
    end
    if movingLeft then 
        vx = vx - player.speed 
        isMoving = true
    end
    if movingRight then 
        vx = vx + player.speed 
        isMoving = true
    end

    -- Animação baseada no movimento
    if vx ~= 0 or vy ~= 0 then
        if math.abs(py) >= 0 and math.abs(py) < 1 then 
            if movingRight then
                player.anim = player.animations.runright
                Side = 'right'
            elseif movingLeft then
                player.anim = player.animations.runleft
                Side = 'left'
            end
        else
            if movingRight then
                player.anim = movingUp and player.animations.right or player.animations.downright
                Side = 'right'
            elseif movingLeft then
                player.anim = movingUp and player.animations.left or player.animations.downleft
                Side = 'left'
            end
        end
    elseif (math.abs(py) >= 0 and math.abs(py) < 1) and px == 0 then
        if Side == 'right' then
            player.anim = player.animations.stopright
        else
            player.anim = player.animations.stopleft
        end
    else
        if Side == 'right' then
            player.anim = player.animations.downright
        else
            player.anim = player.animations.downleft
        end
    end
    player.collider:setLinearVelocity(vx, vy)
    player.anim:update(dt)
end


function love.update(dt)
    world:update(dt)
    if love.keyboard.isDown("lshift") then 
        player.speed = 300
    else 
        player.speed = 200
    end
    handlePlayerMovement(dt)
end


function love.draw()
    love.graphics.draw(background.sprite, background.x, background.y, 0, bgScaleX, bgScaleY)
    local px, py = player.collider:getPosition()
    player.anim:draw(player.spriteSheet, px, py, nil, 1, 1, 80, 80)
    if player.heart.lifes >= 1 then love.graphics.draw(player.heart.sprite, 5, 0, 0, 0.5, 0.5) end
    if player.heart.lifes >= 2 then love.graphics.draw(player.heart.sprite, 50, 0, 0, 0.5, 0.5) end
    if player.heart.lifes == 3 then love.graphics.draw(player.heart.sprite, 95, 0, 0, 0.5, 0.5) end
    love.graphics.draw (text, 160, 0)
    love.graphics.draw (text_score, 320, 0)
    --world:draw()
end

function love.keypressed(key)
    if key == "tab" then
        player.collider:applyLinearImpulse(0, -5000)
    end
end
