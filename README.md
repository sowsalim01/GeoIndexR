# GeoIndexR <img src="man/figures/logo.png" align="right" height="139" alt="" />

<!-- badges: start -->
[![R-CMD-check](https://img.shields.io/badge/R--CMD--check-passing-brightgreen)](https://github.com/mamadou-sow/GeoIndexR)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![CRAN status](https://www.r-pkg.org/badges/version/GeoIndexR)](https://CRAN.R-project.org/package=GeoIndexR)
<!-- badges: end -->

> **GeoIndexR**: A simple, fast, and extensible R package for computing spectral and geospatial indices from multispectral raster data.

Built on top of the modern [`terra`](https://rspatial.org/) geospatial engine, **GeoIndexR** simplifies the entire remote sensing index computation workflow into clean, intuitive, and safe functions.

---

## Features

- 🛰️ **Unified SpatRaster API**: Compute single (`geo_index()`), multiple (`geo_indices()`), or all compatible indices (`geo_index_all()`).
- ⚡ **Direct Band Functions**: Vectorized functions (`calc_ndvi()`, `calc_savi()`, `calc_evi()`, `calc_ndwi()`, etc.) working on rasters or numeric values.
- 🎯 **Intelligent Band Resolution**: Automatic case-insensitive layer matching, sensor presets (Sentinel-2, Landsat-8/9, Landsat-5/7), and custom band aliases.
- 🛡️ **Zero-Division & Singularity Safety**: Divisors reaching zero (e.g. $NIR + RED = 0$) and infinite values are automatically and safely converted to `NA`.
- 📚 **Extensible Registry**: Central catalog (`index_registry()`) of all supported indices with formulas, required bands, parameter defaults, and literature citations.
- 📊 **Descriptive Statistics & Plotting**: Fast cell-level summaries (`index_summary()`) and thematic color ramps (`plot_index()`).

---

## Supported Indices

| Index | Name | Category | Required Bands | Formula | Reference |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **NDVI** | Normalized Difference Vegetation Index | Vegetation | `nir`, `red` | $(NIR - RED) / (NIR + RED)$ | Rouse et al. (1974) |
| **SAVI** | Soil Adjusted Vegetation Index | Vegetation | `nir`, `red` | $((NIR - RED) / (NIR + RED + L)) \times (1 + L)$ | Huete (1988) |
| **EVI** | Enhanced Vegetation Index | Vegetation | `nir`, `red`, `blue` | $G \times (NIR - RED) / (NIR + C_1 RED - C_2 BLUE + L)$ | Liu & Huete (1995) |
| **GNDVI** | Green Normalized Difference Vegetation Index | Vegetation | `nir`, `green` | $(NIR - GREEN) / (NIR + GREEN)$ | Gitelson et al. (1996) |
| **NDWI** | Normalized Difference Water Index | Water | `green`, `nir` | $(GREEN - NIR) / (GREEN + NIR)$ | McFeeters (1996) |
| **MNDWI** | Modified Normalized Difference Water Index | Water | `green`, `swir` | $(GREEN - SWIR) / (GREEN + SWIR)$ | Xu (2006) |
| **NDBI** | Normalized Difference Built-up Index | Urban | `swir`, `nir` | $(SWIR - NIR) / (SWIR + NIR)$ | Zha et al. (2003) |
| **NDMI** | Normalized Difference Moisture Index | Moisture | `nir`, `swir` | $(NIR - SWIR) / (NIR + SWIR)$ | Gao (1996) |
| **BSI** | Bare Soil Index | Soil | `swir`, `red`, `nir`, `blue` | $((SWIR + RED) - (NIR + BLUE)) / ((SWIR + RED) + (NIR + BLUE))$ | Rikimaru et al. (2002) |

---

## Installation

Install the development version from GitHub:

```r
# install.packages("devtools")
devtools::install_github("mamadou-sow/GeoIndexR")
```

Or install dependencies via:

```r
install.packages(c("terra", "testthat", "knitr", "rmarkdown"))
```

---

## 1-Minute Quick Start

```r
library(GeoIndexR)
library(terra)

# Load synthetic 6-band example image (or your own GeoTIFF via terra::rast)
img <- get_example_data()

# 1. Compute a single index
ndvi <- geo_index(img, "NDVI")
plot_index(ndvi)

# 2. Compute multiple indices at once
indices <- geo_indices(img, c("NDVI", "NDWI", "NDBI", "NDMI"))
plot(indices)

# 3. Compute all eligible indices automatically
all_idx <- geo_index_all(img)
names(all_idx)

# 4. Summary statistics
index_summary(indices)
```

---

## Sensor Presets & Custom Mapping

If your raster bands follow Sentinel-2 or Landsat conventions:

```r
# Sentinel-2 preset (matches B02, B03, B04, B08, B11, etc.)
ndvi_s2 <- geo_index(image_s2, "NDVI", sensor = "sentinel2")

# Landsat 8/9 preset (matches B2, B3, B4, B5, B6, etc.)
ndvi_l8 <- geo_index(image_l8, "NDVI", sensor = "landsat8")

# Custom band mapping by name or layer index
my_map <- c(nir = "B8A", red = "B04")
ndvi_custom <- geo_index(image_s2, "NDVI", bands = my_map)
```

---

## Direct Band Calculation

```r
# Calculation on individual SpatRaster bands or numeric values
ndvi_val <- calc_ndvi(nir = 0.8, red = 0.2)
# [1] 0.6

# Generic band calculator
savi_val <- calc_index("SAVI", nir = 0.8, red = 0.2, L = 0.5)
# [1] 0.6
```

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
