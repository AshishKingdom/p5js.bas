'p5js.bas by Fellippe Heitor & Ashish Kushwaha
'Copyright <c> 2017-18
'Last update 4/4/2017



FUNCTION p5js.noise## (x AS _FLOAT, y AS _FLOAT, z AS _FLOAT)
STATIC Setup AS _BYTE
STATIC perlin() AS _FLOAT
STATIC PERLIN_YWRAPB AS _FLOAT, PERLIN_YWRAP AS _FLOAT
STATIC PERLIN_ZWRAPB AS _FLOAT, PERLIN_ZWRAP AS _FLOAT
STATIC PERLIN_SIZE AS _FLOAT, perlin_octaves AS _FLOAT
STATIC perlin_amp_falloff AS _FLOAT

IF NOT Setup THEN
    Setup = -1

    PERLIN_YWRAPB = 4
    PERLIN_YWRAP = INT(1 * (2 ^ PERLIN_YWRAPB))
    PERLIN_ZWRAPB = 8
    PERLIN_ZWRAP = INT(1 * (2 ^ PERLIN_ZWRAPB))
    PERLIN_SIZE = 4095

    perlin_octaves = 4
    perlin_amp_falloff = 0.5

    REDIM perlin(PERLIN_SIZE + 1) AS _FLOAT
    RANDOMIZE TIMER
    DIM i AS _FLOAT
    FOR i = 0 TO PERLIN_SIZE + 1
        perlin(i) = RND
    NEXT
END IF

x = ABS(x)
y = ABS(y)
z = ABS(z)

DIM xi AS _FLOAT, yi AS _FLOAT, zi AS _FLOAT
xi = INT(x)
yi = INT(y)
zi = INT(z)

DIM xf AS _FLOAT, yf AS _FLOAT, zf AS _FLOAT
xf = x - xi
yf = y - yi
zf = z - zi

DIM r AS _FLOAT, ampl AS _FLOAT, o AS _FLOAT
r = 0
ampl = .5

FOR o = 1 TO perlin_octaves
    DIM of AS _FLOAT, rxf AS _FLOAT
    DIM ryf AS _FLOAT, n1 AS _FLOAT, n2 AS _FLOAT, n3 AS _FLOAT
    of = xi + INT(yi * (2 ^ PERLIN_YWRAPB)) + INT(zi * (2 ^ PERLIN_ZWRAPB))

    rxf = 0.5 * (1.0 - COS(xf * _PI))
    ryf = 0.5 * (1.0 - COS(yf * _PI))

    n1 = perlin(of AND PERLIN_SIZE)
    n1 = n1 + rxf * (perlin((of + 1) AND PERLIN_SIZE) - n1)
    n2 = perlin((of + PERLIN_YWRAP) AND PERLIN_SIZE)
    n2 = n2 + rxf * (perlin((of + PERLIN_YWRAP + 1) AND PERLIN_SIZE) - n2)
    n1 = n1 + ryf * (n2 - n1)

    of = of + PERLIN_ZWRAP
    n2 = perlin(of AND PERLIN_SIZE)
    n2 = n2 + rxf * (perlin((of + 1) AND PERLIN_SIZE) - n2)
    n3 = perlin((of + PERLIN_YWRAP) AND PERLIN_SIZE)
    n3 = n3 + rxf * (perlin((of + PERLIN_YWRAP + 1) AND PERLIN_SIZE) - n3)
    n2 = n2 + ryf * (n3 - n2)

    n1 = n1 + (0.5 * (1.0 - COS(zf * _PI))) * (n2 - n1)

    r = r + n1 * ampl
    ampl = ampl * perlin_amp_falloff
    xi = INT(xi * (2 ^ 1))
    xf = xf * 2
    yi = INT(yi * (2 ^ 1))
    yf = yf * 2
    zi = INT(zi * (2 ^ 1))
    zf = zf * 2

    IF xf >= 1.0 THEN xi = xi + 1: xf = xf - 1
    IF yf >= 1.0 THEN yi = yi + 1: yf = yf - 1
    IF zf >= 1.0 THEN zi = zi + 1: zf = zf - 1
NEXT
p5js.noise## = r
END FUNCTION

FUNCTION p5js.map## (value##, minRange##, maxRange##, newMinRange##, newMaxRange##)
map## = ((value## - minRange##) / (maxRange## - minRange##)) * (newMaxRange## - newMinRange##) + newMinRange##
END FUNCTION
