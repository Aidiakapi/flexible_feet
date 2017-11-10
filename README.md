# Flexible Feet

Mod that allows you to modify the walking speed of surfaces.

The default behavior causes vanilla surfaces to have at least 100% movement speed, however for mods like Alien Biomes, the movement speed is increased based on a curve.

You can also configure the mod to do the opposite, and actually make particular surfaces slower. Or do something like have concrete and stone give the same movement speed bonus.

## Configuration

You can use a math function to modify the behavior. [Here is a sheet visualising a bunch of examples.](https://www.desmos.com/calculator/hhm28qdg8l) If you want to use any of these curves, look at the number of the formula, and copy-paste what's written below into the setting:

1. `0.5 * x + 0.5`
2. `0.25 * x + 0.75`
3. `1 - pow(1 - x, 2)` (default)
4. `1 - pow(1 - x, 4)`
5. `pow(x, 0.5)`
6. `pow(x, 0.25)`
7. `sin(0.5 * pi * x)`
8. `0.5 * sin(pi * x - 0.5 * pi) + 0.5`
9. `sin(0.5 * pi * x - 0.5 * pi) + 1`

The math functions will be evaluated with the domain [0,1], which can be modified with the respective settings.

Enabling rounding will round to the nearest 10%.
