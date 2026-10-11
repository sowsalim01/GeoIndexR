# Compute a Spectral Index from Multispectral Raster Data

Calculates a specified spectral or geospatial index from a
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
object or a raster file path. Band names are automatically resolved
using heuristic matching, sensor presets, or explicit user mapping.

## Usage

``` r
geo_index(image, index, bands = NULL, scale_factor = NULL, sensor = NULL, ...)
```

## Arguments

- image:

  A
  [`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  object or a character string specifying the file path to a raster
  image on disk.

- index:

  Character string specifying the index to compute (case-insensitive,
  e.g., `"NDVI"`, `"SAVI"`, `"EVI"`, `"NDWI"`, etc.). See
  [`list_indices`](https://sowsalim01.github.io/GeoIndexR/reference/list_indices.md)
  or
  [`index_registry`](https://sowsalim01.github.io/GeoIndexR/reference/index_registry.md)
  for supported indices.

- bands:

  Optional named vector or list specifying custom band mapping (e.g.,
  `c(nir = "B08", red = "B04")` or `c(nir = 4, red = 3)`).

- scale_factor:

  Optional numeric scaling divisor (e.g., `10000` for Sentinel-2 L2A or
  Landsat surface reflectance) to convert integer Digital Numbers into
  physical reflectance `[0, 1]`.

- sensor:

  Optional character string specifying a sensor preset for automatic
  band name resolution (e.g., `"sentinel2"`, `"landsat8"`,
  `"landsat9"`).

- ...:

  Additional parameters passed to the index calculation function (e.g.,
  soil adjustment factor `L` for SAVI, or gain factor `G` for EVI).

## Value

A single-layer
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
object containing the computed index values, with layer name set to the
uppercase index code, preserving all original spatial properties (CRS,
resolution, extent, dimensions).

## Examples

``` r
img <- get_example_data()

# 1. Compute NDVI
ndvi <- geo_index(img, "NDVI")
print(ndvi)
#> class       : SpatRaster
#> size        : 10, 10, 1  (nrow, ncol, nlyr)
#> resolution  : 10, 10  (x, y)
#> extent      : 440000, 440100, 5410000, 5410100  (xmin, xmax, ymin, ymax)
#> coord. ref. : WGS 84 / UTM zone 31N (EPSG:32631)
#> source(s)   : memory
#> name        :     NDVI
#> min value   : -0.49852
#> max value   : 0.920143

# 2. Compute SAVI with custom parameter
savi <- geo_index(img, "SAVI", L = 0.5)

# 3. Compute EVI with scale factor for raw DN values
evi <- geo_index(img, "EVI", scale_factor = 1)
```
