# GeoIndexR <img src="man/figures/logo.png" align="right" height="139" alt="" />

<!-- badges: start -->
[![R-CMD-check](https://img.shields.io/badge/R--CMD--check-passing-brightgreen)](https://github.com/sowsalim01/GeoIndexR)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![CRAN status](https://www.r-pkg.org/badges/version/GeoIndexR)](https://CRAN.R-project.org/package=GeoIndexR)
<!-- badges: end -->

> **GeoIndexR**: A flexible, fast, and extensible R framework for computing spectral and geospatial indices from raster data, combining ready-to-use standard indices with a secure custom formula engine.

Built natively on [`terra`](https://rspatial.org/), **GeoIndexR** enables researchers, remote sensing scientists, and GIS professionals to calculate standard indices or define their own custom formulas seamlessly.

---

## Key Features

- 🛰️ **Unified SpatRaster & File Path API**: Pass `terra::SpatRaster` objects or direct file paths (`"image.tif"`).
- 🧩 **Custom Formula Engine (`geo_index_custom()`)**: Define arbitrary mathematical expressions (`"(nir - red) / (nir + red)"`) with custom parameters and secure AST execution.
- 🎯 **Intelligent Band Resolution**: Map bands by index (`c(red = 3, nir = 4)`), layer name (`c(red = "B4", nir = "B8")`), or sensor preset (`sentinel2`, `landsat8`, `landsat9`).
- ⚖️ **Reflectance & Scale Factor Management**: Built-in support for `scale_factor = 10000` to convert integer Digital Numbers (DN) into physical surface reflectance $[0, 1]$.
- 🛡️ **Zero-Division & Singularity Safety**: Automatic near-zero denominator tolerance and conversion of non-finite values to `NA` without arbitrary clamping.
- 📚 **Rich Metadata Registry (`index_registry()`)**: Comprehensive catalog of indices with descriptions, purposes, interpretations, limitations, and literature citations.
- 📊 **Descriptive Statistics & Plotting**: Detailed summaries with percentiles (`index_summary()`) and thematic color ramps (`plot_index()`).

---

## Supported Standard Indices

| Index | Category | Required Bands | Formula | Reference |
| :--- | :--- | :--- | :--- | :--- |
| **NDVI** | Vegetation | `nir`, `red` | $(NIR - RED) / (NIR + RED)$ | Rouse et al. (1974) |
| **SAVI** | Vegetation | `nir`, `red` | $((NIR - RED) / (NIR + RED + L)) \times (1 + L)$ | Huete (1988) |
| **EVI** | Vegetation | `nir`, `red`, `blue` | $G \times (NIR - RED) / (NIR + C_1 RED - C_2 BLUE + L)$ | Liu & Huete (1995) |
| **MSAVI** | Vegetation | `nir`, `red` | $(2 NIR + 1 - \sqrt{(2 NIR + 1)^2 - 8(NIR - RED)}) / 2$ | Qi et al. (1994) |
| **OSAVI** | Vegetation | `nir`, `red` | $((NIR - RED) / (NIR + RED + \theta)) \times (1 + \theta)$ | Rondeaux et al. (1996) |
| **ARVI** | Vegetation | `nir`, `red`, `blue` | $(NIR - RB) / (NIR + RB)$ | Kaufman & Tanre (1992) |
| **GNDVI** | Vegetation | `nir`, `green` | $(NIR - GREEN) / (NIR + GREEN)$ | Gitelson et al. (1996) |
| **NDWI** | Water | `green`, `nir` | $(GREEN - NIR) / (GREEN + NIR)$ | McFeeters (1996) |
| **MNDWI** | Water | `green`, `swir1` | $(GREEN - SWIR1) / (GREEN + SWIR1)$ | Xu (2006) |
| **AWEI** | Water | `green`, `nir`, `swir1`, `swir2` | $4(GREEN - SWIR1) - (0.25 NIR + 2.75 SWIR2)$ | Feyisa et al. (2014) |
| **NDBI** | Urban | `swir1`, `nir` | $(SWIR1 - NIR) / (SWIR1 + NIR)$ | Zha et al. (2003) |
| **IBI** | Urban | `swir1`, `nir`, `red`, `green` | $(NDBI - (SAVI + MNDWI)/2) / (NDBI + (SAVI + MNDWI)/2)$ | Xu (2007) |
| **NDMI** | Moisture | `nir`, `swir1` | $(NIR - SWIR1) / (NIR + SWIR1)$ | Gao (1996) |
| **MSI** | Moisture | `swir1`, `nir` | $SWIR1 / NIR$ | Rock et al. (1986) |
| **BSI** | Soil | `swir1`, `red`, `nir`, `blue` | $((SWIR1 + RED) - (NIR + BLUE)) / ((SWIR1 + RED) + (NIR + BLUE))$ | Rikimaru et al. (2002) |
| **NDSI** | Snow | `green`, `swir1` | $(GREEN - SWIR1) / (GREEN + SWIR1)$ | Hall et al. (1995) |

---

## Installation

Install the latest version from GitHub:

```r
# install.packages("devtools")
devtools::install_github("sowsalim01/GeoIndexR")
```

---

## Quick Start

```r
library(GeoIndexR)
library(terra)

# 1. Load raster image (or provide filepath: "image.tif")
img <- get_example_data()

# 2. Compute a standard index
ndvi <- geo_index(img, "NDVI", bands = c(red = "red", nir = "nir"))

# 3. Compute a scale-sensitive index with scale_factor (e.g. for Sentinel-2 DN)
evi <- geo_index(
  img,
  "EVI",
  bands = c(blue = "blue", red = "red", nir = "nir"),
  scale_factor = 1 # or 10000 for raw integer DN
)

# 4. Compute a custom user formula
custom <- geo_index_custom(
  img,
  formula = "(nir - swir1) / (nir + swir1)",
  bands = c(nir = "nir", swir1 = "swir1"),
  name = "CustomMoistureIndex"
)

# 5. Summarize statistics with percentiles
index_summary(ndvi)

# 6. Plot the index
plot_index(ndvi, "NDVI")

# 7. Save output to GeoTIFF
writeRaster(ndvi, "NDVI_result.tif", overwrite = TRUE)
```

---

## License

MIT © Mamadou Sow
