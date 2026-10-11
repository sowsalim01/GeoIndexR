# Validate Raster Input or Filepath

Verifies that the provided input is either a valid
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
object or a valid file path pointing to an existing raster file on disk.
If a file path is provided, it is automatically loaded as a
`SpatRaster`.

## Usage

``` r
validate_raster_input(x, arg_name = "image")
```

## Arguments

- x:

  An object or file path to check.

- arg_name:

  Character string specifying the argument name for error messages.

## Value

A
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
object.
