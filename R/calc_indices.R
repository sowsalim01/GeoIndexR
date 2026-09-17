#' Calculate Normalized Difference Vegetation Index (NDVI)
#'
#' Computes the Normalized Difference Vegetation Index from near-infrared (\code{nir})
#' and red (\code{red}) bands.
#'
#' \deqn{NDVI = \frac{NIR - RED}{NIR + RED}}
#'
#' @param nir Near-infrared band (\code{SpatRaster} or numeric vector).
#' @param red Red band (\code{SpatRaster} or numeric vector).
#'
#' @return A \code{SpatRaster} (named \code{"NDVI"}) or numeric vector with index values.
#'
#' @references
#' Rouse, J. W., et al. (1974). Monitoring the vernal advancement and retrogradation
#' (Green wave effect) of natural vegetation. NASA/GSFC Type III Final Report.
#'
#' @examples
#' calc_ndvi(nir = 0.8, red = 0.2)
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
#' Computes the Soil Adjusted Vegetation Index to minimize soil brightness
#' influences, using a canopy background adjustment factor \code{L}.
#'
#' \deqn{SAVI = \frac{NIR - RED}{NIR + RED + L} \times (1 + L)}
#'
#' @param nir Near-infrared band (\code{SpatRaster} or numeric).
#' @param red Red band (\code{SpatRaster} or numeric).
#' @param L Soil adjustment factor. Defaults to \code{0.5}.
#'
#' @return A \code{SpatRaster} (named \code{"SAVI"}) or numeric vector with index values.
#'
#' @references
#' Huete, A. R. (1988). A soil-adjusted vegetation index (SAVI).
#' Remote Sensing of Environment, 25(3), 295-309.
#'
#' @examples
#' calc_savi(nir = 0.7, red = 0.2, L = 0.5)
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
#' Computes the Enhanced Vegetation Index, optimizing the vegetation signal with
#' improved sensitivity in high biomass regions and reduced atmospheric influences.
#' Note: Band values must represent surface reflectance \code{[0, 1]}.
#'
#' \deqn{EVI = G \times \frac{NIR - RED}{NIR + C1 \times RED - C2 \times BLUE + L}}
#'
#' @param nir Near-infrared band (\code{SpatRaster} or numeric).
#' @param red Red band (\code{SpatRaster} or numeric).
#' @param blue Blue band (\code{SpatRaster} or numeric).
#' @param G Gain factor. Defaults to \code{2.5}.
#' @param C1 Atmospheric resistance coefficient for red. Defaults to \code{6.0}.
#' @param C2 Atmospheric resistance coefficient for blue. Defaults to \code{7.5}.
#' @param L Canopy background adjustment. Defaults to \code{1.0}.
#'
#' @return A \code{SpatRaster} (named \code{"EVI"}) or numeric vector with index values.
#'
#' @references
#' Liu, H. Q., & Huete, A. (1995). A feedback based modification of the NDVI to
#' minimize canopy background and atmospheric noise. IEEE TGRS, 33(2), 457-465.
#'
#' @examples
#' calc_evi(nir = 0.7, red = 0.1, blue = 0.05)
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
#' Computes the Modified Soil Adjusted Vegetation Index 2, which eliminates the need
#' for finding the soil line factor \code{L} manually.
#'
#' \deqn{MSAVI = \frac{2 \times NIR + 1 - \sqrt{(2 \times NIR + 1)^2 - 8 \times (NIR - RED)}}{2}}
#'
#' @param nir Near-infrared band (\code{SpatRaster} or numeric).
#' @param red Red band (\code{SpatRaster} or numeric).
#'
#' @return A \code{SpatRaster} (named \code{"MSAVI"}) or numeric vector with index values.
#'
#' @references
#' Qi, J., et al. (1994). A modified soil adjusted vegetation index.
#' Remote Sensing of Environment, 48(2), 119-126.
#'
#' @examples
#' calc_msavi(nir = 0.7, red = 0.2)
#'
#' @export
calc_msavi <- function(nir, red) {
  check_numeric_or_raster(nir, "nir")
  check_numeric_or_raster(red, "red")
  check_spatial_compatibility(list(nir = nir, red = red))

  term <- (2 * nir + 1)^2 - 8 * (nir - red)
  # Handle negative values inside sqrt gracefully
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
#' Computes the Optimized Soil-Adjusted Vegetation Index with an optimal standard
#' adjustment factor \code{theta = 0.16}.
#'
#' \deqn{OSAVI = \frac{NIR - RED}{NIR + RED + \theta} \times (1 + \theta)}
#'
#' @param nir Near-infrared band (\code{SpatRaster} or numeric).
#' @param red Red band (\code{SpatRaster} or numeric).
#' @param theta Canopy background adjustment factor. Defaults to \code{0.16}.
#'
#' @return A \code{SpatRaster} (named \code{"OSAVI"}) or numeric vector with index values.
#'
#' @references
#' Rondeaux, G., et al. (1996). Optimization of soil-adjusted vegetation indices.
#' Remote Sensing of Environment, 55(2), 95-107.
#'
#' @examples
#' calc_osavi(nir = 0.7, red = 0.2)
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
#' Computes the Atmospherically Resistant Vegetation Index, which uses the difference
#' between blue and red bands to reduce atmospheric aerosol effects on red reflectance.
#'
#' \deqn{ARVI = \frac{NIR - (RED - \gamma \times (BLUE - RED))}{NIR + (RED - \gamma \times (BLUE - RED))}}
#'
#' @param nir Near-infrared band (\code{SpatRaster} or numeric).
#' @param red Red band (\code{SpatRaster} or numeric).
#' @param blue Blue band (\code{SpatRaster} or numeric).
#' @param gamma Aerosol correction factor. Defaults to \code{1.0}.
#'
#' @return A \code{SpatRaster} (named \code{"ARVI"}) or numeric vector with index values.
#'
#' @references
#' Kaufman, Y. J., & Tanre, D. (1992). Atmospherically resistant vegetation index (ARVI)
#' for EOS-MODIS. IEEE TGRS, 30(2), 261-270.
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
#' Computes the Green NDVI from near-infrared (\code{nir}) and green (\code{green}) bands.
#'
#' \deqn{GNDVI = \frac{NIR - GREEN}{NIR + GREEN}}
#'
#' @param nir Near-infrared band (\code{SpatRaster} or numeric).
#' @param green Green band (\code{SpatRaster} or numeric).
#'
#' @return A \code{SpatRaster} (named \code{"GNDVI"}) or numeric vector with index values.
#'
#' @references
#' Gitelson, A. A., et al. (1996). Use of a green channel in remote sensing of
#' global vegetation from EOS-MODIS. Remote Sensing of Environment, 58(3), 289-298.
#'
#' @examples
#' calc_gndvi(nir = 0.7, green = 0.3)
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
#' Computes McFeeters' Normalized Difference Water Index for delineating open water bodies.
#'
#' \deqn{NDWI = \frac{GREEN - NIR}{GREEN + NIR}}
#'
#' @param green Green band (\code{SpatRaster} or numeric).
#' @param nir Near-infrared band (\code{SpatRaster} or numeric).
#'
#' @return A \code{SpatRaster} (named \code{"NDWI"}) or numeric vector with index values.
#'
#' @references
#' McFeeters, S. K. (1996). The use of the Normalized Difference Water Index (NDWI)
#' in the delineation of open water features. International Journal of Remote Sensing, 17(7), 1425-1432.
#'
#' @examples
#' calc_ndwi(green = 0.6, nir = 0.2)
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
#' Computes Xu's Modified NDWI, substituting SWIR for NIR to enhance open water features
#' while reducing built-up noise.
#'
#' \deqn{MNDWI = \frac{GREEN - SWIR1}{GREEN + SWIR1}}
#'
#' @param green Green band (\code{SpatRaster} or numeric).
#' @param swir1 Short-wave infrared 1 band (\code{SpatRaster} or numeric).
#'
#' @return A \code{SpatRaster} (named \code{"MNDWI"}) or numeric vector with index values.
#'
#' @references
#' Xu, H. (2006). Modification of normalised difference water index (NDWI) to
#' enhance open water features in remotely sensed imagery. IJRS, 27(14), 3025-3033.
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
#' Computes the Automated Water Extraction Index under non-shadow conditions (\code{"nsh"})
#' or shadow conditions (\code{"sh"}).
#'
#' \deqn{AWEInsh = 4 \times (GREEN - SWIR1) - (0.25 \times NIR + 2.75 \times SWIR2)}
#'
#' @param green Green band (\code{SpatRaster} or numeric).
#' @param nir Near-infrared band (\code{SpatRaster} or numeric).
#' @param swir1 SWIR 1 band (\code{SpatRaster} or numeric).
#' @param swir2 SWIR 2 band (\code{SpatRaster} or numeric).
#'
#' @return A \code{SpatRaster} (named \code{"AWEI"}) or numeric vector with index values.
#'
#' @references
#' Feyisa, G. L., et al. (2014). Automated Water Extraction Index: A new technique
#' for surface water mapping using Landsat imagery. Remote Sensing of Environment, 140, 23-35.
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
#' Computes the Normalized Difference Built-up Index for mapping urban and impervious surfaces.
#'
#' \deqn{NDBI = \frac{SWIR1 - NIR}{SWIR1 + NIR}}
#'
#' @param swir1 Short-wave infrared 1 band (\code{SpatRaster} or numeric).
#' @param nir Near-infrared band (\code{SpatRaster} or numeric).
#'
#' @return A \code{SpatRaster} (named \code{"NDBI"}) or numeric vector with index values.
#'
#' @references
#' Zha, Y., et al. (2003). Use of normalized difference built-up index in
#' automatically mapping urban areas from TM imagery. IJRS, 24(3), 583-594.
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
#' Computes the Index-Based Built-Up Index by synthesizing NDBI, SAVI, and MNDWI.
#'
#' @param swir1 Short-wave infrared 1 band (\code{SpatRaster} or numeric).
#' @param nir Near-infrared band (\code{SpatRaster} or numeric).
#' @param red Red band (\code{SpatRaster} or numeric).
#' @param green Green band (\code{SpatRaster} or numeric).
#' @param L Soil adjustment factor. Defaults to \code{0.5}.
#'
#' @return A \code{SpatRaster} (named \code{"IBI"}) or numeric vector with index values.
#'
#' @references
#' Xu, H. (2007). Extraction of urban built-up land features from Landsat imagery
#' using a new index-based approach. International Journal of Remote Sensing, 29(14), 4267-4283.
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
#' Computes the Normalized Difference Moisture Index to assess vegetation canopy water content.
#'
#' \deqn{NDMI = \frac{NIR - SWIR1}{NIR + SWIR1}}
#'
#' @param nir Near-infrared band (\code{SpatRaster} or numeric).
#' @param swir1 Short-wave infrared 1 band (\code{SpatRaster} or numeric).
#'
#' @return A \code{SpatRaster} (named \code{"NDMI"}) or numeric vector with index values.
#'
#' @references
#' Gao, B. C. (1996). NDWI—A normalized difference water index for remote sensing of
#' vegetation liquid water from space. Remote Sensing of Environment, 58(3), 257-266.
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
#' Computes the Moisture Stress Index from SWIR1 and NIR bands. Higher values indicate
#' higher plant water stress.
#'
#' \deqn{MSI = \frac{SWIR1}{NIR}}
#'
#' @param swir1 Short-wave infrared 1 band (\code{SpatRaster} or numeric).
#' @param nir Near-infrared band (\code{SpatRaster} or numeric).
#'
#' @return A \code{SpatRaster} (named \code{"MSI"}) or numeric vector with index values.
#'
#' @references
#' Rock, B. N., et al. (1986). Remote detection of forest damage. BioScience, 36(7), 439-445.
#'
#' @examples
#' calc_msi(swir1 = 0.4, nir = 0.6)
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
#' Computes the Bare Soil Index, combining blue, red, NIR, and SWIR bands to
#' distinguish bare soils and agricultural fallow lands from vegetation and impervious areas.
#'
#' \deqn{BSI = \frac{(SWIR1 + RED) - (NIR + BLUE)}{(SWIR1 + RED) + (NIR + BLUE)}}
#'
#' @param swir1 Short-wave infrared 1 band (\code{SpatRaster} or numeric).
#' @param red Red band (\code{SpatRaster} or numeric).
#' @param nir Near-infrared band (\code{SpatRaster} or numeric).
#' @param blue Blue band (\code{SpatRaster} or numeric).
#'
#' @return A \code{SpatRaster} (named \code{"BSI"}) or numeric vector with index values.
#'
#' @references
#' Rikimaru, A., et al. (2002). Tropical forest cover density mapping.
#' Tropical Ecology, 43(1), 39-47.
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
#' Computes the Normalized Difference Snow Index for identifying snow and ice cover.
#'
#' \deqn{NDSI = \frac{GREEN - SWIR1}{GREEN + SWIR1}}
#'
#' @param green Green band (\code{SpatRaster} or numeric).
#' @param swir1 Short-wave infrared 1 band (\code{SpatRaster} or numeric).
#'
#' @return A \code{SpatRaster} (named \code{"NDSI"}) or numeric vector with index values.
#'
#' @references
#' Hall, D. K., et al. (1995). Development of methods for mapping global snow cover
#' using moderate resolution imaging spectroradiometer data. Remote Sensing of Environment, 54(2), 127-140.
#'
#' @examples
#' calc_ndsi(green = 0.8, swir1 = 0.1)
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

  meta <- get_index_meta(index)
  args <- list(...)
  names(args) <- tolower(names(args))

  # Check required bands
  missing_bands <- setdiff(meta$required_bands, names(args))
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

  fn_name <- paste0("calc_", tolower(meta$index))
  fn <- get(fn_name, mode = "function", envir = asNamespace("GeoIndexR"))

  # Merge default params with provided args
  call_args <- meta$default_params
  for (arg_name in names(args)) {
    call_args[[arg_name]] <- args[[arg_name]]
  }

  do.call(fn, call_args)
}
