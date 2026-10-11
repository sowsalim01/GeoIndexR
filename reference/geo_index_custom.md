# Compute a Custom Spectral or Geospatial Index

Computes a custom spectral or geospatial index from a raster image or
numeric inputs using a user-defined mathematical formula. The formula is
securely parsed, validated against an AST whitelist of safe mathematical
functions and operators, and evaluated vectorially with `terra`.

## Usage

``` r
geo_index_custom(
  image,
  formula,
  bands = NULL,
  params = list(),
  name = "CustomIndex",
  scale_factor = NULL,
  denominator_tolerance = 1e-06,
  sensor = NULL,
  ...
)
```

## Arguments

- image:

  A
  [`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  object or a character string specifying the file path to a raster
  image on disk.

- formula:

  Character string specifying the mathematical expression to compute
  (e.g., `"(nir - red) / (nir + red)"` or
  `"G * (nir - red) / (nir + C1 * red - C2 * blue + L)"`).

- bands:

  Optional named vector or list specifying custom band mapping (e.g.,
  `c(nir = 4, red = 3)` or `c(nir = "B08", red = "B04")`).

- params:

  Optional named list of numeric parameter constants used in the formula
  (e.g., `list(G = 2.5, C1 = 6.0, C2 = 7.5, L = 1.0)`).

- name:

  Character string specifying the name of the output index layer.
  Defaults to `"CustomIndex"`.

- scale_factor:

  Optional numeric scaling divisor (e.g., `10000` for Sentinel-2 or
  Landsat surface reflectance products) applied to input bands before
  evaluating the formula.

- denominator_tolerance:

  Numeric threshold for near-zero denominators. Divisions where the
  absolute denominator is smaller than this value are safely converted
  to `NA`. Defaults to `1e-6`.

- sensor:

  Optional character string specifying a sensor preset for automatic
  band name resolution (e.g., `"sentinel2"`, `"landsat8"`).

- ...:

  Additional named numeric constants passed directly to the formula
  evaluation.

## Value

A single-layer
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
(or numeric object) containing the computed custom index values,
preserving all original spatial properties.

## Examples

``` r
img <- get_example_data()

# 1. Simple custom ratio index
custom_ratio <- geo_index_custom(
  img,
  formula = "(nir - red) / (nir + red)",
  bands = c(red = "red", nir = "nir"),
  name = "CustomNDVI"
)
print(custom_ratio)
#> class       : SpatRaster
#> size        : 10, 10, 1  (nrow, ncol, nlyr)
#> resolution  : 10, 10  (x, y)
#> extent      : 440000, 440100, 5410000, 5410100  (xmin, xmax, ymin, ymax)
#> coord. ref. : WGS 84 / UTM zone 31N (EPSG:32631)
#> source(s)   : memory
#> name        : CustomNDVI
#> min value   :   -0.52443
#> max value   :   0.920132

# 2. Custom parameterized index
custom_evi <- geo_index_custom(
  img,
  formula = "G * (nir - red) / (nir + C1 * red - C2 * blue + L)",
  bands = c(blue = "blue", red = "red", nir = "nir"),
  params = list(G = 2.5, C1 = 6.0, C2 = 7.5, L = 1.0),
  name = "CustomEVI"
)
print(custom_evi)
#> class       : SpatRaster
#> size        : 10, 10, 1  (nrow, ncol, nlyr)
#> resolution  : 10, 10  (x, y)
#> extent      : 440000, 440100, 5410000, 5410100  (xmin, xmax, ymin, ymax)
#> coord. ref. : WGS 84 / UTM zone 31N (EPSG:32631)
#> source(s)   : memory
#> name        : CustomEVI
#> min value   : -0.101884
#> max value   :  1.147914
```
