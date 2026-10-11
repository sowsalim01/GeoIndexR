# Summary Statistics for Spectral Indices

Computes descriptive statistics for one or multiple spectral index
layers in a
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
object, including min, max, mean, median, standard deviation,
percentiles (5th, 25th, 75th, 95th), and NA percentage.

## Usage

``` r
index_summary(x, digits = 4)
```

## Arguments

- x:

  A
  [`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  object containing one or more index layers.

- digits:

  Integer indicating the number of decimal places to round results.
  Defaults to `4`.

## Value

A `data.frame` of class `"geo_index_summary"` with one row per layer:

- index:

  Layer/index name.

- min:

  Minimum index value.

- max:

  Maximum index value.

- mean:

  Mean index value.

- median:

  Median index value.

- sd:

  Standard deviation.

- q05:

  5th percentile.

- q25:

  25th percentile (1st quartile).

- q75:

  75th percentile (3rd quartile).

- q95:

  95th percentile.

- na_pct:

  Percentage of NA values (0 to 100).

- total_cells:

  Total number of raster cells.

## Examples

``` r
img <- get_example_data()
ndvi <- geo_index(img, "NDVI")
index_summary(ndvi)
#> 
#> === GeoIndexR Spectral Summary ===
#> 
#>  index     min    max   mean median     sd     q05     q25    q75    q95 na_pct
#>   NDVI -0.5728 0.9273 0.2891 0.1123 0.4977 -0.3586 -0.1239 0.8615 0.9012      1
#>  total_cells
#>          100
#> 

# Multi-layer summary
stack <- geo_indices(img, c("NDVI", "NDWI", "NDBI"))
index_summary(stack)
#> 
#> === GeoIndexR Spectral Summary ===
#> 
#>  index     min    max    mean  median     sd     q05     q25    q75    q95
#>   NDVI -0.5728 0.9273  0.2891  0.1123 0.4977 -0.3586 -0.1239 0.8615 0.9012
#>   NDWI -0.8470 0.7118 -0.2047 -0.2720 0.5286 -0.8046 -0.7126 0.3972 0.6362
#>   NDBI -0.6804 0.3583 -0.2524 -0.3890 0.3282 -0.6202 -0.5536 0.1273 0.2481
#>  na_pct total_cells
#>       1         100
#>       1         100
#>       1         100
#> 
```
