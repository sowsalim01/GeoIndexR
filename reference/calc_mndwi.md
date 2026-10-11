# Calculate Modified Normalized Difference Water Index (MNDWI)

Computes Xu's Modified Normalized Difference Water Index (MNDWI),
substituting SWIR1 for NIR to enhance open water features in urban
landscapes.

## Usage

``` r
calc_mndwi(green, swir1)
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
(named `"MNDWI"`) or numeric vector with index values.

## Details

\$\$MNDWI = \frac{GREEN - SWIR1}{GREEN + SWIR1}\$\$

**Description & Purpose**: Standard NDWI can produce false water
detections on built-up and impervious surfaces. MNDWI suppresses
built-up noise significantly because urban land has high SWIR
reflectance.

## References

Xu, H. (2006). Modification of normalised difference water index (NDWI)
to enhance open water features in remotely sensed imagery. IJRS, 27(14),
3025-3033.

## See also

[`calc_ndwi`](https://sowsalim01.github.io/GeoIndexR/reference/calc_ndwi.md),
[`calc_awei`](https://sowsalim01.github.io/GeoIndexR/reference/calc_awei.md),
[`geo_index`](https://sowsalim01.github.io/GeoIndexR/reference/geo_index.md)

## Examples

``` r
calc_mndwi(green = 0.7, swir1 = 0.1)
#> [1] 0.75
```
