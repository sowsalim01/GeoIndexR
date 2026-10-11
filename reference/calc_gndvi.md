# Calculate Green Normalized Difference Vegetation Index (GNDVI)

Computes the Green Normalized Difference Vegetation Index (GNDVI) from
near-infrared (`nir`) and green (`green`) bands.

## Usage

``` r
calc_gndvi(nir, green)
```

## Arguments

- nir:

  Near-infrared band
  ([`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  or numeric).

- green:

  Green band
  ([`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  or numeric).

## Value

A
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
(named `"GNDVI"`) or numeric vector with index values.

## Details

\$\$GNDVI = \frac{NIR - GREEN}{NIR + GREEN}\$\$

**Description & Purpose**: GNDVI is more sensitive to chlorophyll
variations than standard NDVI, especially in mid-to-high biomass stages
and dense crops.

## References

Gitelson, A. A., Kaufman, Y. J., & Merzlyak, M. N. (1996). Use of a
green channel in remote sensing of global vegetation from EOS-MODIS.
Remote Sensing of Environment, 58(3), 289-298.

## See also

[`calc_ndvi`](https://sowsalim01.github.io/GeoIndexR/reference/calc_ndvi.md),
[`geo_index`](https://sowsalim01.github.io/GeoIndexR/reference/geo_index.md)

## Examples

``` r
calc_gndvi(nir = 0.8, green = 0.2)
#> [1] 0.6
```
