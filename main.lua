debug = true                                                   -- Shows the errors on the display console

---------------------  Notes  -------------------
-- ~=  means !=
-- Test authen

-------------------  Attributes  ----------------
player = { x = 200, y = 710, speed = 150, img = nil }          --

-- Timers
-- We declare these here so we don't have to edit them multiple places
canShoot = true
canShootTimerMax = 0.2
canShootTimer = canShootTimerMax

createEnemyTimerMax = 0.4
createEnemyTimer = createEnemyTimerMax
deadZone = 15

-- Image Storage
bulletImg = nil
enemyImg = nil

-- Entity Storage
bullets = {}                                                    -- array of current bullets being drawn and updated
enemies = {}

isAlive = true
score = 0
sound = nil

-------------------------------------------------

-------------------  Méthods  -------------------
function love.load(arg)
    player.img = love.graphics.newImage('assets/plane.png')
    bulletImg = love.graphics.newImage('assets/bullet.png')
    enemyImg = love.graphics.newImage('assets/enemy.png')
    sound = love.audio.newSource("assets/gun-sound.wav", "static") -- the "static" tells LÖVE to load the file into memory, good for short sound effects
end

-- Updating dunctions. Automatically called by the love framework.
function love.update(dt)
    controlsChecking(dt)
    shootTimeoutControl(dt)
    borderGuard(dt)
    enemyCreating(dt)
    enemyMoving(dt)
    checkCollisions()
end

function checkCollidingItems(x1, y1, w1, h1, x2, y2, w2, h2)
    return
    x1 < x2+w2 and
    x2 < x1+w1 and
    y1 < y2+h2 and
    y2 < y1+h1
end

function checkCollisions()
    -- run our collision detection
    -- Since there will be fewer enemies on screen than bullets we'll loop them first
    -- Also, we need to see if the enemies hit our player
    for i, enemy in ipairs(enemies) do
    	for j, bullet in ipairs(bullets) do
    		if checkCollidingItems(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), bullet.x, bullet.y, bullet.img:getWidth(), bullet.img:getHeight()) then
    			table.remove(bullets, j)
    			table.remove(enemies, i)
    			score = score + 1
    		end
    	end

    	if checkCollidingItems(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), player.x, player.y, player.img:getWidth(), player.img:getHeight())
    	and isAlive then
    		table.remove(enemies, i)
    		isAlive = false
    	end
    end
end

function enemyMoving(dt)
    if dt ~= nil then
        for i, enemy in ipairs(enemies) do
            enemy.y = enemy.y + 200 * dt
        end
    end
end

-- Key contols management
function controlsChecking(dt)
    -- Game exiting
    if love.keyboard.isDown('escape') then
        love.event.push('quit')
    end

    if love.keyboard.isDown('left','a') and dt ~= nil then
        if player.x > 0 then
            player.x = player.x - (player.speed*dt)
        end
    elseif love.keyboard.isDown('right','d') and dt ~= nil then
        if player.x < (love.graphics.getWidth() - player.img:getWidth()) then
            player.x = player.x + (player.speed*dt)
        end
    end

    -- Shoot controls
    if love.keyboard.isDown(' ', 'rctrl', 'lctrl', 'ctrl', 'space') and canShoot and isAlive then                        -- Create some bullets
        newBullet = { x = player.x + (player.img:getWidth()/2), y = player.y, img = bulletImg }
        table.insert(bullets, newBullet)
        sound:play()
        canShoot = false
        canShootTimer = canShootTimerMax
    end

    -- Reset controls
    if not isAlive and love.keyboard.isDown('r') then
    	-- remove all our bullets and enemies from screen
    	bullets = {}
    	enemies = {}

    	-- reset timers
    	canShootTimer = canShootTimerMax
    	createEnemyTimer = createEnemyTimerMax

    	-- move player back to default position
    	player.x = 50
    	player.y = 710

    	-- reset our game state
    	score = 0
    	isAlive = true
    end
end

-- Shoot timeout management. Allows or no to the player to shoot
function shootTimeoutControl(dt)
    -- Time out how far apart our shots can be.
    if dt ~= nil then
        canShootTimer = canShootTimer - (1 * dt)
        if canShootTimer < 0 then
          canShoot = true
        end
    end
end

function enemyCreating(dt)
    -- Time out enemy creation
    if dt ~= nil then
        createEnemyTimer = createEnemyTimer - (1 * dt)
        if createEnemyTimer < 0 then
        	createEnemyTimer = createEnemyTimerMax

        	-- Create an enemy
            spawnPosition = math.random(deadZone, love.graphics.getWidth() - enemyImg:getWidth() - deadZone)
            newEnemy = { x = spawnPosition, y = -enemyImg:getHeight(), img = enemyImg }
        	table.insert(enemies, newEnemy)
        end
    end
end

function borderGuard(dt)
    if dt ~= nil then
        for i, bullet in ipairs(bullets) do                                                                  -- ipairs returns the bullet object and the index i
            bullet.y = bullet.y - (250 * dt)
            if bullet.y < 0 then                                                                             -- remove bullets when they pass off the screen
                table.remove(bullets, i)
            end
        end
    end
end

function love.draw(dt)
    if isAlive then
    	love.graphics.draw(player.img, player.x, player.y)
    else
    	love.graphics.print("Press 'R' to restart", love.graphics:getWidth()/2-50, love.graphics:getHeight()/2-10)
    end

    for i, bullet in ipairs(bullets) do
      love.graphics.draw(bullet.img, bullet.x, bullet.y)
    end

    for i, enemy in ipairs(enemies) do
    	love.graphics.draw(enemy.img, enemy.x, enemy.y)
    end

    love.graphics.print("Score : " .. score,  10, 10)
end
--------------------------------------------------
