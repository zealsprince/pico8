pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
#include ../library/entities.lua

function _init()
    level.load()
end

function _update()
    entities.update()
end

function _draw()
    cls()
    rectfill(0, 0, 256, 256, 1)
    map(0, 0, 0, 0, 64, 64)
    entities.draw()
end

entities.add(
    "collider",
    function(params)
        local c = entities.extend("base")
        local collider = c
        -- naming alias
        c.x = params.x or 64
        c.y = params.y or 64
        c.w = params.w or 16
        c.h = params.h or 16
        return collider
    end
)

entities.add(
    "fox",
    function(params)
        local f = entities.extend("collider", params)
        local fox = f
        -- make an alias for easier function naming
        f.headx = f.x
        f.heady = f.y
        f.bodyx = f.x
        f.bodyy = f.y
        f.dx = 0
        f.dy = 0
        f.dir = 1
        f.speed = 1
        f.friction = 0.2
        function fox:move(speed)
            self.dx = speed
            self.dir = speed > 0
        end
        function fox:update()
            if btn(⬅️) then self:move(-self.speed) end
            if btn(➡️) then self:move(self.speed) end
            self.x += self.dx
            self.dx = lerp(self.dx, 0, self.friction)
            self.headx = lerp(self.headx, self.x - (8 * bitbool(not self.dir)), 0.5)
            self.heady = lerp(self.heady, self.y, 0.5)
            self.bodyx = lerp(self.bodyx, self.x - (8 * bitbool(self.dir)), 0.5)
            self.bodyy = lerp(self.bodyy, self.y, 0.5)
        end
        function fox:draw()
            spr(1, self.bodyx, self.bodyy - 8, 1, 1, not self.dir)
            spr(2, self.headx, self.heady - 8, 1, 1, not self.dir)
            circfill(self.x, self.y - 2, 2, 9)
            trail(self.x, self.y, self.x + 64, self.y, 2, 9)
        end
        return fox
    end
)

entities.add(
    "grass",
    function(params)
        local g = entities.extend("base")
        local grass = g
        g.x = params.x or 64
        g.y = params.y or 64
        function grass:update()
        end
        function grass:draw()
        end
        return grass
    end
)
-->8

--level instantiation

level = {}

local lookup = {}
lookup[2] = function(mapx, mapy, realx, realy) entities.create("fox", { x = realx, y = realy }) return 0 end

--run lookup code and set tile to return value
local function process(x, y, value)
    if lookup[value] then mset(x, y, lookup[value](x, y, x * 8 + 1, (y * 8) + 8)) end
end

function level.load()
    for y = 0, 128 do
        for x = 0, 128 do
            process(x, y, mget(x, y))
        end
    end
end
-->8

--library functions

function lerp(from, to, factor)
    return from + (to - from) * factor
end

function bitbool(value)
    return value and 1 or 0
end

function dist(x1, y1, x2, y2)
    return sqrt(x2 - x1 / y2 - y1)
end

function trail(x1, y1, x2, y2, r, c)
    local a = abs(dist(x1, y1, x2, y2))
    local sx = (x2 - x1) / a
    local sy = (y2 - y1) / a
    for i = 0, a do
        circfill(x1 + sx * i, y1 + sy * i, r, c)
    end
end

__gfx__
00000000000000000909000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000990900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000099900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000097090003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000999999903000300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000099999999977703030300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000999999997700003330303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000099999999970000033333303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bb3b3b3b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
34334133000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
34211313000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
31323112000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
21122144000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
21341242000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
12411221000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
24224211000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
70000000888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07000000888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700000888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07000000888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70000000888803000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
99999000033303030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
99999000333333030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000009090000000000000000000000000000000000000909000000000000000000000000000000000000000
00000000000000000000000000000000000000000000090990000000000000000000000000000000000009099000000000000000000000000000000000000000
00000000000000000000000000000000000000000000099900000000000000000000000000000000000009990000000000000000000000000000000000000000
00000000000000000000000000000000000000000000907900000000000000000000000000000000000090790000000000000000000000000000000000000000
00000000000000000000000000000000000000000099999999990000000000000000000000000000009999999999000000000000000000000000000000000000
00000000000000000000000000000000000000000077799999999000000000000000000000000000007779999999900000000000000000000000000000000000
00000000000000000000000000000000000000000000077999999000000000000000000000000000000007799999900000000000000000000000000000000000
00000000000000000000000000000000000000000000000799999000000000000000000000000000000000079999900000000000000000000000000000000000
00000000000000000000000000000000000000000000000009990000000000000000000000000000000000000999000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000090900000000000000000000000000000000000000000000090900000000000000000000000000000000000000000000000
00000000000000000000000000000909900000000000000000000000000000000000000000000909900000000000000000000000000000000000000000000000
00000000000000000000000000000999000000000000000000000000000000000000000000000999000000000000000000000000000000000000000000000000
00000000000000000000000000009079000000000000000000000000000000000000000000009079000000000000000000000000000000000000000000000000
00000000000000000000000000999999999900000000000000000000000000000000000000999999999900000000000000000000000000000000000000000000
00000000000000000000000000777999999990000000000000000000000000000000000000777999999990000000000000000000000000000000000000000000
00000000000000000000000000000779999990000000000000000000000000000000000000000779999990000000000000000000000000000000000000000000
00000000000000000000000000000007999990000000000000000000000000000000000000000007999990000000000000000000000000000000000000000000
00000000000000000000000000000000099900000000000000000000000000000000000000000000099900000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000090900000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000909900000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000999000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000300000000009079000000000000000003000000030000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000300030000999999999900000000000003000300030003000000000000000000000000000000000000000000
00000000000000000000000000000000000000000303030000777999999990000000000003030300030303000000000000000000000000000000000000000000
00000000000000000000000000000000000000000333030300000779999990000000000003330303033303030000000000000000000000000000000000000000
00000000000000000000000000000000000000003333330300000007999990000000000033333303333333030000000000000000000000000000000000000000
0000000000000000000000000000000000000000bb3b3b3bbb3b3b3bb9993b3bbb3b3b3bbb3b3b3bbb3b3b3b0000000000000000000000000000000000000000
00000000000000000000000000000000000000003433413334334133343341333433413334334133343341330000000000000000000000000000000000000000
00000000000000000000000000000000000000003421131334211313342113133421131334211313342113130000000000000000000000000000000000000000
00000000000000000000000000000000000000003132311231323112313231123132311231323112313231120000000000000000000000000000000000000000
00000000000000000000000000000000000000002112214421122144211221442112214421122144211221440000000000000000000000000000000000000000
00000000000000000000000000000000000000002134124221341242213412422134124221341242213412420000000000000000000000000000000000000000
00000000000000000000000000000000000000001241122112411221124112211241122112411221124112210000000000000000000000000000000000000000
00000000000000000000000000000000000000002422421124224211242242112422421124224211242242110000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

__gff__
0000800800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000030002000303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000404040404040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
00010000000500105002050030500505007050090500b0500e0500f05011050130501505016050180501a0501c0501e0501f05001050010500005000050000500005000050010500105001050010500005002050
000100000000000000000000000000000000000000000000000000000005050060500605007050070500605005050050500400004000050000500000000000000000000000000000000000000000000000000000
000100001f6501f6501e6501d650196501765015650116500e6500c6500865007650046500165000650006501460012600116000f6000e6000d6000b600086000860006600046000360002600026000160001600