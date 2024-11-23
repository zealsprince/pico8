--entity handling system

entities = {}

local classes = {}
local objects = {}
local id = 0

function entities.add(class, constructor)
    if not classes[class] then classes[class] = constructor end
end

function entities.extend(class, params)
    if classes[class] then return classes[class](params) else return end
end

function entities.create(class, params)
    params = params or {}

    if not classes[class] then return end

    local entity = classes[class](params)
    if not entity then return end

    id += 1
    entity.class = class
    entity.state = { update = true, draw = true }
    entity.id = id

    objects[id] = entity

    return entity
end

function entities.destroy(entity)
    local function callback()
        entity.state.update = false
        entity.state.draw = false
        objects[entity.id] = nil
    end

    if entity.ondestroy then
        entity.ondestroy(callback)
    else
        callback()
    end
end

function entities.update()
    for i, entity in pairs(objects) do
        if entity.state.update then
            entity:update()
        end
    end
end

function entities.draw()
    for i, entity in pairs(objects) do
        if entity.state.draw then
            entity:draw()
        end
    end
end

function entities.init()
    -- Base entity class
    entities.add(
        "base",
        function(params)
            local base = {}
            function base:update() end
            function base:draw() end
            function base:ondestroy() end
            return base
        end
    )
end
