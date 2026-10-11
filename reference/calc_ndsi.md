# Calculate Normalized Difference Snow Index (NDSI)

Computes the Normalized Difference Snow Index (NDSI) for mapping snow
and ice cover.

## Usage

``` r
calc_ndsi(green, swir1)
```

## Arguments

- green:

  Green band
  ([`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  or numeric).

- swir1:

  Short-wave infrared 1 band
  ([`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  or numeric).

## Value

A
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
(named `"NDSI"`) or numeric vector with index values.

## Details

\$\$NDSI = \frac{GREEN - SWIR1}{GREEN + SWIR1}\$\$

## References

Hall, D. K., Riggs, G. A., & Salomonson, V. V. (1995). Development of
methods for mapping global snow cover using moderate resolution imaging
spectroradiometer data. Remote Sensing of Environment, 54(2), 127-140.

## See also

[`geo_index`](https://sowsalim01.github.io/GeoIndexR/reference/geo_index.md)

## Examples

``` r
calc_ndsi(green = 0.8, swir1 = 0.2)
#> [1] 0.6
```
