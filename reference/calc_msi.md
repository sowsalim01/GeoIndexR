# Calculate Moisture Stress Index (MSI)

Computes the Moisture Stress Index (MSI) from SWIR1 and NIR bands.

## Usage

``` r
calc_msi(swir1, nir)
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

## Value

A
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
(named `"MSI"`) or numeric vector with index values.

## Details

\$\$MSI = \frac{SWIR1}{NIR}\$\$

## References

Rock, B. N., Vogelmann, J. E., Williams, D. L., & Vogelmann, A. F.
(1986). Remote detection of forest damage. BioScience, 36(7), 439-445.

## See also

[`calc_ndmi`](https://sowsalim01.github.io/GeoIndexR/reference/calc_ndmi.md),
[`geo_index`](https://sowsalim01.github.io/GeoIndexR/reference/geo_index.md)

## Examples

``` r
calc_msi(swir1 = 0.4, nir = 0.8)
#> [1] 0.5
```
