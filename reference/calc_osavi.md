# Calculate Optimized Soil-Adjusted Vegetation Index (OSAVI)

Computes the Optimized Soil-Adjusted Vegetation Index (OSAVI) with a
standard optimal adjustment parameter `theta = 0.16`.

## Usage

``` r
calc_osavi(nir, red, theta = 0.16)
```

## Arguments

- nir:

  Near-infrared band
  ([`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  or numeric).

- red:

  Red band
  ([`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  or numeric).

- theta:

  Canopy background adjustment factor. Defaults to `0.16`.

## Value

A
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
(named `"OSAVI"`) or numeric vector with index values.

## Details

\$\$OSAVI = \frac{NIR - RED}{NIR + RED + \theta} \times (1 + \theta)\$\$

**Description & Purpose**: OSAVI is an optimization of SAVI that fixes
`theta = 0.16`, which was found to provide optimal suppression of soil
background variation across a broad range of agricultural canopies.

## References

Rondeaux, G., Steven, M., & Baret, F. (1996). Optimization of
soil-adjusted vegetation indices. Remote Sensing of Environment, 55(2),
95-107.

## See also

[`calc_savi`](https://sowsalim01.github.io/GeoIndexR/reference/calc_savi.md),
[`calc_msavi`](https://sowsalim01.github.io/GeoIndexR/reference/calc_msavi.md),
[`geo_index`](https://sowsalim01.github.io/GeoIndexR/reference/geo_index.md)

## Examples

``` r
calc_osavi(nir = 0.7, red = 0.2)
#> [1] 0.5471698

img <- get_example_data()
osavi_rast <- calc_osavi(nir = img[["nir"]], red = img[["red"]])
print(osavi_rast)
#> class       : SpatRaster
#> size        : 10, 10, 1  (nrow, ncol, nlyr)
#> resolution  : 10, 10  (x, y)
#> extent      : 440000, 440100, 5410000, 5410100  (xmin, xmax, ymin, ymax)
#> coord. ref. : WGS 84 / UTM zone 31N (EPSG:32631)
#> source(s)   : memory
#> name        :    OSAVI
#> min value   : -0.13457
#> max value   : 0.899796
```
