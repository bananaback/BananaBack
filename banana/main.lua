function love.run()
    if love.math then
	love.math.setRandomSeed(os.time())
    end

    if love.load then love.load(arg) end

    -- We don't want the first frame's dt to include time taken by love.load.
    if love.timer then love.timer.step() end

    local dt = 0

    -- Main loop time.
    while true do
        -- Process events.
        if love.event then
	    love.event.pump()
	    for name, a,b,c,d,e,f in love.event.poll() do
	        if name == "quit" then
		    if not love.quit or not love.quit() then
		        return a
		    end
	        end
		love.handlers[name](a,b,c,d,e,f)
	    end
        end

	-- Update dt, as we'll be passing it to update
	if love.timer then
	    love.timer.step()
	    dt = love.timer.getDelta()
	end

	-- Call update and draw
	if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled

	if love.graphics and love.graphics.isActive() then
	    love.graphics.clear(love.graphics.getBackgroundColor())
	    love.graphics.origin()
            if love.draw then love.draw() end
	    love.graphics.present()
	end

	if love.timer then love.timer.sleep(0.001) end
    end
end

function love.load()
    love.profiler = require('profile') 
    love.profiler.start()
    Object = require'classic'
    Timer = require "timer"
    anim8 = require 'anim8'
    love.graphics.setDefaultFilter('nearest', 'nearest')
    
    bump = require 'bump'
    world = bump.newWorld(16)
    
    require 'block'
    listOfBlocks = {}
    
    ----- 64 * 39
    map = {{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
           {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
           {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
           {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
           {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
           {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
           {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
           {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
           {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
           {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
           {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
           {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
           {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
           {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
           {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
           {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
           {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
           {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
           {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
           {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
           }
         
    for y = 1, 20 do
        for x = 1, 39 do
            if map[y][x] == 1 then
                table.insert(listOfBlocks, Block(x*16, y*16, 'dirtmid'))
            elseif map[y][x] == 2 then
                table.insert(listOfBlocks, Block(x*16, y*16, 'water'))
            end
        end
    end
    ---
    
    DARK = {0, 0, 0}
    DARKGRAY = {85/255, 85/255, 85/255}
    LIGHTGRAY = {170/255, 170/255, 170/255}
    WHITE = {1, 1, 1}
    DARKRED = {85/255, 0, 0}
    RED = {170/255, 0, 0}
    ORANGE = {255/255, 85/255, 0}
    DARKYELLOW = {170/255, 85/255, 0}
    LIGHTORANGE = {255/255, 170/255, 0}
    YELLOW = {255/255, 255/255, 85/255}
    DARKGREEN = {0, 85/255, 0}
    GREEN = {0, 170/255, 0}
    LIGHTGREEN = {170/255, 255/255, 0}
    DARKBLUE = {0, 85/255, 170/255}
    BLUE = {0, 170/255, 255/255}
    LIGHTBLUE = {85/255, 255/255, 255/255}
    
    love.graphics.setColor(WHITE)
    
    Camera = require "Camera"
    camera = Camera()
    --camera:setFollowStyle('PLATFORMER')
    camera:setFollowStyle('SCREEN_BY_SCREEN')
    camera.scale = 3
    
    require 'ladder'
    gameObjects = {}
    
    table.insert(gameObjects, Ladder(64, 128))
    love.graphics.setBackgroundColor(0.5, 0.5, 0.8)
    
    require 'scorpion'
    listOfEnemies = {}
    table.insert(listOfEnemies, Scorpion(450, 0, 70, 70))
    
    require 'playerskill/normalpunch'
    require 'playerskill/windpunch'
    require 'playerskill/windbullet'
    require 'playerskill/windbullet2'
    require 'playerskill/firebullet1'
    require 'playerskill/firebullet2'
    require 'playerskill/firepunch'
    require 'playerskill/waterpunch'
    require 'playerskill/waterbullet1'
    require 'playerskill/waterbullet2'
    listOfBullets = {}
    table.insert(listOfBullets, FireBullet1(200, 200, -1))
    
    require 'popup'
    listOfPopUps = {}
    
    require 'coin'
    listOfCoins = {}
    
    listOfEffectObjects = {}
    require'freezeeffect'
    
    require 'player'
    player = Player()
    nt=love.timer.getTime()
end

local period = 1/60 -- 60 updates per second
local t = 0.0 -- accumulator
love.frame = 0
function love.update(dt)
    love.frame = love.frame + 1
    if love.frame%100 == 0 then
        love.report = love.profiler.report(20)
        love.profiler.reset()
    end
    Timer.update(dt)
    camera:update(dt)
    camera:follow(player.x + player.width / 2, player.y + player.height / 2)
    player:update(dt)
    for enenum, enenow in ipairs(listOfEnemies) do
        enenow:update(dt)
    end
    for bulletnum, bulletnow in ipairs(listOfBullets) do
        bulletnow:update(dt)
    end
    for bulletnum, bulletnow in ipairs(listOfBullets) do
        bulletnow:update(dt)
    end
    for popupnum, popupnow in ipairs(listOfPopUps) do
        popupnow:update(dt)
    end
    for coinnum, coinnow in ipairs(listOfCoins) do
        coinnow:update(dt)
    end
    for effectobjectnum, effectobjectnow in ipairs(listOfEffectObjects) do
        effectobjectnow:update(dt)
    end
end

function love.draw()
    camera:attach()
    for i,v in ipairs(listOfBlocks) do
        v:draw()
    end
    for obnum, obj in ipairs(gameObjects) do
        obj:draw()
    end
    player:draw()
    
    for enenum2, enenow2 in ipairs(listOfEnemies) do
        enenow2:draw()
    end
    for bulletnum2, bulletnow2 in ipairs(listOfBullets) do
        bulletnow2:draw()
    end
    for popupnum2, popupnow2 in ipairs(listOfPopUps) do
        popupnow2:draw()
    end
    for coinnum2, coinnow2 in ipairs(listOfCoins) do
        coinnow2:draw()
    end
    for effectobjectnum2, effectobjectnow2 in ipairs(listOfEffectObjects) do
        effectobjectnow2:draw()
    end
    love.graphics.print(love.report or "Please wait...")
    camera:detach()
    camera:draw()
    player:draw2()
    --print(love.graphics.getState().drawcalls)


end

function love.keypressed(key)
    if key == 'w' and player.isGrounded then
        player.isGrounded = false
        player.vy = -370
    end
    if key == 'space'  and player.attacking == false and player.hurting == false then
        if player.currentWeapon == "normalPunch" then
            player.attackDuration = 15
            if player.scaleX == -1 then
                table.insert(listOfBullets, NormalPunch(player.x - player.width / 2, player.y + player.height / 2 - 4, player.scaleX))
            elseif player.scaleX == 1 then
                table.insert(listOfBullets, NormalPunch(player.x + player.width / 2, player.y + player.height / 2 - 4, player.scaleX))
            end
        elseif player.currentWeapon == "windPunch" and player.greenEnergy >= 1 then
            player.attackDuration = 15
            if player.scaleX == -1 then
                table.insert(listOfBullets, WindPunch(player.x - player.width / 2 - 1, player.y + player.height / 2 - 4, player.scaleX))
            elseif player.scaleX == 1 then
                table.insert(listOfBullets, WindPunch(player.x + player.width / 2 + 1, player.y + player.height / 2 - 4, player.scaleX))
            end
            player.greenEnergy = player.greenEnergy - 1
            player.alert3State = "resume"
            player.alert3Timer:after(0.5, function() player.alert3State = "pause" end)
        elseif player.currentWeapon == "windBullet1" and player.greenEnergy >= 2 then
            player.attackDuration = 15
            if player.scaleX == -1 then
                local critChance = love.math.random(1, 3)
                if critChance == 1 then
                    table.insert(listOfPopUps, PopUp(player.x + math.random(-4, 4), player.y, 'crit!', 10, 2.5, 'yellow', 1))
                    table.insert(listOfBullets, WindBullet2(player.x - player.width / 2 - 1, player.y + player.height / 2 - 8, -1))
                else
                    table.insert(listOfBullets, WindBullet1(player.x + player.width / 2, player.y + player.height / 2 - 4, -1))
                end
              
                table.insert(listOfBullets, WindPunch(player.x - player.width / 2 - 1, player.y + player.height / 2 - 4, player.scaleX))
            elseif player.scaleX == 1 then
                local critChance = love.math.random(1, 3)
                if critChance == 1 then
                    table.insert(listOfPopUps, PopUp(player.x + math.random(-4, 4), player.y, 'crit!', 10, 2.5, 'yellow', 1))
                    table.insert(listOfBullets, WindBullet2(player.x + player.width / 2 + 1, player.y + player.height / 2 - 8, 1))
                else
                    table.insert(listOfBullets, WindBullet1(player.x + player.width / 2, player.y + player.height / 2 - 4, 1))
                end
                
                table.insert(listOfBullets, WindPunch(player.x + player.width / 2 + 1, player.y + player.height / 2 - 4, player.scaleX))
            end
          
            player.greenEnergy = player.greenEnergy - 2
            player.alert3State = "resume"
            player.alert3Timer:after(0.5, function() player.alert3State = "pause" end)
        elseif player.currentWeapon == "firePunch" and player.health >= 1 then
            player.attackDuration = 15
            if player.scaleX == -1 then
                table.insert(listOfBullets, FirePunch(player.x - player.width / 2 - 1, player.y + player.height / 2 - 4, player.scaleX))
            elseif player.scaleX == 1 then
                table.insert(listOfBullets, FirePunch(player.x + player.width / 2 + 1, player.y + player.height / 2 - 4, player.scaleX))
            end
            player.health = player.health - 1
            player.alert1State = "resume"
            player.alert1Timer:after(0.5, function() player.alert1State = "pause" end)
        elseif player.currentWeapon == "fireBullet1" and player.health >= 2 then
            player.attackDuration = 15
            if player.scaleX == -1 then
                local critChance = love.math.random(1, 3)
                if critChance == 1 then
                    table.insert(listOfPopUps, PopUp(player.x + math.random(-4, 4), player.y, 'crit!', 10, 2.5, 'yellow', 1))
                    table.insert(listOfBullets, FireBullet2(player.x - player.width / 2 - 1, player.y + player.height / 2 - 8, -1))
                else
                    table.insert(listOfBullets, FireBullet1(player.x + player.width / 2, player.y + player.height / 2 - 4, -1))
                end
              
                table.insert(listOfBullets, FirePunch(player.x - player.width / 2 - 1, player.y + player.height / 2 - 4, player.scaleX))
            elseif player.scaleX == 1 then
                local critChance = love.math.random(1, 3)
                if critChance == 1 then
                    table.insert(listOfPopUps, PopUp(player.x + math.random(-4, 4), player.y, 'crit!', 10, 2.5, 'yellow', 1))
                    table.insert(listOfBullets, FireBullet2(player.x + player.width / 2 + 1, player.y + player.height / 2 - 8, 1))
                else
                    table.insert(listOfBullets, FireBullet1(player.x + player.width / 2, player.y + player.height / 2 - 4, 1))
                end
                
                table.insert(listOfBullets, FirePunch(player.x + player.width / 2 + 1, player.y + player.height / 2 - 4, player.scaleX))
            end
          
            player.health = player.health - 2
            player.alert1State = "resume"
            player.alert1Timer:after(0.5, function() player.alert1State = "pause" end)
            
        elseif player.currentWeapon == "waterPunch" and player.blueEnergy >= 1 then
            player.burnTime = 0
            player.attackDuration = 15
            if player.scaleX == -1 then
                table.insert(listOfBullets, WaterPunch(player.x - player.width / 2 - 1, player.y + player.height / 2 - 4, player.scaleX))
            elseif player.scaleX == 1 then
                table.insert(listOfBullets, WaterPunch(player.x + player.width / 2 + 1, player.y + player.height / 2 - 4, player.scaleX))
            end
            player.blueEnergy = player.blueEnergy - 1
            player.alert2State = "resume"
            player.alert2Timer:after(0.5, function() player.alert2State = "pause" end)
            
        elseif player.currentWeapon == "waterBullet1" and player.blueEnergy >= 2 then
            player.burnTime = 0
            player.attackDuration = 15
            if player.scaleX == -1 then
                local critChance = love.math.random(1, 1)
                if critChance == 1 then
                    table.insert(listOfPopUps, PopUp(player.x + math.random(-4, 4), player.y, 'crit!', 10, 2.5, 'yellow', 1))
                    table.insert(listOfBullets, WaterBullet2(player.x - player.width / 2 - 1, player.y + player.height / 2 - 8, -1))
                else
                    table.insert(listOfBullets, WaterBullet1(player.x + player.width / 2, player.y + player.height / 2 - 4, -1))
                end
              
                table.insert(listOfBullets, WaterPunch(player.x - player.width / 2 - 1, player.y + player.height / 2 - 4, player.scaleX))
            elseif player.scaleX == 1 then
                local critChance = love.math.random(1, 1)
                if critChance == 1 then
                    table.insert(listOfPopUps, PopUp(player.x + math.random(-4, 4), player.y, 'crit!', 10, 2.5, 'yellow', 1))
                    table.insert(listOfBullets, WaterBullet2(player.x + player.width / 2 + 1, player.y + player.height / 2 - 8, 1))
                else
                    table.insert(listOfBullets, WaterBullet1(player.x + player.width / 2, player.y + player.height / 2 - 4, 1))
                end
                
                table.insert(listOfBullets, WaterPunch(player.x + player.width / 2 + 1, player.y + player.height / 2 - 4, player.scaleX))
            end
          
            --player.blueEnergy = player.blueEnergy - 2
            player.alert2State = "resume"
            player.alert2Timer:after(0.5, function() player.alert2State = "pause" end)
            
        end
    end
    
    if key == '1' then
        player.currentWeapon = 'normalPunch'
    end
    if key == '2' then
        player.currentWeapon = 'windPunch'
    end
    if key == '3' then
        player.currentWeapon = 'windBullet1'
    end
    if key == '4' then
        player.currentWeapon = 'firePunch'
    end
    if key == '5' then
        player.currentWeapon = 'fireBullet1'
    end
    if key == '6' then
        table.insert(listOfEnemies, Scorpion(450, 0, 70, 70))
    end
    if key == '7' then
        player.currentWeapon = 'waterPunch'
    end
    if key == '8' then
        player.currentWeapon = 'waterBullet1'
    end
end