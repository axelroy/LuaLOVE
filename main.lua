debug = true


---------------------  Attributs  -------------------
player = { x = 200, y = 710, speed = 150, img = nil }

-- Timers
-- We declare these here so we don't have to edit them multiple places
canShoot = true
canShootTimerMax = 0.2
canShootTimer = canShootTimerMax

-- Image Storage
bulletImg = nil

-- Entity Storage
bullets = {} -- array of current bullets being drawn and updated
--------------------------------------------------

-------------------  Méthodes  -------------------
function love.load(arg)
    player.img = love.graphics.newImage('assets/plane.png')
    bulletImg = love.graphics.newImage('assets/bullet.png')
end

-- Updating
function love.update(dt)
    -- Fermeture du jeu
    if love.keyboard.isDown('escape') then
        love.event.push('quit')
    end

    -- Gestion des contrôles de déplacements
    if love.keyboard.isDown('left','a') then
    	if player.x > 0 then -- binds us to the map
    		player.x = player.x - (player.speed*dt)
    	end
    elseif love.keyboard.isDown('right','d') then
    	if player.x < (love.graphics.getWidth() - player.img:getWidth()) then
    		player.x = player.x + (player.speed*dt)
    	end
    end
end

function love.draw(dt)
    love.graphics.draw(player.img, player.x, player.y)
end
--------------------------------------------------
