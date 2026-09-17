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
#' # Numeric vector example
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
#' in the delineation of open water features. IJRS, 17(7), 1425-1432.
#'
#' @examples
#' calc_ndwi(green = 0.5, nir = 0.1)
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
#' Computes Xu's Modified Normalized Difference Water Index, replacing NIR with SWIR
#' to enhance open water features while suppressing built-up noise.
#'
#' \deqn{MNDWI = \frac{GREEN - SWIR}{GREEN + SWIR}}
#'
#' @param green Green band (\code{SpatRaster} or numeric).
#' @param swir Shortwave infrared band (\code{SpatRaster} or numeric).
#'
#' @return A \code{SpatRaster} (named \code{"MNDWI"}) or numeric vector with index values.
#'
#' @references
#' Xu, H. (2006). Modification of normalised difference water index (NDWI) to
#' enhance open water features in remotely sensed imagery. IJRS, 27(14), 3025-3033.
#'
#' @examples
#' calc_mndwi(green = 0.6, swir = 0.1)
#'
#' @export
calc_mndwi <- function(green, swir) {
  check_numeric_or_raster(green, "green")
  check_numeric_or_raster(swir, "swir")
  check_spatial_compatibility(list(green = green, swir = swir))

  res <- safe_divide(green - swir, green + swir)
  if (inherits(res, "SpatRaster")) names(res) <- "MNDWI"
  res
}

#' Calculate Normalized Difference Built-up Index (NDBI)
#'
#' Computes the Normalized Difference Built-up Index for mapping urban and built-up areas.
#'
#' \deqn{NDBI = \frac{SWIR - NIR}{SWIR + NIR}}
#'
#' @param swir Shortwave infrared band (\code{SpatRaster} or numeric).
#' @param nir Near-infrared band (\code{SpatRaster} or numeric).
#'
#' @return A \code{SpatRaster} (named \code{"NDBI"}) or numeric vector with index values.
#'
#' @references
#' Zha, Y., et al. (2003). Use of normalized difference built-up index in
#' automatically mapping urban areas from TM imagery. IJRS, 24(3), 583-594.
#'
#' @examples
#' calc_ndbi(swir = 0.4, nir = 0.2)
#'
#' @export
calc_ndbi <- function(swir, nir) {
  check_numeric_or_raster(swir, "swir")
  check_numeric_or_raster(nir, "nir")
  check_spatial_compatibility(list(swir = swir, nir = nir))

  res <- safe_divide(swir - nir, swir + nir)
  if (inherits(res, "SpatRaster")) names(res) <- "NDBI"
  res
}

#' Calculate Normalized Difference Moisture Index (NDMI)
#'
#' Computes the Normalized Difference Moisture Index (also known as NDWI-Gao)
#' for monitoring vegetation canopy water content.
#'
#' \deqn{NDMI = \frac{NIR - SWIR}{NIR + SWIR}}
#'
#' @param nir Near-infrared band (\code{SpatRaster} or numeric).
#' @param swir Shortwave infrared band (\code{SpatRaster} or numeric).
#'
#' @return A \code{SpatRaster} (named \code{"NDMI"}) or numeric vector with index values.
#'
#' @references
#' Gao, B. C. (1996). NDWI—A normalized difference water index for remote
#' sensing of vegetation liquid water from space. RSE, 58(3), 257-266.
#'
#' @examples
#' calc_ndmi(nir = 0.7, swir = 0.3)
#'
#' @export
calc_ndmi <- function(nir, swir) {
  check_numeric_or_raster(nir, "nir")
  check_numeric_or_raster(swir, "swir")
  check_spatial_compatibility(list(nir = nir, swir = swir))

  res <- safe_divide(nir - swir, nir + swir)
  if (inherits(res, "SpatRaster")) names(res) <- "NDMI"
  res
}

#' Calculate Bare Soil Index (BSI)
#'
#' Computes the Bare Soil Index combining blue, red, near-infrared, and shortwave infrared bands.
#'
#' \deqn{BSI = \frac{(SWIR + RED) - (NIR + BLUE)}{(SWIR + RED) + (NIR + BLUE)}}
#'
#' @param swir Shortwave infrared band (\code{SpatRaster} or numeric).
#' @param red Red band (\code{SpatRaster} or numeric).
#' @param nir Near-infrared band (\code{SpatRaster} or numeric).
#' @param blue Blue band (\code{SpatRaster} or numeric).
#'
#' @return A \code{SpatRaster} (named \code{"BSI"}) or numeric vector with index values.
#'
#' @references
#' Rikimaru, A., et al. (2002). Tropical forest cover density mapping.
#' International Journal of Applied Earth Observation and Geoinformation, 4(1), 39-47.
#'
#' @examples
#' calc_bsi(swir = 0.4, red = 0.3, nir = 0.2, blue = 0.1)
#'
#' @export
calc_bsi <- function(swir, red, nir, blue) {
  check_numeric_or_raster(swir, "swir")
  check_numeric_or_raster(red, "red")
  check_numeric_or_raster(nir, "nir")
  check_numeric_or_raster(blue, "blue")
  check_spatial_compatibility(list(swir = swir, red = red, nir = nir, blue = blue))

  num <- (swir + red) - (nir + blue)
  den <- (swir + red) + (nir + blue)
  res <- safe_divide(num, den)
  if (inherits(res, "SpatRaster")) names(res) <- "BSI"
  res
}

#' Generic Direct Index Calculator by Band
#'
#' Computes any registered index given individual band inputs passed via \code{...}.
#'
#' @param index Character string of the index code (e.g., \code{"NDVI"}, \code{"SAVI"}).
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
