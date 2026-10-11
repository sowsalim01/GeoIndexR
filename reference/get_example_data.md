# Get Example Multispectral SpatRaster

Returns a ready-to-use synthetic 6-band
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
for fast, reproducible examples and unit testing without downloading
satellite scenes.

## Usage

``` r
get_example_data()
```

## Value

A
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
with 6 layers named `"blue"`, `"green"`, `"red"`, `"nir"`, `"swir1"`,
`"swir2"`.

## Details

The raster is generated programmatically (10 x 10 pixels, 100 m x 100 m
extent, EPSG:32631). It contains three simulated land-cover types:
healthy vegetation (pixels 2-40), water (pixels 41-70), and built-up /
bare soil (pixels 71-100). Pixel 1 is `NA` in all bands for boundary /
NA-handling verification.

Spectral bands (reflectance 0-1):

- `blue`: Blue (0.45 - 0.51 um)

- `green`: Green (0.53 - 0.59 um)

- `red`: Red (0.64 - 0.67 um)

- `nir`: Near-infrared (0.85 - 0.88 um)

- `swir1`: Short-wave infrared 1 (1.57 - 1.65 um)

- `swir2`: Short-wave infrared 2 (2.11 - 2.29 um)

## Examples

``` r
img <- get_example_data()
print(img)
#> class       : SpatRaster
#> size        : 10, 10, 6  (nrow, ncol, nlyr)
#> resolution  : 10, 10  (x, y)
#> extent      : 440000, 440100, 5410000, 5410100  (xmin, xmax, ymin, ymax)
#> coord. ref. : WGS 84 / UTM zone 31N (EPSG:32631)
#> source(s)   : memory
#> names       :     blue,    green,      red,      nir,    swir1,    swir2
#> min values  : 0.022892, 0.042552, 0.021383, 0.010273, 0.005215, 0.001147
#> max values  :  0.19989, 0.247843, 0.346209, 0.839893, 0.546363, 0.447115
terra::nlyr(img)
#> [1] 6
```
