# Calculate Soil Adjusted Vegetation Index (SAVI)

Computes the Soil Adjusted Vegetation Index (SAVI) to minimize soil
brightness and background influences, using a canopy background
adjustment factor `L`.

## Usage

``` r
calc_savi(nir, red, L = 0.5)
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

- L:

  Soil adjustment factor. Defaults to `0.5`.

## Value

A
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
(named `"SAVI"`) or numeric vector with index values.

## Details

\$\$SAVI = \frac{NIR - RED}{NIR + RED + L} \times (1 + L)\$\$

**Description & Purpose**: In arid, semi-arid, or sparsely vegetated
regions, exposed soil background alters red and NIR reflectance,
distorting standard vegetation indices like NDVI. SAVI introduces a soil
line calibration constant `L` that stabilizes the index.

**Parameter `L`**:

- `L = 0.5` (default): Optimal for intermediate to moderate vegetation
  cover.

- `L = 1.0`: Recommended for very low / sparse vegetation cover.

- `L = 0.25`: Recommended for higher vegetation densities.

- When `L = 0`, SAVI is mathematically identical to NDVI.

## References

Huete, A. R. (1988). A soil-adjusted vegetation index (SAVI). Remote
Sensing of Environment, 25(3), 295-309.

## See also

[`geo_index`](https://sowsalim01.github.io/GeoIndexR/reference/geo_index.md),
[`calc_osavi`](https://sowsalim01.github.io/GeoIndexR/reference/calc_osavi.md),
[`calc_msavi`](https://sowsalim01.github.io/GeoIndexR/reference/calc_msavi.md),
[`calc_ndvi`](https://sowsalim01.github.io/GeoIndexR/reference/calc_ndvi.md)

## Examples

``` r
# Numeric scalar calculation
calc_savi(nir = 0.7, red = 0.2, L = 0.5)
#> [1] 0.5357143

# Raster layer calculation
img <- get_example_data()
savi_rast <- calc_savi(nir = img[["nir"]], red = img[["red"]], L = 0.5)
print(savi_rast)
#> class       : SpatRaster
#> size        : 10, 10, 1  (nrow, ncol, nlyr)
#> resolution  : 10, 10  (x, y)
#> extent      : 440000, 440100, 5410000, 5410100  (xmin, xmax, ymin, ymax)
#> coord. ref. : WGS 84 / UTM zone 31N (EPSG:32631)
#> source(s)   : memory
#> name        :     SAVI
#> min value   :   -0.102
#> max value   : 0.876714
```
