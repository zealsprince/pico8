--particle system

local id_particle = 0
local parameters_particle = {
    _system = nil,
    _timestamp = 0,
    _id = 0,
    _age = 0,
    _dead = false,

    lifetime = 1,

    x = 0,
    y = 0,
    direction_x = 0,
    direction_y = 0,

    colors = { 4 },
    ss = 1,
    size = 1
}

local function instantiate_particle(system, params)
    local particle = {}
    for k, v in pairs(parameters_particle) do
        particle[k] = params[k] or v
    end
    particle._system = system
    particle._id = id_particle

    local t = time()
    particle._timestamp = t

    id_particle += 1

    function particle:update()
        self.x += self.direction_x + rnd(self.direction_x_random)
        self.y += self.direction_y + rnd(self.direction_y_random)

        self.direction_x += self._system.wind_x + cos(t + self.x / self._system.turbulence_scale) * self._system.turbulence_force
        self.direction_y += self._system.wind_y + sin(t + self.y / self._system.turbulence_scale) * self._system.turbulence_force

        self.direction_x *= 1 - self._system.damping
        self.direction_y *= 1 - self._system.damping

        self.size = self.ss * (1 - self._age / self.lifetime)
    end

    function particle:draw()
        circfill(self.x, self.y, self.size, self.colors[min(#self.colors, flr(self._age / self.lifetime * #self.colors) + 1)])
    end

    return particle
end

local id_system = 0
local parameters_system = {
    particles = {},
    id = 0,

    state = { update = true, draw = true },

    spawn_rate = 0.1,
    spawn_max = 100,

    lifetime = 1,

    x = 0,
    y = 0,
    direction_x = 0,
    direction_x_random = 0,
    direction_y = 0,
    direction_y_random = 0,

    wind_x = 0,
    wind_y = 0,
    wind_x_max = 0,
    wind_y_max = 0,

    turbulence_scale = 128,
    turbulence_force = 0,

    damping = 0,

    colors = { 7 },
    size = 4,
    size_random = 0
}

local function instantiate_system(params)
    local system = {}
    for k, v in pairs(parameters_system) do
        system[k] = params[k] or v
    end
    system.id = id_system
    id_system += 1

    system.particles = {}

    function system:update()
        self.wind_x = rnd(self.wind_x_max) - self.wind_x_max / 2
        self.wind_y = rnd(self.wind_y_max) - self.wind_y_max / 2

        if rnd() < self.spawn_rate and #self.particles < self.spawn_max then
            local particle = instantiate_particle(
                self, {
                    x = self.x,
                    y = self.y,
                    direction_x = self.direction_x + rnd(self.direction_x_random) - self.direction_x_random / 2,
                    direction_y = self.direction_y + rnd(self.direction_y_random) - self.direction_y_random / 2,
                    colors = self.colors,
                    ss = self.size + rnd(self.size_random) - self.size_random / 2,
                    damping = self.damping,
                    lifetime = self.lifetime
                }
            )

            add(self.particles, particle)
        end

        for i, p in pairs(self.particles) do
            p:update()
            p._age = time() - p._timestamp

            if p._age >= p.lifetime then
                p._dead = true
            end
        end

        for i = #self.particles, 1, -1 do
            local p = self.particles[i]

            if p._dead then
                del(self.particles, p)
            end
        end
    end

    function system:draw()
        for i, p in pairs(self.particles) do
            p:draw()
        end
    end

    return system
end

local systems = {}

particle_systems = {}
function particle_systems.new(params)
    local system = instantiate_system(params)

    systems[system.id] = system

    return system
end

function particle_systems.destroy(system)
    particle_systems[system.id] = nil
end

function particle_systems.update()
    for i, size in pairs(systems) do
        if size.state.update then
            size:update()
        end
    end
end

function particle_systems.draw()
    for i, size in pairs(systems) do
        if size.state.draw then
            size:draw()
        end
    end
end
