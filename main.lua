TILE_SIZE = 16;
CAMERA_SCALE = 3;

local sti = require("lib/sti/sti");
local windfield = require("lib/windfield");

local Player = require("src.Player");
local Camera = require("src.Camera");
local Wall = require("src.Wall");
local EffectsHandler = require("src.EffectsHandler");
local Enemy = require("src.Enemy");

function love.load()
    love.graphics.setBackgroundColor(26 / 255, 26 / 255, 26 / 255);
    love.window.setMode(0, 0, {fullscreen = true});
    love.graphics.setDefaultFilter("nearest", "nearest");

    world = windfield.newWorld(0, 0, false);

    player = Player(TILE_SIZE * 30, TILE_SIZE * 30, 32, 32, 140, 12, 12, 12,
                    world);
    enemy = Enemy(TILE_SIZE * 32, TILE_SIZE * 32, 32, 32, 60, 10, 9, 2, '/assets/sprites/characters/slime.png', world);

    camera =
        Camera(CAMERA_SCALE, player.collider:getX(), player.collider:getY());

    gameMap = sti("maps/village/village.lua");

    effectsHandler = EffectsHandler()

    if gameMap.layers["walls"] then
        for i, obj in pairs(gameMap.layers["Walls"].objects) do
            local wall = Wall(obj.x, obj.y, obj.width, obj.height, world);
        end
    end
end

function love.update(dt)
    world:update(dt);
    player:updateAbs(dt, effectsHandler);
    enemy:updateAbs(dt)
    camera:update(dt, player, gameMap);
    gameMap:update(dt);
    effectsHandler:updateEffects(dt);
end

function love.draw()
    love.graphics.setColor(1, 1, 1);

    camera.camera:attach();

    gameMap:drawLayer(gameMap.layers["ground"]);
    gameMap:drawLayer(gameMap.layers["mountains"]);
    gameMap:drawLayer(gameMap.layers["walls"]);
    gameMap:drawLayer(gameMap.layers["decor"]);

    enemy:drawAbs();
    player:drawAbs();
    effectsHandler:drawEffects(0);

    gameMap:drawLayer(gameMap.layers["upperWalls"]);

    -- world:draw();

    camera.camera:detach();
end

function love.keypressed(key) if key == "escape" then love.event.quit(); end end

function love.mousepressed(x, y, button)
    if button == 1 then player:useItem('sword', camera.camera) end
end
