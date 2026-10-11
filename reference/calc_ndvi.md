# Calculate Normalized Difference Vegetation Index (NDVI)

Computes the Normalized Difference Vegetation Index (NDVI) directly from
near-infrared (`nir`) and red (`red`) bands or numeric vectors.

## Usage

``` r
calc_ndvi(nir, red)
```

## Arguments

- nir:

  Near-infrared band
  ([`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  or numeric vector/matrix).

- red:

  Red band
  ([`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  or numeric vector/matrix).

## Value

A single-layer
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
(with layer name `"NDVI"`) or a numeric vector matching input
dimensions.

## Details

\$\$NDVI = \frac{NIR - RED}{NIR + RED}\$\$

**Description & Purpose**: NDVI is the most widely used remote sensing
index for monitoring vegetation greenness, photosynthetic activity, and
canopy vigor. Chlorophyll pigments in green leaves absorb red light
strongly, while the spongy mesophyll structure scatters near-infrared
light.

**Direct Band Usage vs
[`geo_index()`](https://sowsalim01.github.io/GeoIndexR/reference/geo_index.md)**:
While
[`geo_index`](https://sowsalim01.github.io/GeoIndexR/reference/geo_index.md)`(image, "NDVI")`
handles multi-band raster extraction and band mapping automatically,
`calc_ndvi()` is a direct, lower-level computation function that works
on:

- Individual single-layer
  [`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  objects (e.g. `nir = img[["nir"]], red = img[["red"]]`).

- Standard R numeric vectors, scalars, or matrices.

**Value Range & Interpretation**:

- **0.6 to 0.9**: Dense, healthy green vegetation (forests, mature
  crops).

- **0.2 to 0.5**: Moderate to sparse vegetation (grasslands, shrublands,
  young crops).

- **0.0 to 0.1**: Bare soil, rock, sand, impervious urban areas.

- **\< 0.0**: Water bodies, snow, ice, and clouds.

## References

Rouse, J. W., Haas, R. H., Schell, J. A., & Deering, D. W. (1974).
Monitoring the vernal advancement and retrogradation (Green wave effect)
of natural vegetation. NASA/GSFC Type III Final Report, Greenbelt, MD.

## See also

[`geo_index`](https://sowsalim01.github.io/GeoIndexR/reference/geo_index.md),
[`calc_savi`](https://sowsalim01.github.io/GeoIndexR/reference/calc_savi.md),
[`calc_evi`](https://sowsalim01.github.io/GeoIndexR/reference/calc_evi.md),
[`index_registry`](https://sowsalim01.github.io/GeoIndexR/reference/index_registry.md)

## Examples

``` r
library(terra)
#> terra 1.9.50

# --- Example 1: Direct calculation on numeric values ---
calc_ndvi(nir = 0.8, red = 0.2)
#> [1] 0.6

# Vectorized computation on numeric vectors:
nirs <- c(0.8, 0.5, 0.1, 0.02)
reds <- c(0.1, 0.3, 0.1, 0.05)
calc_ndvi(nir = nirs, red = reds)
#> [1]  0.7777778  0.2500000  0.0000000 -0.4285714

# --- Example 2: Calculation on extracted SpatRaster layers ---
img <- get_example_data()
ndvi_rast <- calc_ndvi(nir = img[["nir"]], red = img[["red"]])
print(ndvi_rast)
#> class       : SpatRaster
#> size        : 10, 10, 1  (nrow, ncol, nlyr)
#> resolution  : 10, 10  (x, y)
#> extent      : 440000, 440100, 5410000, 5410100  (xmin, xmax, ymin, ymax)
#> coord. ref. : WGS 84 / UTM zone 31N (EPSG:32631)
#> source(s)   : memory
#> name        :      NDVI
#> min value   : -0.488119
#> max value   :  0.919653
```
