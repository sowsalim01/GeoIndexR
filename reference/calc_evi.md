# Calculate Enhanced Vegetation Index (EVI)

Computes the Enhanced Vegetation Index (EVI), optimizing the vegetation
signal with improved sensitivity in high biomass regions and reduced
atmospheric aerosol influences.

## Usage

``` r
calc_evi(nir, red, blue, G = 2.5, C1 = 6, C2 = 7.5, L = 1)
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

- G:

  Gain factor. Defaults to `2.5`.

- C1:

  Atmospheric resistance coefficient for red. Defaults to `6.0`.

- C2:

  Atmospheric resistance coefficient for blue. Defaults to `7.5`.

- L:

  Canopy background adjustment. Defaults to `1.0`.

## Value

A
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
(named `"EVI"`) or numeric vector with index values.

## Details

\$\$EVI = G \times \frac{NIR - RED}{NIR + C1 \times RED - C2 \times
BLUE + L}\$\$

**Description & Purpose**: EVI was developed to enhance the vegetation
signal in dense canopies where NDVI saturates, while reducing canopy
background noise and aerosol scattering using the blue band.

**Important - Reflectance Scale**: EVI constants (`G = 2.5`, `C1 = 6.0`,
`C2 = 7.5`, `L = 1.0`) were calibrated for physical surface reflectance
in `[0, 1]`. If your input data are stored in raw integer Digital
Numbers (e.g., Sentinel-2 L2A `[0, 10000]`), divide the inputs by
`10000` or use `geo_index(..., scale_factor = 10000)`.

## References

Liu, H. Q., & Huete, A. (1995). A feedback based modification of the
NDVI to minimize canopy background and atmospheric noise. IEEE TGRS,
33(2), 457-465.

## See also

[`geo_index`](https://sowsalim01.github.io/GeoIndexR/reference/geo_index.md),
[`calc_ndvi`](https://sowsalim01.github.io/GeoIndexR/reference/calc_ndvi.md),
[`calc_savi`](https://sowsalim01.github.io/GeoIndexR/reference/calc_savi.md)

## Examples

``` r
# Numeric example with surface reflectance values in [0, 1]
calc_evi(nir = 0.50, red = 0.20, blue = 0.10)
#> [1] 0.3846154

# Raster example
img <- get_example_data()
evi_rast <- calc_evi(nir = img[["nir"]], red = img[["red"]], blue = img[["blue"]])
print(evi_rast)
#> class       : SpatRaster
#> size        : 10, 10, 1  (nrow, ncol, nlyr)
#> resolution  : 10, 10  (x, y)
#> extent      : 440000, 440100, 5410000, 5410100  (xmin, xmax, ymin, ymax)
#> coord. ref. : WGS 84 / UTM zone 31N (EPSG:32631)
#> source(s)   : memory
#> name        :       EVI
#> min value   : -0.114944
#> max value   :  1.138812
```
