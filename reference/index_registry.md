# Central Registry of Spectral and Geospatial Indices

Retrieves metadata for all built-in spectral indices or a specific index
by name or category. Metadata includes mathematical formulas, required
spectral bands, parameter defaults, purpose, interpretation guidelines,
limitations, scale sensitivity, and scientific literature references.

## Usage

``` r
index_registry(category = NULL)
```

## Arguments

- category:

  Optional character string to filter indices by category (e.g.,
  `"vegetation"`, `"water"`, `"urban"`, `"soil"`, `"moisture"`,
  `"snow"`).

## Value

A `data.frame` containing the registry of supported indices and their
metadata.

## Examples

``` r
# View all indices
reg <- index_registry()
reg[, c("index", "name", "category")]
#>    index                                         name   category
#> 1   NDVI       Normalized Difference Vegetation Index vegetation
#> 2   SAVI               Soil Adjusted Vegetation Index vegetation
#> 3    EVI                    Enhanced Vegetation Index vegetation
#> 4  MSAVI    Modified Soil Adjusted Vegetation Index 2 vegetation
#> 5  OSAVI     Optimized Soil-Adjusted Vegetation Index vegetation
#> 6   ARVI   Atmospherically Resistant Vegetation Index vegetation
#> 7  GNDVI Green Normalized Difference Vegetation Index vegetation
#> 8   NDWI            Normalized Difference Water Index      water
#> 9  MNDWI   Modified Normalized Difference Water Index      water
#> 10  AWEI             Automated Water Extraction Index      water
#> 11  NDBI         Normalized Difference Built-up Index      urban
#> 12   IBI                   Index-Based Built-Up Index      urban
#> 13  NDMI         Normalized Difference Moisture Index   moisture
#> 14   MSI                        Moisture Stress Index   moisture
#> 15   BSI                              Bare Soil Index       soil
#> 16  NDSI             Normalized Difference Snow Index       snow

# View vegetation indices only
veg_reg <- index_registry(category = "vegetation")
veg_reg$index
#> [1] "NDVI"  "SAVI"  "EVI"   "MSAVI" "OSAVI" "ARVI"  "GNDVI"
```
