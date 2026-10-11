# Calculate Index-Based Built-Up Index (IBI)

Computes the Index-Based Built-Up Index (IBI) by synthesizing NDBI,
SAVI, and MNDWI.

## Usage

``` r
calc_ibi(swir1, nir, red, green, L = 0.5)
```

## Arguments

- swir1:

  Short-wave infrared 1 band
  ([`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  or numeric).

- nir:

  Near-infrared band
  ([`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  or numeric).

- red:

  Red band
  ([`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  or numeric).

- green:

  Green band
  ([`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  or numeric).

- L:

  Soil adjustment factor for internal SAVI. Defaults to `0.5`.

## Value

A
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
(named `"IBI"`) or numeric vector with index values.

## References

Xu, H. (2007). Extraction of urban built-up land features from Landsat
imagery using a new index-based approach. International Journal of
Remote Sensing, 29(14), 4267-4283.

## See also

[`calc_ndbi`](https://sowsalim01.github.io/GeoIndexR/reference/calc_ndbi.md),
[`geo_index`](https://sowsalim01.github.io/GeoIndexR/reference/geo_index.md)

## Examples

``` r
calc_ibi(swir1 = 0.4, nir = 0.3, red = 0.2, green = 0.1)
#> [1] -4.478261
```
