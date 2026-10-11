# Calculate Normalized Difference Moisture Index (NDMI)

Computes the Normalized Difference Moisture Index (NDMI) to assess
vegetation canopy liquid water content.

## Usage

``` r
calc_ndmi(nir, swir1)
```

## Arguments

- nir:

  Near-infrared band
  ([`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  or numeric).

- swir1:

  Short-wave infrared 1 band
  ([`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  or numeric).

## Value

A
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
(named `"NDMI"`) or numeric vector with index values.

## Details

\$\$NDMI = \frac{NIR - SWIR1}{NIR + SWIR1}\$\$

## References

Gao, B. C. (1996). NDWI—A normalized difference water index for remote
sensing of vegetation liquid water from space. Remote Sensing of
Environment, 58(3), 257-266.

## See also

[`calc_msi`](https://sowsalim01.github.io/GeoIndexR/reference/calc_msi.md),
[`geo_index`](https://sowsalim01.github.io/GeoIndexR/reference/geo_index.md)

## Examples

``` r
calc_ndmi(nir = 0.7, swir1 = 0.3)
#> [1] 0.4
```
