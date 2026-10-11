# Water and Moisture Indices in GeoIndexR

## Overview

Delineating water bodies and tracking moisture conditions are
foundational tasks in hydrology, wetland monitoring, and irrigation
management. `GeoIndexR` implements three key indices:

1.  **NDWI** (Normalized Difference Water Index, McFeeters 1996)
2.  **MNDWI** (Modified Normalized Difference Water Index, Xu 2006)
3.  **NDMI** (Normalized Difference Moisture Index, Gao 1996)

------------------------------------------------------------------------

## 1. NDWI (McFeeters, 1996)

McFeeters designed NDWI to delineate open water features by maximizing
green band reflectance and minimizing NIR reflectance:

``` math
\text{NDWI} = \frac{\text{GREEN} - \text{NIR}}{\text{GREEN} + \text{NIR}}
```

Water bodies typically have positive NDWI values ($`\text{NDWI} > 0`$),
while terrestrial vegetation and dry soil display negative values.

``` r

library(GeoIndexR)
img <- get_example_data()

ndwi <- geo_index(img, "NDWI")
index_summary(ndwi)
#> 
#> === GeoIndexR Spectral Summary ===
#> 
#>  index     min    max    mean median     sd     q05     q25    q75    q95
#>   NDWI -0.8489 0.7659 -0.2182 -0.231 0.5295 -0.8222 -0.7401 0.3716 0.5998
#>  na_pct total_cells
#>       1         100
```

------------------------------------------------------------------------

## 2. MNDWI (Xu, 2006)

In urbanized and complex landscapes, built-up surfaces often produce
false positive signals under classical NDWI. Xu (2006) replaced the NIR
band with the Shortwave Infrared (SWIR) band:

``` math
\text{MNDWI} = \frac{\text{GREEN} - \text{SWIR}}{\text{GREEN} + \text{SWIR}}
```

Because built-up areas reflect strongly in SWIR, their MNDWI values are
negative, clearly separating urban structures from open water.

``` r

mndwi <- geo_index(img, "MNDWI")
index_summary(mndwi)
#> 
#> === GeoIndexR Spectral Summary ===
#> 
#>  index     min    max    mean  median     sd    q05     q25    q75    q95
#>  MNDWI -0.5512 0.8414 -0.0692 -0.3565 0.5143 -0.503 -0.4426 0.5909 0.8118
#>  na_pct total_cells
#>       1         100
```

------------------------------------------------------------------------

## 3. NDMI (Gao, 1996)

The Normalized Difference Moisture Index monitors vegetation liquid
water content:

``` math
\text{NDMI} = \frac{\text{NIR} - \text{SWIR}}{\text{NIR} + \text{SWIR}}
```

Higher values indicate well-hydrated vegetation canopies, whereas low or
negative values signal drought or water stress.

``` r

ndmi <- geo_index(img, "NDMI")
index_summary(ndmi)
#> 
#> === GeoIndexR Spectral Summary ===
#> 
#>  index     min    max   mean median     sd     q05     q25    q75    q95 na_pct
#>   NDMI -0.3558 0.6853 0.2397  0.341 0.3298 -0.2609 -0.1321 0.5173 0.6174      1
#>  total_cells
#>          100
```

------------------------------------------------------------------------

## Multi-Index Stack & Comparison

We can compute and compare water and moisture indices together:

``` r

water_stack <- geo_indices(img, c("NDWI", "MNDWI", "NDMI"))
index_summary(water_stack)
#> 
#> === GeoIndexR Spectral Summary ===
#> 
#>  index     min    max    mean  median     sd     q05     q25    q75    q95
#>   NDWI -0.8489 0.7659 -0.2182 -0.2310 0.5295 -0.8222 -0.7401 0.3716 0.5998
#>  MNDWI -0.5512 0.8414 -0.0692 -0.3565 0.5143 -0.5030 -0.4426 0.5909 0.8118
#>   NDMI -0.3558 0.6853  0.2397  0.3410 0.3298 -0.2609 -0.1321 0.5173 0.6174
#>  na_pct total_cells
#>       1         100
#>       1         100
#>       1         100
```
