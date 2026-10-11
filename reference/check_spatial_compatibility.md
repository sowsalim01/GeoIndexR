# Check Spatial Compatibility Across Raster Bands

Validates that a list of
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
objects share identical geometry, CRS, and dimensions before computing
pixel-wise operations.

## Usage

``` r
check_spatial_compatibility(band_list)
```

## Arguments

- band_list:

  Named list of `SpatRaster` or numeric objects.

## Value

Invisible `TRUE` if all raster inputs are compatible.
