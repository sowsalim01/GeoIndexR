# Compute Multiple Spectral Indices from Multispectral Raster Data

Computes a collection of spectral indices from a multispectral
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
or raster file path and returns the results stacked into a multi-layer
`SpatRaster`.

## Usage

``` r
geo_indices(
  image,
  indices,
  bands = NULL,
  scale_factor = NULL,
  sensor = NULL,
  ...
)
```

## Arguments

- image:

  A
  [`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  object or file path containing multispectral bands.

- indices:

  Character vector of index codes to compute (e.g.,
  `c("NDVI", "NDWI", "NDBI", "NDMI")`).

- bands:

  Optional named vector or list specifying custom band mapping.

- scale_factor:

  Optional numeric scaling divisor (e.g. `10000`).

- sensor:

  Optional character string specifying a sensor preset.

- ...:

  Additional parameters passed to index calculation functions.

## Value

A multi-layer
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
where each layer corresponds to one computed index, named accordingly.

## Examples

``` r
img <- get_example_data()

# Compute NDVI, NDWI and MNDWI simultaneously
stack <- geo_indices(img, c("NDVI", "NDWI", "MNDWI"))
print(stack)
#> class       : SpatRaster
#> size        : 10, 10, 3  (nrow, ncol, nlyr)
#> resolution  : 10, 10  (x, y)
#> extent      : 440000, 440100, 5410000, 5410100  (xmin, xmax, ymin, ymax)
#> coord. ref. : WGS 84 / UTM zone 31N (EPSG:32631)
#> source(s)   : memory
#> names       :      NDVI,      NDWI,     MNDWI
#> min values  : -0.538017, -0.842173, -0.579636
#> max values  :  0.925664,  0.754199,  0.866783
names(stack)
#> [1] "NDVI"  "NDWI"  "MNDWI"
```
