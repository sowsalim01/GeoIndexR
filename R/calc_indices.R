#' Calculate Normalized Difference Vegetation Index (NDVI)
#'
#' Computes the Normalized Difference Vegetation Index (NDVI) directly from
#' near-infrared (\code{nir}) and red (\code{red}) bands or numeric vectors.
#'
#' \deqn{NDVI = \frac{NIR - RED}{NIR + RED}}
#'
#' @details
#' \strong{Description & Purpose}:
#' NDVI is the most widely used remote sensing index for monitoring vegetation greenness,
#' photosynthetic activity, and canopy vigor. Chlorophyll pigments in green leaves
#' absorb red light strongly, while the spongy mesophyll structure scatters near-infrared light.
#'
#' \strong{Direct Band Usage vs \code{geo_index()}}:
#' While \code{\link{geo_index}(image, "NDVI")} handles multi-band raster extraction and band mapping
#' automatically, \code{calc_ndvi()} is a direct, lower-level computation function that works on:
#' \itemize{
#'   \item Individual single-layer \code{terra::SpatRaster} objects (e.g. \code{nir = img[["nir"]], red = img[["red"]]}).
#'   \item Standard R numeric vectors, scalars, or matrices.
#' }
#'
#' \strong{Value Range & Interpretation}:
#' \itemize{
#'   \item \strong{0.6 to 0.9}: Dense, healthy green vegetation (forests, mature crops).
#'   \item \strong{0.2 to 0.5}: Moderate to sparse vegetation (grasslands, shrublands, young crops).
#'   \item \strong{0.0 to 0.1}: Bare soil, rock, sand, impervious urban areas.
#'   \item \strong{< 0.0}: Water bodies, snow, ice, and clouds.
#' }
#'
#' @param nir Near-infrared band (\code{terra::SpatRaster} or numeric vector/matrix).
#' @param red Red band (\code{terra::SpatRaster} or numeric vector/matrix).
#'
#' @return A single-layer \code{terra::SpatRaster} (with layer name \code{"NDVI"})
#'   or a numeric vector matching input dimensions.
#'
#' @references
#' Rouse, J. W., Haas, R. H., Schell, J. A., & Deering, D. W. (1974).
#' Monitoring the vernal advancement and retrogradation (Green wave effect) of
#' natural vegetation. NASA/GSFC Type III Final Report, Greenbelt, MD.
#'
#' @seealso \code{\link{geo_index}}, \code{\link{calc_savi}}, \code{\link{calc_evi}}, \code{\link{index_registry}}
#'
#' @examples
#' library(terra)
#'
#' # --- Example 1: Direct calculation on numeric values ---
#' calc_ndvi(nir = 0.8, red = 0.2)
#'
#' # Vectorized computation on numeric vectors:
#' nirs <- c(0.8, 0.5, 0.1, 0.02)
#' reds <- c(0.1, 0.3, 0.1, 0.05)
#' calc_ndvi(nir = nirs, red = reds)
#'
#' # --- Example 2: Calculation on extracted SpatRaster layers ---
#' img <- get_example_data()
#' ndvi_rast <- calc_ndvi(nir = img[["nir"]], red = img[["red"]])
#' print(ndvi_rast)
#'
#' @export
calc_ndvi <- function(nir, red) {
  check_numeric_or_raster(nir, "nir")
  check_numeric_or_raster(red, "red")
  check_spatial_compatibility(list(nir = nir, red = red))

  res <- safe_divide(nir - red, nir + red)
  if (inherits(res, "SpatRaster")) names(res) <- "NDVI"
  res
}

#' Calculate Soil Adjusted Vegetation Index (SAVI)
#'
#' Computes the Soil Adjusted Vegetation Index (SAVI) to minimize soil brightness
#' and background influences, using a canopy background adjustment factor \code{L}.
#'
#' \deqn{SAVI = \frac{NIR - RED}{NIR + RED + L} \times (1 + L)}
#'
#' @details
#' \strong{Description & Purpose}:
#' In arid, semi-arid, or sparsely vegetated regions, exposed soil background
#' alters red and NIR reflectance, distorting standard vegetation indices like NDVI.
#' SAVI introduces a soil line calibration constant \code{L} that stabilizes the index.
#'
#' \strong{Parameter \code{L}}:
#' \itemize{
#'   \item \code{L = 0.5} (default): Optimal for intermediate to moderate vegetation cover.
#'   \item \code{L = 1.0}: Recommended for very low / sparse vegetation cover.
#'   \item \code{L = 0.25}: Recommended for higher vegetation densities.
#'   \item When \code{L = 0}, SAVI is mathematically identical to NDVI.
#' }
#'
#' @param nir Near-infrared band (\code{terra::SpatRaster} or numeric).
#' @param red Red band (\code{terra::SpatRaster} or numeric).
#' @param L Soil adjustment factor. Defaults to \code{0.5}.
#'
#' @return A \code{terra::SpatRaster} (named \code{"SAVI"}) or numeric vector with index values.
#'
#' @references
#' Huete, A. R. (1988). A soil-adjusted vegetation index (SAVI).
#' Remote Sensing of Environment, 25(3), 295-309.
#'
#' @seealso \code{\link{geo_index}}, \code{\link{calc_osavi}}, \code{\link{calc_msavi}}, \code{\link{calc_ndvi}}
#'
#' @examples
#' # Numeric scalar calculation
#' calc_savi(nir = 0.7, red = 0.2, L = 0.5)
#'
#' # Raster layer calculation
#' img <- get_example_data()
#' savi_rast <- calc_savi(nir = img[["nir"]], red = img[["red"]], L = 0.5)
#' print(savi_rast)
#'
#' @export
calc_savi <- function(nir, red, L = 0.5) {
  check_numeric_or_raster(nir, "nir")
  check_numeric_or_raster(red, "red")
  check_spatial_compatibility(list(nir = nir, red = red))

  num <- (nir - red) * (1 + L)
  den <- (nir + red + L)
  res <- safe_divide(num, den)
  if (inherits(res, "SpatRaster")) names(res) <- "SAVI"
  res
}

#' Calculate Enhanced Vegetation Index (EVI)
#'
#' Computes the Enhanced Vegetation Index (EVI), optimizing the vegetation signal with
#' improved sensitivity in high biomass regions and reduced atmospheric aerosol influences.
#'
#' \deqn{EVI = G \times \frac{NIR - RED}{NIR + C1 \times RED - C2 \times BLUE + L}}
#'
#' @details
#' \strong{Description & Purpose}:
#' EVI was developed to enhance the vegetation signal in dense canopies where NDVI
#' saturates, while reducing canopy background noise and aerosol scattering using
#' the blue band.
#'
#' \strong{Important - Reflectance Scale}:
#' EVI constants (\code{G = 2.5}, \code{C1 = 6.0}, \code{C2 = 7.5}, \code{L = 1.0}) were calibrated for
#' physical surface reflectance in \code{[0, 1]}. If your input data are stored in raw
#' integer Digital Numbers (e.g., Sentinel-2 L2A \code{[0, 10000]}), divide the inputs by \code{10000}
#' or use \code{geo_index(..., scale_factor = 10000)}.
#'
#' @param nir Near-infrared band (\code{terra::SpatRaster} or numeric).
#' @param red Red band (\code{terra::SpatRaster} or numeric).
#' @param blue Blue band (\code{terra::SpatRaster} or numeric).
#' @param G Gain factor. Defaults to \code{2.5}.
#' @param C1 Atmospheric resistance coefficient for red. Defaults to \code{6.0}.
#' @param C2 Atmospheric resistance coefficient for blue. Defaults to \code{7.5}.
#' @param L Canopy background adjustment. Defaults to \code{1.0}.
#'
#' @return A \code{terra::SpatRaster} (named \code{"EVI"}) or numeric vector with index values.
#'
#' @references
#' Liu, H. Q., & Huete, A. (1995). A feedback based modification of the NDVI to
#' minimize canopy background and atmospheric noise. IEEE TGRS, 33(2), 457-465.
#'
#' @seealso \code{\link{geo_index}}, \code{\link{calc_ndvi}}, \code{\link{calc_savi}}
#'
#' @examples
#' # Numeric example with surface reflectance values in [0, 1]
#' calc_evi(nir = 0.50, red = 0.20, blue = 0.10)
#'
#' # Raster example
#' img <- get_example_data()
#' evi_rast <- calc_evi(nir = img[["nir"]], red = img[["red"]], blue = img[["blue"]])
#' print(evi_rast)
#'
#' @export
calc_evi <- function(nir, red, blue, G = 2.5, C1 = 6.0, C2 = 7.5, L = 1.0) {
  check_numeric_or_raster(nir, "nir")
  check_numeric_or_raster(red, "red")
  check_numeric_or_raster(blue, "blue")
  check_spatial_compatibility(list(nir = nir, red = red, blue = blue))

  num <- G * (nir - red)
  den <- (nir + C1 * red - C2 * blue + L)
  res <- safe_divide(num, den)
  if (inherits(res, "SpatRaster")) names(res) <- "EVI"
  res
}

#' Calculate Modified Soil Adjusted Vegetation Index 2 (MSAVI)
#'
#' Computes the Modified Soil Adjusted Vegetation Index 2 (MSAVI2), which eliminates the need
#' for manually finding or specifying a soil adjustment factor \code{L}.
#'
#' \deqn{MSAVI = \frac{2 \times NIR + 1 - \sqrt{(2 \times NIR + 1)^2 - 8 \times (NIR - RED)}}{2}}
#'
#' @details
#' \strong{Description & Purpose}:
#' MSAVI simplifies SAVI by calculating an inductive soil adjustment factor mathematically,
#' providing high sensitivity in sparse vegetation without requiring empirical soil line parameters.
#'
#' @param nir Near-infrared band (\code{terra::SpatRaster} or numeric).
#' @param red Red band (\code{terra::SpatRaster} or numeric).
#'
#' @return A \code{terra::SpatRaster} (named \code{"MSAVI"}) or numeric vector with index values.
#'
#' @references
#' Qi, J., Chehbouni, A., Huete, A. R., Kerr, Y. H., & Sorooshian, S. (1994).
#' A modified soil adjusted vegetation index. Remote Sensing of Environment, 48(2), 119-126.
#'
#' @seealso \code{\link{calc_savi}}, \code{\link{calc_osavi}}, \code{\link{geo_index}}
#'
#' @examples
#' # Numeric scalar calculation
#' calc_msavi(nir = 0.7, red = 0.2)
#'
#' # Raster layer calculation
#' img <- get_example_data()
#' msavi_rast <- calc_msavi(nir = img[["nir"]], red = img[["red"]])
#' print(msavi_rast)
#'
#' @export
calc_msavi <- function(nir, red) {
  check_numeric_or_raster(nir, "nir")
  check_numeric_or_raster(red, "red")
  check_spatial_compatibility(list(nir = nir, red = red))

  term <- (2 * nir + 1)^2 - 8 * (nir - red)
  if (inherits(term, "SpatRaster")) {
    term <- terra::ifel(term < 0, NA, term)
  } else {
    term[term < 0] <- NA
  }

  res <- (2 * nir + 1 - sqrt(term)) / 2
  if (inherits(res, "SpatRaster")) names(res) <- "MSAVI"
  res
}

#' Calculate Optimized Soil-Adjusted Vegetation Index (OSAVI)
#'
#' Computes the Optimized Soil-Adjusted Vegetation Index (OSAVI) with a standard
#' optimal adjustment parameter \code{theta = 0.16}.
#'
#' \deqn{OSAVI = \frac{NIR - RED}{NIR + RED + \theta} \times (1 + \theta)}
#'
#' @details
#' \strong{Description & Purpose}:
#' OSAVI is an optimization of SAVI that fixes \code{theta = 0.16}, which was found to
#' provide optimal suppression of soil background variation across a broad range of agricultural canopies.
#'
#' @param nir Near-infrared band (\code{terra::SpatRaster} or numeric).
#' @param red Red band (\code{terra::SpatRaster} or numeric).
#' @param theta Canopy background adjustment factor. Defaults to \code{0.16}.
#'
#' @return A \code{terra::SpatRaster} (named \code{"OSAVI"}) or numeric vector with index values.
#'
#' @references
#' Rondeaux, G., Steven, M., & Baret, F. (1996). Optimization of soil-adjusted
#' vegetation indices. Remote Sensing of Environment, 55(2), 95-107.
#'
#' @seealso \code{\link{calc_savi}}, \code{\link{calc_msavi}}, \code{\link{geo_index}}
#'
#' @examples
#' calc_osavi(nir = 0.7, red = 0.2)
#'
#' img <- get_example_data()
#' osavi_rast <- calc_osavi(nir = img[["nir"]], red = img[["red"]])
#' print(osavi_rast)
#'
#' @export
calc_osavi <- function(nir, red, theta = 0.16) {
  check_numeric_or_raster(nir, "nir")
  check_numeric_or_raster(red, "red")
  check_spatial_compatibility(list(nir = nir, red = red))

  num <- (nir - red) * (1 + theta)
  den <- (nir + red + theta)
  res <- safe_divide(num, den)
  if (inherits(res, "SpatRaster")) names(res) <- "OSAVI"
  res
}

#' Calculate Atmospherically Resistant Vegetation Index (ARVI)
#'
#' Computes the Atmospherically Resistant Vegetation Index (ARVI), which uses the
#' difference between blue and red bands to reduce atmospheric aerosol effects on red reflectance.
#'
#' \deqn{ARVI = \frac{NIR - RB}{NIR + RB}}
#' where \eqn{RB = RED - \gamma \times (BLUE - RED)}.
#'
#' @param nir Near-infrared band (\code{terra::SpatRaster} or numeric).
#' @param red Red band (\code{terra::SpatRaster} or numeric).
#' @param blue Blue band (\code{terra::SpatRaster} or numeric).
#' @param gamma Aerosol resistance coefficient. Defaults to \code{1.0}.
#'
#' @return A \code{terra::SpatRaster} (named \code{"ARVI"}) or numeric vector with index values.
#'
#' @references
#' Kaufman, Y. J., & Tanre, D. (1992). Atmospherically resistant vegetation index (ARVI)
#' for EOS-MODIS. IEEE TGRS, 30(2), 261-270.
#'
#' @seealso \code{\link{calc_ndvi}}, \code{\link{calc_evi}}, \code{\link{geo_index}}
#'
#' @examples
#' calc_arvi(nir = 0.7, red = 0.2, blue = 0.1)
#'
#' @export
calc_arvi <- function(nir, red, blue, gamma = 1.0) {
  check_numeric_or_raster(nir, "nir")
  check_numeric_or_raster(red, "red")
  check_numeric_or_raster(blue, "blue")
  check_spatial_compatibility(list(nir = nir, red = red, blue = blue))

  rb <- red - gamma * (blue - red)
  num <- nir - rb
  den <- nir + rb
  res <- safe_divide(num, den)
  if (inherits(res, "SpatRaster")) names(res) <- "ARVI"
  res
}

#' Calculate Green Normalized Difference Vegetation Index (GNDVI)
#'
#' Computes the Green Normalized Difference Vegetation Index (GNDVI) from near-infrared (\code{nir})
#' and green (\code{green}) bands.
#'
#' \deqn{GNDVI = \frac{NIR - GREEN}{NIR + GREEN}}
#'
#' @details
#' \strong{Description & Purpose}:
#' GNDVI is more sensitive to chlorophyll variations than standard NDVI, especially in
#' mid-to-high biomass stages and dense crops.
#'
#' @param nir Near-infrared band (\code{terra::SpatRaster} or numeric).
#' @param green Green band (\code{terra::SpatRaster} or numeric).
#'
#' @return A \code{terra::SpatRaster} (named \code{"GNDVI"}) or numeric vector with index values.
#'
#' @references
#' Gitelson, A. A., Kaufman, Y. J., & Merzlyak, M. N. (1996). Use of a green channel
#' in remote sensing of global vegetation from EOS-MODIS. Remote Sensing of Environment, 58(3), 289-298.
#'
#' @seealso \code{\link{calc_ndvi}}, \code{\link{geo_index}}
#'
#' @examples
#' calc_gndvi(nir = 0.8, green = 0.2)
#'
#' @export
calc_gndvi <- function(nir, green) {
  check_numeric_or_raster(nir, "nir")
  check_numeric_or_raster(green, "green")
  check_spatial_compatibility(list(nir = nir, green = green))

  res <- safe_divide(nir - green, nir + green)
  if (inherits(res, "SpatRaster")) names(res) <- "GNDVI"
  res
}

#' Calculate Normalized Difference Water Index (NDWI)
#'
#' Computes McFeeters' Normalized Difference Water Index (NDWI) for delineating open water bodies.
#'
#' \deqn{NDWI = \frac{GREEN - NIR}{GREEN + NIR}}
#'
#' @details
#' \strong{Description & Purpose}:
#' NDWI maximizes the reflectance of water in the green wavelength while minimizing the low
#' reflectance of water in the NIR wavelength.
#'
#' \strong{Interpretation}:
#' \itemize{
#'   \item \strong{> 0.0}: Water surfaces (rivers, lakes, wetlands, reservoirs).
#'   \item \strong{<= 0.0}: Non-water surfaces (vegetation, soil, built-up areas).
#' }
#'
#' @param green Green band (\code{terra::SpatRaster} or numeric).
#' @param nir Near-infrared band (\code{terra::SpatRaster} or numeric).
#'
#' @return A \code{terra::SpatRaster} (named \code{"NDWI"}) or numeric vector with index values.
#'
#' @references
#' McFeeters, S. K. (1996). The use of the Normalized Difference Water Index (NDWI)
#' in the delineation of open water features. International Journal of Remote Sensing, 17(7), 1425-1432.
#'
#' @seealso \code{\link{calc_mndwi}}, \code{\link{calc_awei}}, \code{\link{geo_index}}
#'
#' @examples
#' calc_ndwi(green = 0.6, nir = 0.2)
#'
#' img <- get_example_data()
#' ndwi_rast <- calc_ndwi(green = img[["green"]], nir = img[["nir"]])
#' print(ndwi_rast)
#'
#' @export
calc_ndwi <- function(green, nir) {
  check_numeric_or_raster(green, "green")
  check_numeric_or_raster(nir, "nir")
  check_spatial_compatibility(list(green = green, nir = nir))

  res <- safe_divide(green - nir, green + nir)
  if (inherits(res, "SpatRaster")) names(res) <- "NDWI"
  res
}

#' Calculate Modified Normalized Difference Water Index (MNDWI)
#'
#' Computes Xu's Modified Normalized Difference Water Index (MNDWI), substituting
#' SWIR1 for NIR to enhance open water features in urban landscapes.
#'
#' \deqn{MNDWI = \frac{GREEN - SWIR1}{GREEN + SWIR1}}
#'
#' @details
#' \strong{Description & Purpose}:
#' Standard NDWI can produce false water detections on built-up and impervious surfaces.
#' MNDWI suppresses built-up noise significantly because urban land has high SWIR reflectance.
#'
#' @param green Green band (\code{terra::SpatRaster} or numeric).
#' @param swir1 Short-wave infrared 1 band (\code{terra::SpatRaster} or numeric).
#'
#' @return A \code{terra::SpatRaster} (named \code{"MNDWI"}) or numeric vector with index values.
#'
#' @references
#' Xu, H. (2006). Modification of normalised difference water index (NDWI) to
#' enhance open water features in remotely sensed imagery. IJRS, 27(14), 3025-3033.
#'
#' @seealso \code{\link{calc_ndwi}}, \code{\link{calc_awei}}, \code{\link{geo_index}}
#'
#' @examples
#' calc_mndwi(green = 0.7, swir1 = 0.1)
#'
#' @export
calc_mndwi <- function(green, swir1) {
  check_numeric_or_raster(green, "green")
  check_numeric_or_raster(swir1, "swir1")
  check_spatial_compatibility(list(green = green, swir1 = swir1))

  res <- safe_divide(green - swir1, green + swir1)
  if (inherits(res, "SpatRaster")) names(res) <- "MNDWI"
  res
}

#' Calculate Automated Water Extraction Index (AWEI)
#'
#' Computes the Automated Water Extraction Index (AWEI) to extract surface water
#' while suppressing shadow artifacts and dark impervious surfaces.
#'
#' \deqn{AWEI = 4 \times (GREEN - SWIR1) - (0.25 \times NIR + 2.75 \times SWIR2)}
#'
#' @param green Green band (\code{terra::SpatRaster} or numeric).
#' @param nir Near-infrared band (\code{terra::SpatRaster} or numeric).
#' @param swir1 SWIR 1 band (\code{terra::SpatRaster} or numeric).
#' @param swir2 SWIR 2 band (\code{terra::SpatRaster} or numeric).
#'
#' @return A \code{terra::SpatRaster} (named \code{"AWEI"}) or numeric vector with index values.
#'
#' @references
#' Feyisa, G. L., Meilby, H., Fensholt, R., & Proud, S. R. (2014). Automated Water
#' Extraction Index: A new technique for surface water mapping using Landsat imagery.
#' Remote Sensing of Environment, 140, 23-35.
#'
#' @seealso \code{\link{calc_ndwi}}, \code{\link{calc_mndwi}}, \code{\link{geo_index}}
#'
#' @examples
#' calc_awei(green = 0.5, nir = 0.2, swir1 = 0.1, swir2 = 0.05)
#'
#' @export
calc_awei <- function(green, nir, swir1, swir2) {
  check_numeric_or_raster(green, "green")
  check_numeric_or_raster(nir, "nir")
  check_numeric_or_raster(swir1, "swir1")
  check_numeric_or_raster(swir2, "swir2")
  check_spatial_compatibility(list(green = green, nir = nir, swir1 = swir1, swir2 = swir2))

  res <- 4 * (green - swir1) - (0.25 * nir + 2.75 * swir2)
  if (inherits(res, "SpatRaster")) names(res) <- "AWEI"
  res
}

#' Calculate Normalized Difference Built-up Index (NDBI)
#'
#' Computes the Normalized Difference Built-up Index (NDBI) for mapping urban and impervious surfaces.
#'
#' \deqn{NDBI = \frac{SWIR1 - NIR}{SWIR1 + NIR}}
#'
#' @param swir1 Short-wave infrared 1 band (\code{terra::SpatRaster} or numeric).
#' @param nir Near-infrared band (\code{terra::SpatRaster} or numeric).
#'
#' @return A \code{terra::SpatRaster} (named \code{"NDBI"}) or numeric vector with index values.
#'
#' @references
#' Zha, Y., Gao, J., & Ni, S. (2003). Use of normalized difference built-up index in
#' automatically mapping urban areas from TM imagery. IJRS, 24(3), 583-594.
#'
#' @seealso \code{\link{calc_ibi}}, \code{\link{geo_index}}
#'
#' @examples
#' calc_ndbi(swir1 = 0.6, nir = 0.3)
#'
#' @export
calc_ndbi <- function(swir1, nir) {
  check_numeric_or_raster(swir1, "swir1")
  check_numeric_or_raster(nir, "nir")
  check_spatial_compatibility(list(swir1 = swir1, nir = nir))

  res <- safe_divide(swir1 - nir, swir1 + nir)
  if (inherits(res, "SpatRaster")) names(res) <- "NDBI"
  res
}

#' Calculate Index-Based Built-Up Index (IBI)
#'
#' Computes the Index-Based Built-Up Index (IBI) by synthesizing NDBI, SAVI, and MNDWI.
#'
#' @param swir1 Short-wave infrared 1 band (\code{terra::SpatRaster} or numeric).
#' @param nir Near-infrared band (\code{terra::SpatRaster} or numeric).
#' @param red Red band (\code{terra::SpatRaster} or numeric).
#' @param green Green band (\code{terra::SpatRaster} or numeric).
#' @param L Soil adjustment factor for internal SAVI. Defaults to \code{0.5}.
#'
#' @return A \code{terra::SpatRaster} (named \code{"IBI"}) or numeric vector with index values.
#'
#' @references
#' Xu, H. (2007). Extraction of urban built-up land features from Landsat imagery
#' using a new index-based approach. International Journal of Remote Sensing, 29(14), 4267-4283.
#'
#' @seealso \code{\link{calc_ndbi}}, \code{\link{geo_index}}
#'
#' @examples
#' calc_ibi(swir1 = 0.4, nir = 0.3, red = 0.2, green = 0.1)
#'
#' @export
calc_ibi <- function(swir1, nir, red, green, L = 0.5) {
  check_numeric_or_raster(swir1, "swir1")
  check_numeric_or_raster(nir, "nir")
  check_numeric_or_raster(red, "red")
  check_numeric_or_raster(green, "green")
  check_spatial_compatibility(list(swir1 = swir1, nir = nir, red = red, green = green))

  ndbi <- safe_divide(swir1 - nir, swir1 + nir)
  savi <- safe_divide((nir - red) * (1 + L), nir + red + L)
  mndwi <- safe_divide(green - swir1, green + swir1)

  bg <- (savi + mndwi) / 2
  num <- ndbi - bg
  den <- ndbi + bg

  res <- safe_divide(num, den)
  if (inherits(res, "SpatRaster")) names(res) <- "IBI"
  res
}

#' Calculate Normalized Difference Moisture Index (NDMI)
#'
#' Computes the Normalized Difference Moisture Index (NDMI) to assess vegetation canopy liquid water content.
#'
#' \deqn{NDMI = \frac{NIR - SWIR1}{NIR + SWIR1}}
#'
#' @param nir Near-infrared band (\code{terra::SpatRaster} or numeric).
#' @param swir1 Short-wave infrared 1 band (\code{terra::SpatRaster} or numeric).
#'
#' @return A \code{terra::SpatRaster} (named \code{"NDMI"}) or numeric vector with index values.
#'
#' @references
#' Gao, B. C. (1996). NDWI—A normalized difference water index for remote sensing of
#' vegetation liquid water from space. Remote Sensing of Environment, 58(3), 257-266.
#'
#' @seealso \code{\link{calc_msi}}, \code{\link{geo_index}}
#'
#' @examples
#' calc_ndmi(nir = 0.7, swir1 = 0.3)
#'
#' @export
calc_ndmi <- function(nir, swir1) {
  check_numeric_or_raster(nir, "nir")
  check_numeric_or_raster(swir1, "swir1")
  check_spatial_compatibility(list(nir = nir, swir1 = swir1))

  res <- safe_divide(nir - swir1, nir + swir1)
  if (inherits(res, "SpatRaster")) names(res) <- "NDMI"
  res
}

#' Calculate Moisture Stress Index (MSI)
#'
#' Computes the Moisture Stress Index (MSI) from SWIR1 and NIR bands.
#'
#' \deqn{MSI = \frac{SWIR1}{NIR}}
#'
#' @param swir1 Short-wave infrared 1 band (\code{terra::SpatRaster} or numeric).
#' @param nir Near-infrared band (\code{terra::SpatRaster} or numeric).
#'
#' @return A \code{terra::SpatRaster} (named \code{"MSI"}) or numeric vector with index values.
#'
#' @references
#' Rock, B. N., Vogelmann, J. E., Williams, D. L., & Vogelmann, A. F. (1986).
#' Remote detection of forest damage. BioScience, 36(7), 439-445.
#'
#' @seealso \code{\link{calc_ndmi}}, \code{\link{geo_index}}
#'
#' @examples
#' calc_msi(swir1 = 0.4, nir = 0.8)
#'
#' @export
calc_msi <- function(swir1, nir) {
  check_numeric_or_raster(swir1, "swir1")
  check_numeric_or_raster(nir, "nir")
  check_spatial_compatibility(list(swir1 = swir1, nir = nir))

  res <- safe_divide(swir1, nir)
  if (inherits(res, "SpatRaster")) names(res) <- "MSI"
  res
}

#' Calculate Bare Soil Index (BSI)
#'
#' Computes the Bare Soil Index (BSI), combining blue, red, NIR, and SWIR bands to
#' distinguish bare soils from vegetation and impervious land.
#'
#' \deqn{BSI = \frac{(SWIR1 + RED) - (NIR + BLUE)}{(SWIR1 + RED) + (NIR + BLUE)}}
#'
#' @param swir1 Short-wave infrared 1 band (\code{terra::SpatRaster} or numeric).
#' @param red Red band (\code{terra::SpatRaster} or numeric).
#' @param nir Near-infrared band (\code{terra::SpatRaster} or numeric).
#' @param blue Blue band (\code{terra::SpatRaster} or numeric).
#'
#' @return A \code{terra::SpatRaster} (named \code{"BSI"}) or numeric vector with index values.
#'
#' @references
#' Rikimaru, A., Roy, P. S., & Miyatake, S. (2002). Tropical forest cover density mapping.
#' Tropical Ecology, 43(1), 39-47.
#'
#' @seealso \code{\link{geo_index}}
#'
#' @examples
#' calc_bsi(swir1 = 0.5, red = 0.4, nir = 0.2, blue = 0.1)
#'
#' @export
calc_bsi <- function(swir1, red, nir, blue) {
  check_numeric_or_raster(swir1, "swir1")
  check_numeric_or_raster(red, "red")
  check_numeric_or_raster(nir, "nir")
  check_numeric_or_raster(blue, "blue")
  check_spatial_compatibility(list(swir1 = swir1, red = red, nir = nir, blue = blue))

  num <- (swir1 + red) - (nir + blue)
  den <- (swir1 + red) + (nir + blue)
  res <- safe_divide(num, den)
  if (inherits(res, "SpatRaster")) names(res) <- "BSI"
  res
}

#' Calculate Normalized Difference Snow Index (NDSI)
#'
#' Computes the Normalized Difference Snow Index (NDSI) for mapping snow and ice cover.
#'
#' \deqn{NDSI = \frac{GREEN - SWIR1}{GREEN + SWIR1}}
#'
#' @param green Green band (\code{terra::SpatRaster} or numeric).
#' @param swir1 Short-wave infrared 1 band (\code{terra::SpatRaster} or numeric).
#'
#' @return A \code{terra::SpatRaster} (named \code{"NDSI"}) or numeric vector with index values.
#'
#' @references
#' Hall, D. K., Riggs, G. A., & Salomonson, V. V. (1995). Development of methods for mapping
#' global snow cover using moderate resolution imaging spectroradiometer data.
#' Remote Sensing of Environment, 54(2), 127-140.
#'
#' @seealso \code{\link{geo_index}}
#'
#' @examples
#' calc_ndsi(green = 0.8, swir1 = 0.2)
#'
#' @export
calc_ndsi <- function(green, swir1) {
  check_numeric_or_raster(green, "green")
  check_numeric_or_raster(swir1, "swir1")
  check_spatial_compatibility(list(green = green, swir1 = swir1))

  res <- safe_divide(green - swir1, green + swir1)
  if (inherits(res, "SpatRaster")) names(res) <- "NDSI"
  res
}

#' Dispatch and Calculate a Named Index
#'
#' Dynamically invokes the calculation function for any registered index by name.
#'
#' @param index Character string specifying index name (e.g., \code{"NDVI"}, \code{"SAVI"}).
#' @param ... Named band arguments (e.g., \code{nir = ..., red = ...}) and optional index
#'   parameters (such as \code{L = 0.5}).
#'
#' @return A \code{SpatRaster} or numeric vector.
#'
#' @examples
#' calc_index("NDVI", nir = 0.8, red = 0.2)
#' calc_index("SAVI", nir = 0.8, red = 0.2, L = 0.5)
#'
#' @export
calc_index <- function(index, ...) {
  if (missing(index) || length(index) != 1 || !is.character(index)) {
    stop("'index' must be a single character string.", call. = FALSE)
  }

  meta    <- get_index_meta(index)
  fn_name <- paste0("calc_", tolower(meta$index))
  fn      <- get(fn_name, mode = "function", envir = asNamespace("GeoIndexR"))

  # Canonical parameter names from the function signature (e.g. "nir", "red", "L", "G", ...)
  fn_formals <- names(formals(fn))

  args <- list(...)

  # Normalise user-provided argument names: match case-insensitively against the
  # canonical names in the function signature, then use the canonical form.
  # This handles both band args (always lowercase: nir, red, blue …) and optional
  # parameters that may be uppercase or mixed (L, G, C1, C2, theta, gamma …).
  matched_names <- vapply(names(args), function(nm) {
    hit <- fn_formals[tolower(fn_formals) == tolower(nm)]
    if (length(hit) == 1L) hit else nm   # keep original if no match found
  }, character(1))
  names(args) <- matched_names

  # Check required bands using lowercase (required_bands are always lowercase)
  missing_bands <- setdiff(meta$required_bands, tolower(names(args)))
  if (length(missing_bands) > 0) {
    stop(
      sprintf(
        "Index '%s' requires argument(s): %s.\nProvided arguments: %s.\nMissing: %s.",
        meta$index,
        paste(meta$required_bands, collapse = ", "),
        if (length(args) > 0) paste(names(args), collapse = ", ") else "none",
        paste(missing_bands, collapse = ", ")
      ),
      call. = FALSE
    )
  }

  # Start from registry defaults, then override with user-supplied values
  call_args <- meta$default_params
  for (arg_name in names(args)) {
    call_args[[arg_name]] <- args[[arg_name]]
  }

  do.call(fn, call_args)
}

