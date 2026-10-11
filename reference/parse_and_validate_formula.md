# Extract Symbols and Validate Formula AST

Recursively traverses the parsed formula AST to verify that only
permitted mathematical operators, whitelisted mathematical functions,
known spectral bands, and user-supplied parameters are present.

## Usage

``` r
parse_and_validate_formula(
  formula_str,
  available_bands = character(0),
  param_names = character(0)
)
```

## Arguments

- formula_str:

  Character string containing the mathematical formula.

- available_bands:

  Character vector of valid spectral band identifiers.

- param_names:

  Character vector of valid parameter names.

## Value

A list containing:

- parsed_expr:

  The parsed R expression object.

- used_bands:

  Character vector of band names referenced in the formula.

- used_params:

  Character vector of parameter names referenced in the formula.
