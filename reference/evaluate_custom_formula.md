# Safely Evaluate Formula on Bands and Parameters

Evaluates a validated AST expression in a controlled, isolated
environment containing only the raster/numeric bands, supplied
parameters, and safe mathematical operators.

## Usage

``` r
evaluate_custom_formula(
  parsed_expr,
  band_layers,
  params = list(),
  denominator_tolerance = 1e-06
)
```

## Arguments

- parsed_expr:

  Parsed language expression.

- band_layers:

  Named list of `SpatRaster` or numeric band values.

- params:

  Named list of numeric parameter constants.

- denominator_tolerance:

  Tolerance for near-zero denominators. Defaults to `1e-6`.

## Value

A `SpatRaster` or numeric result.
