# Resolve Bands in a SpatRaster Object

Matches required band roles (e.g., `"nir"`, `"red"`) against the layers
of a
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
using custom user mapping, sensor presets, or heuristic name aliases.
Optionally applies a scale factor (e.g. `10000`) to convert raw integer
Digital Numbers into physical reflectance `[0, 1]`.

## Usage

``` r
resolve_bands(
  image,
  required_bands,
  custom_mapping = NULL,
  sensor = NULL,
  index_name = "Index",
  scale_factor = NULL
)
```

## Arguments

- image:

  A
  [`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  object or file path.

- required_bands:

  Character vector of required standardized band names.

- custom_mapping:

  Optional named vector or list mapping required names to layer names or
  layer indices in `image`.

- sensor:

  Optional character string for sensor presets.

- index_name:

  Optional character string of the index being calculated (for error
  reporting).

- scale_factor:

  Optional numeric scaling divisor (e.g. `10000` for Sentinel-2 /
  Landsat L2A products).

## Value

A named list of single-layer
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
objects.
