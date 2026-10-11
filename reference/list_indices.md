# List Supported Spectral Index Codes

List Supported Spectral Index Codes

## Usage

``` r
list_indices(category = NULL)
```

## Arguments

- category:

  Optional character string to filter by category.

## Value

A character vector of index codes.

## Examples

``` r
list_indices()
#>  [1] "NDVI"  "SAVI"  "EVI"   "MSAVI" "OSAVI" "ARVI"  "GNDVI" "NDWI"  "MNDWI"
#> [10] "AWEI"  "NDBI"  "IBI"   "NDMI"  "MSI"   "BSI"   "NDSI" 
list_indices("vegetation")
#> [1] "NDVI"  "SAVI"  "EVI"   "MSAVI" "OSAVI" "ARVI"  "GNDVI"
```
