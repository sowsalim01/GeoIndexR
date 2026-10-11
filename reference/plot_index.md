# Visualize a Spectral Index with Thematic Color Palettes

Plots a single-layer or selected layer from a
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
index object using tailored color palettes designed for vegetation,
water, soil, urban, and custom analysis.

## Usage

``` r
plot_index(x, index = NULL, main = NULL, col = NULL, ...)
```

## Arguments

- x:

  A
  [`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  object containing index values.

- index:

  Optional character string specifying which layer to plot if `x`
  contains multiple layers.

- main:

  Optional plot title. Defaults to the layer name.

- col:

  Optional color palette. If `NULL` (default), an appropriate palette is
  automatically chosen based on the index category or a perceptual
  palette for custom indices.

- ...:

  Additional graphical arguments passed to
  [`terra::plot`](https://rspatial.github.io/terra/reference/plot.html).

## Value

Invisible
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
object that was plotted.

## Examples

``` r
img <- get_example_data()
ndvi <- geo_index(img, "NDVI")
plot_index(ndvi)

```
