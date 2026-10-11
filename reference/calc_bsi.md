# Calculate Bare Soil Index (BSI)

Computes the Bare Soil Index (BSI), combining blue, red, NIR, and SWIR
bands to distinguish bare soils from vegetation and impervious land.

## Usage

``` r
calc_bsi(swir1, red, nir, blue)
```

## Arguments

- swir1:

  Short-wave infrared 1 band
  ([`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  or numeric).

- red:

  Red band
  ([`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  or numeric).

- nir:

  Near-infrared band
  ([`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  or numeric).

- blue:

  Blue band
  ([`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  or numeric).

## Value

A
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
(named `"BSI"`) or numeric vector with index values.

## Details

\$\$BSI = \frac{(SWIR1 + RED) - (NIR + BLUE)}{(SWIR1 + RED) + (NIR +
BLUE)}\$\$

## References

Rikimaru, A., Roy, P. S., & Miyatake, S. (2002). Tropical forest cover
density mapping. Tropical Ecology, 43(1), 39-47.

## See also

[`geo_index`](https://sowsalim01.github.io/GeoIndexR/reference/geo_index.md)

## Examples

``` r
calc_bsi(swir1 = 0.5, red = 0.4, nir = 0.2, blue = 0.1)
#> [1] 0.5
```
