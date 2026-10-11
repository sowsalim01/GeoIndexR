# Calculate Modified Soil Adjusted Vegetation Index 2 (MSAVI)

Computes the Modified Soil Adjusted Vegetation Index 2 (MSAVI2), which
eliminates the need for manually finding or specifying a soil adjustment
factor `L`.

## Usage

``` r
calc_msavi(nir, red)
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

## Value

A
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
(named `"MSAVI"`) or numeric vector with index values.

## Details

\$\$MSAVI = \frac{2 \times NIR + 1 - \sqrt{(2 \times NIR + 1)^2 - 8
\times (NIR - RED)}}{2}\$\$

**Description & Purpose**: MSAVI simplifies SAVI by calculating an
inductive soil adjustment factor mathematically, providing high
sensitivity in sparse vegetation without requiring empirical soil line
parameters.

## References

Qi, J., Chehbouni, A., Huete, A. R., Kerr, Y. H., & Sorooshian, S.
(1994). A modified soil adjusted vegetation index. Remote Sensing of
Environment, 48(2), 119-126.

## See also

[`calc_savi`](https://sowsalim01.github.io/GeoIndexR/reference/calc_savi.md),
[`calc_osavi`](https://sowsalim01.github.io/GeoIndexR/reference/calc_osavi.md),
[`geo_index`](https://sowsalim01.github.io/GeoIndexR/reference/geo_index.md)

## Examples

``` r
# Numeric scalar calculation
calc_msavi(nir = 0.7, red = 0.2)
#> [1] 0.536675

# Raster layer calculation
img <- get_example_data()
msavi_rast <- calc_msavi(nir = img[["nir"]], red = img[["red"]])
print(msavi_rast)
#> class       : SpatRaster
#> size        : 10, 10, 1  (nrow, ncol, nlyr)
#> resolution  : 10, 10  (x, y)
#> extent      : 440000, 440100, 5410000, 5410100  (xmin, xmax, ymin, ymax)
#> coord. ref. : WGS 84 / UTM zone 31N (EPSG:32631)
#> source(s)   : memory
#> name        :     MSAVI
#> min value   : -0.091755
#> max value   :  0.914637
```
