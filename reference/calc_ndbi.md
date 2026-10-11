# Calculate Normalized Difference Built-up Index (NDBI)

Computes the Normalized Difference Built-up Index (NDBI) for mapping
urban and impervious surfaces.

## Usage

``` r
calc_ndbi(swir1, nir)
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
(named `"NDBI"`) or numeric vector with index values.

## Details

\$\$NDBI = \frac{SWIR1 - NIR}{SWIR1 + NIR}\$\$

## References

Zha, Y., Gao, J., & Ni, S. (2003). Use of normalized difference built-up
index in automatically mapping urban areas from TM imagery. IJRS, 24(3),
583-594.

## See also

[`calc_ibi`](https://sowsalim01.github.io/GeoIndexR/reference/calc_ibi.md),
[`geo_index`](https://sowsalim01.github.io/GeoIndexR/reference/geo_index.md)

## Examples

``` r
calc_ndbi(swir1 = 0.6, nir = 0.3)
#> [1] 0.3333333
```
