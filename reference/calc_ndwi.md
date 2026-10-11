# Calculate Normalized Difference Water Index (NDWI)

Computes McFeeters' Normalized Difference Water Index (NDWI) for
delineating open water bodies.

## Usage

``` r
calc_ndwi(green, nir)
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

## Value

A
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
(named `"NDWI"`) or numeric vector with index values.

## Details

\$\$NDWI = \frac{GREEN - NIR}{GREEN + NIR}\$\$

**Description & Purpose**: NDWI maximizes the reflectance of water in
the green wavelength while minimizing the low reflectance of water in
the NIR wavelength.

**Interpretation**:

- **\> 0.0**: Water surfaces (rivers, lakes, wetlands, reservoirs).

- **\<= 0.0**: Non-water surfaces (vegetation, soil, built-up areas).

## References

McFeeters, S. K. (1996). The use of the Normalized Difference Water
Index (NDWI) in the delineation of open water features. International
Journal of Remote Sensing, 17(7), 1425-1432.

## See also

[`calc_mndwi`](https://sowsalim01.github.io/GeoIndexR/reference/calc_mndwi.md),
[`calc_awei`](https://sowsalim01.github.io/GeoIndexR/reference/calc_awei.md),
[`geo_index`](https://sowsalim01.github.io/GeoIndexR/reference/geo_index.md)

## Examples

``` r
calc_ndwi(green = 0.6, nir = 0.2)
#> [1] 0.5

img <- get_example_data()
ndwi_rast <- calc_ndwi(green = img[["green"]], nir = img[["nir"]])
print(ndwi_rast)
#> class       : SpatRaster
#> size        : 10, 10, 1  (nrow, ncol, nlyr)
#> resolution  : 10, 10  (x, y)
#> extent      : 440000, 440100, 5410000, 5410100  (xmin, xmax, ymin, ymax)
#> coord. ref. : WGS 84 / UTM zone 31N (EPSG:32631)
#> source(s)   : memory
#> name        :      NDWI
#> min value   : -0.866642
#> max value   :  0.744892
```
