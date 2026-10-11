# Vegetation Indices in GeoIndexR

## Introduction

Vegetation indices exploit the distinct spectral reflectance curve of
healthy green canopies: strong absorption in the red chlorophyll band
(0.64 - 0.67 um) and high scattering/reflectance in the near-infrared
(NIR) plateau (0.85 - 0.88 um).

`GeoIndexR` provides four primary vegetation indices, each tailored to
different canopy densities and atmospheric or soil conditions:

1.  **NDVI**: Normalized Difference Vegetation Index
2.  **SAVI**: Soil Adjusted Vegetation Index
3.  **EVI**: Enhanced Vegetation Index
4.  **GNDVI**: Green Normalized Difference Vegetation Index

------------------------------------------------------------------------

## Formulations and Parameters

### 1. NDVI (Normalized Difference Vegetation Index)

Rouse et al. (1974) formulated the normalized ratio:

``` math
\text{NDVI} = \frac{\text{NIR} - \text{RED}}{\text{NIR} + \text{RED}}
```

- Theoretical range: $`[-1, 1]`$
- Values typically range from $`0.2`$ to $`0.8`$ for photosynthetically
  active green vegetation.

``` r

library(GeoIndexR)
img <- get_example_data()

ndvi <- geo_index(img, "NDVI")
index_summary(ndvi)
#> 
#> === GeoIndexR Spectral Summary ===
#> 
#>  index     min    max   mean median     sd     q05     q25    q75    q95 na_pct
#>   NDVI -0.5312 0.9227 0.2984 0.1108 0.4873 -0.3934 -0.0779 0.8676 0.8994      1
#>  total_cells
#>          100
```

------------------------------------------------------------------------

### 2. SAVI (Soil Adjusted Vegetation Index)

In areas with sparse or intermediate canopy cover ($`< 40\%`$), exposed
background soil alters the red and near-infrared reflectance. Huete
(1988) introduced the soil adjustment factor $`L`$:

``` math
\text{SAVI} = \frac{\text{NIR} - \text{RED}}{\text{NIR} + \text{RED} + L} \times (1 + L)
```

- $`L = 0.5`$ is standard and optimal for intermediate vegetation
  density.
- $`L \to 0`$ approaches NDVI (dense cover), whereas $`L = 1.0`$ is
  suitable for very sparse vegetation.

In `GeoIndexR`, $`L`$ is configurable directly through
[`geo_index()`](https://sowsalim01.github.io/GeoIndexR/reference/geo_index.md)
or
[`calc_savi()`](https://sowsalim01.github.io/GeoIndexR/reference/calc_savi.md):

``` r

savi_standard <- geo_index(img, "SAVI", L = 0.5)
savi_sparse   <- geo_index(img, "SAVI", L = 1.0)

index_summary(c(savi_standard, savi_sparse))
#> 
#> === GeoIndexR Spectral Summary ===
#> 
#>  index     min    max   mean median     sd     q05     q25    q75    q95 na_pct
#>   SAVI -0.0736 0.8633 0.3063 0.0676 0.3819 -0.0638 -0.0241 0.7355 0.8459      1
#>   SAVI -0.0677 0.8417 0.2918 0.0613 0.3617 -0.0520 -0.0185 0.6826 0.8261      1
#>  total_cells
#>          100
#>          100
```

------------------------------------------------------------------------

### 3. EVI (Enhanced Vegetation Index)

Liu & Huete (1995) designed EVI to decouple the canopy background signal
and reduce atmospheric influences through blue band feedback:

``` math
\text{EVI} = G \times \frac{\text{NIR} - \text{RED}}{\text{NIR} + C_1 \times \text{RED} - C_2 \times \text{BLUE} + L}
```

Default coefficients (standard MODIS/Sentinel-2/Landsat): - $`G = 2.5`$
(Gain factor) - $`C_1 = 6.0`$ (Aerosol coefficient for red) -
$`C_2 = 7.5`$ (Aerosol coefficient for blue) - $`L = 1.0`$ (Canopy
background adjustment)

``` r

evi <- geo_index(img, "EVI")
index_summary(evi)
#> 
#> === GeoIndexR Spectral Summary ===
#> 
#>  index     min    max   mean median     sd     q05     q25    q75    q95 na_pct
#>    EVI -0.1149 1.1388 0.3675 0.0735 0.4623 -0.0779 -0.0333 0.8732 1.0481      1
#>  total_cells
#>          100
```

------------------------------------------------------------------------

### 4. GNDVI (Green NDVI)

Gitelson et al. (1996) substituted the red band with the green band to
enhance sensitivity to chlorophyll concentrations in dense canopies
where red reflectance becomes saturated:

``` math
\text{GNDVI} = \frac{\text{NIR} - \text{GREEN}}{\text{NIR} + \text{GREEN}}
```

``` r

gndvi <- geo_index(img, "GNDVI")
index_summary(gndvi)
#> 
#> === GeoIndexR Spectral Summary ===
#> 
#>  index     min    max   mean median     sd     q05     q25    q75    q95 na_pct
#>  GNDVI -0.7659 0.8489 0.2182  0.231 0.5295 -0.5998 -0.3716 0.7401 0.8222      1
#>  total_cells
#>          100
```

------------------------------------------------------------------------

## Comparing Vegetation Indices

You can stack all four indices together:

``` r

veg_stack <- geo_indices(img, c("NDVI", "SAVI", "EVI", "GNDVI"))
index_summary(veg_stack)
#> 
#> === GeoIndexR Spectral Summary ===
#> 
#>  index     min    max   mean median     sd     q05     q25    q75    q95 na_pct
#>   NDVI -0.5312 0.9227 0.2984 0.1108 0.4873 -0.3934 -0.0779 0.8676 0.8994      1
#>   SAVI -0.0736 0.8633 0.3063 0.0676 0.3819 -0.0638 -0.0241 0.7355 0.8459      1
#>    EVI -0.1149 1.1388 0.3675 0.0735 0.4623 -0.0779 -0.0333 0.8732 1.0481      1
#>  GNDVI -0.7659 0.8489 0.2182 0.2310 0.5295 -0.5998 -0.3716 0.7401 0.8222      1
#>  total_cells
#>          100
#>          100
#>          100
#>          100
```
