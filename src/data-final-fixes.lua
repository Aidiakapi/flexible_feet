-- Load and process all settings

local EPS = 0.001
local default_expression = '1 - pow(1 - x, 2)'

local expression = settings.startup.flexible_feet_expression.value
local should_round = settings.startup.flexible_feet_round.value
local range_lower, range_upper = settings.startup.flexible_feet_range_lower.value, settings.startup.flexible_feet_range_upper.value

local exclusions = {}
for name in (settings.startup.flexible_feet_ignored_tile_types.value .. ";"):gmatch("([^;]*);") do 
    if #name > 0 then
        exclusions[name] = true
    end
end

local map_function
do
    local expression_env = {
        abs = math.abs,
        acos = math.acos,
        asin = math.asin,
        atan = math.atan,
        atan2 = math.atan2,
        ceil = math.ceil,
        cos = math.cos,
        cosh = math.cosh,
        deg = math.deg,
        exp = math.exp,
        floor = math.floor,
        fmod = math.fmod,
        frexp = math.frexp,
        ldexp = math.ldexp,
        log = math.log,
        log10 = math.log10,
        max = math.max,
        min = math.min,
        modf = math.modf,
        pi = math.pi,
        pow = math.pow,
        rad = math.rad,
        round = function (x)
            return math.floor(x + 0.5)
        end,
        sin = math.sin,
        sinh = math.sinh,
        sqrt = math.sqrt,
        tan = math.tan,
        tanh = math.tanh
    }

    local function load_map_function(expression)
        local expression_fn
        -- No particular range specified
        if range_upper - range_lower <= EPS then
            expression_fn = 'return function (x) return (' .. expression .. ') end'
        else
            expression_fn = ('return function (x) if x < %s or x >= %s then return x end return (%s) end'):format(range_lower, range_upper, expression)
        end
        
        local fn_factory, err_msg = load(expression_fn, expression, 't', expression_env)
        if err_msg then
            log('error parsing math expression setting: ' .. err_msg)
            return load_map_function(default_expression)
        end
        local success, fn = pcall(fn_factory)
        if not success or type(fn) ~= 'function' then
            log('error parsing math expression setting: ' .. fn)
            return load_map_function(default_expression)
        end

        -- Test with minimum and maximum values in range
        local s1, err1 = pcall(fn, range_lower)
        local s2, err2 = pcall(fn, range_upper)
        if not s1 or not s2 then
            log('error invoking math expression from setting: ' .. (not s1 and err1 or err2))
            return load_map_function(default_expression)
        end
        if type(err1) ~= 'number' or type(err2) ~= 'number' then
            log('invoking math expression did not result in a number')
            return load_map_function(default_expression)
        end

        return fn
    end
    map_function = load_map_function(expression)
end

local function map_value_post(value)
    if should_round then
        value = math.floor(value * 10 + 0.5) / 10
    end
    if math.abs(value - 1) < EPS then return nil end
    return value
end

for _, tile in pairs(data.raw.tile) do
    if not tile.name or not exclusions[tile.name] then
        log(([[%q from %s %s]]):format(tile.name, tile.vehicle_friction_modifier, tile.walking_speed_modifier))
        tile.vehicle_friction_modifier = map_value_post(1 / map_function(1 / (tile.vehicle_friction_modifier or 1)))
        tile.walking_speed_modifier = map_value_post(map_function(tile.walking_speed_modifier or 1))
        log(([[%q to   %s %s]]):format(tile.name, tile.vehicle_friction_modifier, tile.walking_speed_modifier))
    end
end
