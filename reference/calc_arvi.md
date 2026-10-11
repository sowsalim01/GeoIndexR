# Calculate Atmospherically Resistant Vegetation Index (ARVI)

Computes the Atmospherically Resistant Vegetation Index (ARVI), which
uses the difference between blue and red bands to reduce atmospheric
aerosol effects on red reflectance.

## Usage

``` r
calc_arvi(nir, red, blue, gamma = 1)
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

- blue:

  Blue band
  ([`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  or numeric).

- gamma:

  Aerosol resistance coefficient. Defaults to `1.0`.

## Value

A
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
(named `"ARVI"`) or numeric vector with index values.

## Details

\$\$ARVI = \frac{NIR - RB}{NIR + RB}\$\$ where \\RB = RED - \gamma
\times (BLUE - RED)\\.

## References

Kaufman, Y. J., & Tanre, D. (1992). Atmospherically resistant vegetation
index (ARVI) for EOS-MODIS. IEEE TGRS, 30(2), 261-270.

## See also

[`calc_ndvi`](https://sowsalim01.github.io/GeoIndexR/reference/calc_ndvi.md),
[`calc_evi`](https://sowsalim01.github.io/GeoIndexR/reference/calc_evi.md),
[`geo_index`](https://sowsalim01.github.io/GeoIndexR/reference/geo_index.md)

## Examples

``` r
calc_arvi(nir = 0.7, red = 0.2, blue = 0.1)
#> [1] 0.4
```
