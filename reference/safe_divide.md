# Safe Division Function Handling Zeros, Singularity, and Non-Finite Values

Performs division with protection against division by zero, near-zero
denominator singularities (\$\|den\| \< tol\$), and non-finite values
(`Inf`, `-Inf`, `NaN`), replacing invalid results with `NA`.

## Usage

``` r
safe_divide(num, den, tol = 1e-06)
```

## Arguments

- num:

  Numerator (`SpatRaster` or numeric).

- den:

  Denominator (`SpatRaster` or numeric).

- tol:

  Singularity tolerance threshold. Values with \$\|den\| \< tol\$ are
  safely converted to `NA`. Defaults to `1e-6`.

## Value

An object of the same class as inputs with values safely bounded and
non-finite values replaced by `NA`.
