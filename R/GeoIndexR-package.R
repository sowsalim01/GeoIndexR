#' @title GeoIndexR: Computation of Spectral and Geospatial Indices from Multispectral Raster Data
#' @description A unified, fast, and extensible framework for calculating spectral and geospatial indices from multispectral raster datasets (e.g., NDVI - Normalized Difference Vegetation Index, NDWI - Normalized Difference Water Index, MNDWI - Modified Normalized Difference Water Index, NDBI - Normalized Difference Built-up Index, SAVI - Soil Adjusted Vegetation Index, EVI - Enhanced Vegetation Index, GNDVI - Green Normalized Difference Vegetation Index, NDMI - Normalized Difference Moisture Index, BSI - Bare Soil Index). Designed around 'terra' 'SpatRaster' objects, it supports multi-band rasters, automatic band resolution, sensor presets (Sentinel-2, Landsat-8/9), customizable index parameters, vectorized computations, and comprehensive validation. Methods based on Rouse et al. (1973), McFeeters (1996) \doi{10.1080/01431169608948714}, Xu (2006) \doi{10.1080/01431160600589179}, Zha et al. (2003) \doi{10.1016/S0034-4257(03)00087-7}, Huete (1988) \doi{10.1016/0034-4257(88)90106-X}, Gitelson et al. (1996) \doi{10.1016/S0034-4257(96)00072-7}, Wilson and Sader (2002) \doi{10.1016/S0034-4257(01)00318-2}, and Rikimaru et al. (2002).
#' @name GeoIndexR-package
#' @keywords internal
#' @import terra
#' @importFrom stats sd
#' @importFrom graphics par
"_PACKAGE"
NULL
