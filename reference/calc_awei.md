# Calculate Automated Water Extraction Index (AWEI)

Computes the Automated Water Extraction Index (AWEI) to extract surface
water while suppressing shadow artifacts and dark impervious surfaces.

## Usage

``` r
calc_awei(green, nir, swir1, swir2)
```

## Arguments

- green:

  Green band
  ([`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  or numeric).

- nir:

  Near-infrared band
  ([`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  or numeric).

- swir1:

  SWIR 1 band
  ([`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  or numeric).

- swir2:

  SWIR 2 band
  ([`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  or numeric).

## Value

A
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
(named `"AWEI"`) or numeric vector with index values.

## Details

\$\$AWEI = 4 \times (GREEN - SWIR1) - (0.25 \times NIR + 2.75 \times
SWIR2)\$\$

## References

Feyisa, G. L., Meilby, H., Fensholt, R., & Proud, S. R. (2014).
Automated Water Extraction Index: A new technique for surface water
mapping using Landsat imagery. Remote Sensing of Environment, 140,
23-35.

## See also

[`calc_ndwi`](https://sowsalim01.github.io/GeoIndexR/reference/calc_ndwi.md),
[`calc_mndwi`](https://sowsalim01.github.io/GeoIndexR/reference/calc_mndwi.md),
[`geo_index`](https://sowsalim01.github.io/GeoIndexR/reference/geo_index.md)

## Examples

``` r
calc_awei(green = 0.5, nir = 0.2, swir1 = 0.1, swir2 = 0.05)
#> [1] 1.4125
```
