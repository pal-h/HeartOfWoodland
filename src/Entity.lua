local Class = require("lib.hump.class")
local Vector = require("lib.hump.vector")
local anim8 = require("lib.anim8.anim8")

Entity = Class {
    init = function(self, positionX, positionY, width, height, speed,
                    collisionClass, collisionWidth, collisionHeight,
                    heightOffset, animationSheet, world)
        self.dir = "down"
        self.dirX = 1
        self.dirY = 1
        self.prevDirX = 1
        self.prevDirY = 1
        self.speed = speed

        self.state = "default"

        self.collisionWidth = collisionWidth
        self.collisionHeight = collisionHeight

        self.heightOffset = heightOffset

        self.width = width
        self.height = height

        self.collider = world:newBSGRectangleCollider(positionX, positionY,
                                                      self.collisionWidth,
                                                      self.collisionHeight, 3, {
            collision_class = collisionClass
        })

        self.animationTimer = 0
        self.animationSheet = love.graphics.newImage(animationSheet)
        self.grid = anim8.newGrid(self.width, self.height,
                                  self.animationSheet:getWidth(),
                                  self.animationSheet:getHeight())

        self.animations = self:_getAnimationsAbs()
        self.currentAnimation = self:_getCurrentAnimationAbs()

    end,

    drawAbs = function()
        error("drawAbs method was not implemented in subclass")
    end,

    updateAbs = function(dt)
        error("updateAbs method was not implemented in subclass")
    end,

    _getAnimationsAbs = function()
        error("_getAnimationsAbs method was not implemented in subclass")
    end,

    _getCurrentAnimationAbs = function()
        error(
            "_getCurrentAnimationAbs method was not implemented in subclass")
    end,
    
    _distanceBetween = function(self, x1, y1, x2, y2)
        return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
    end,

    _getCenterPosition = function(self)
        local px, py = self.collider:getPosition()
        px = px - self.width / 2
        py = py - self.height / 2 - self.heightOffset

        return px, py
    end,

    _setDirFromVector = function(self, vec)
        local rad = math.atan2(vec.y, vec.x)
        if rad >= self.rotateMargin * -1 and rad < math.pi / 2 then
            self.dirX = 1
            self.dirY = 1
        elseif (rad >= math.pi / 2 and rad < math.pi) or
            (rad < (math.pi - self.rotateMargin) * -1) then
            self.dirX = -1
            self.dirY = 1
        elseif rad < 0 and rad > math.pi / -2 then
            self.dirX = 1
            self.dirY = -1
        else
            self.dirX = -1
            self.dirY = -1
        end
    end,

    _toMouseVector = function(self, camera)
        local px, py = self:_getCenterPosition()

        local mx, my = camera:mousePosition()
        return Vector.new(mx - px, my - py):normalized()
    end,

}

return Entity