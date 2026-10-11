# Dispatch and Calculate a Named Index

Dynamically invokes the calculation function for any registered index by
name.

## Usage

``` r
calc_index(index, ...)
```

## Arguments

- index:

  Character string specifying index name (e.g., `"NDVI"`, `"SAVI"`).

- ...:

  Named band arguments (e.g., `nir = ..., red = ...`) and optional index
  parameters (such as `L = 0.5`).

## Value

A `SpatRaster` or numeric vector.

## Examples

``` r
calc_index("NDVI", nir = 0.8, red = 0.2)
#> [1] 0.6
calc_index("SAVI", nir = 0.8, red = 0.2, L = 0.5)
#> [1] 0.6
```
