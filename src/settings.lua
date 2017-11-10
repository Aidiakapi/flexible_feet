data:extend({
    {
        name = 'flexible_feet_expression',
        type = 'string-setting',
        setting_type = 'startup',
        order = 'a',
        default_value = '1 - pow(1 - x, 2)',
        allow_blank = false
    },
    {
        name = 'flexible_feet_round',
        type = 'bool-setting',
        setting_type = 'startup',
        order = 'b',
        default_value = true
    },
    {
        name = 'flexible_feet_range_lower',
        type = 'double-setting',
        setting_type = 'startup',
        order = 'c',
        default_value = 0,
        minimum_value = 0,
        maximum_value = 1000
    },
    {
        name = 'flexible_feet_range_upper',
        type = 'double-setting',
        setting_type = 'startup',
        order = 'd',
        default_value = 1,
        minimum_value = 0,
        maximum_value = 1000
    },
    {
        name = 'flexible_feet_ignored_tile_types',
        type = 'string-setting',
        setting_type = 'startup',
        order = 'e',
        default_value = '',
        allow_blank = true
    },
})
