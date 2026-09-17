#' Validation and Numerical Safety Utilities
#'
#' Internal helper functions for data validation, spatial compatibility checks,
#' and safe mathematical calculations (preventing division by zero and infinite values).
#'
#' @name validation
#' @keywords internal
NULL

#' Check that an object is a SpatRaster
#'
#' @param x Object to check.
#' @param name Name of argument for error message.
#'
#' @keywords internal
check_raster <- function(x, name = "image") {
  if (!inherits(x, "SpatRaster")) {
    stop(sprintf("Argument '%s' must be a terra 'SpatRaster' object (received: '%s').",
                 name, class(x)[1]), call. = FALSE)
  }
  if (terra::nlyr(x) < 1) {
    stop(sprintf("Argument '%s' contains 0 layers.", name), call. = FALSE)
  }
  invisible(TRUE)
}

#' Check that an input is either a SpatRaster or a numeric vector/array
#'
#' @param x Input to check.
#' @param name Name of argument.
#'
#' @keywords internal
check_numeric_or_raster <- function(x, name = "band") {
  if (!inherits(x, "SpatRaster") && !is.numeric(x)) {
    stop(sprintf("Argument '%s' must be a 'SpatRaster' or a numeric object (received: '%s').",
                 name, class(x)[1]), call. = FALSE)
  }
  invisible(TRUE)
}

#' Check spatial compatibility across multiple SpatRaster objects
#'
#' Ensures all provided single-layer rasters have identical extent, resolution,
#' CRS, and dimensions before computing pixel-wise operations.
#'
#' @param bands A named list of SpatRaster objects.
#'
#' @keywords internal
check_spatial_compatibility <- function(bands) {
  raster_bands <- bands[vapply(bands, function(b) inherits(b, "SpatRaster"), logical(1))]
  if (length(raster_bands) <= 1) {
    return(invisible(TRUE))
  }

  ref <- raster_bands[[1]]
  ref_name <- names(raster_bands)[1]
  ref_dim <- c(terra::nrow(ref), terra::ncol(ref))
  ref_ext <- terra::ext(ref)
  ref_crs <- terra::crs(ref)

  for (i in 2:length(raster_bands)) {
    curr <- raster_bands[[i]]
    curr_name <- names(raster_bands)[i]
    curr_dim <- c(terra::nrow(curr), terra::ncol(curr))

    if (!identical(ref_dim, curr_dim)) {
      stop(sprintf(
        "Dimension mismatch between band '%s' [%d x %d] and band '%s' [%d x %d].",
        ref_name, ref_dim[1], ref_dim[2], curr_name, curr_dim[1], curr_dim[2]
      ), call. = FALSE)
    }

    # Check extent
    if (!terra::compareGeom(ref, curr, stopOnError = FALSE, crs = FALSE)) {
      stop(sprintf(
        "Spatial geometry (extent or resolution) mismatch between band '%s' and band '%s'.",
        ref_name, curr_name
      ), call. = FALSE)
    }
  }

  invisible(TRUE)
}

#' Safe Division Preventing Zero-Division and Infinite Values
#'
#' Computes \code{numerator / denominator} while guaranteeing that whenever
#' \code{denominator == 0} or the result is non-finite (\code{Inf}, \code{-Inf}, \code{NaN}),
#' the output value is set to \code{NA}.
#'
#' @param num Numerator (\code{SpatRaster} or numeric).
#' @param den Denominator (\code{SpatRaster} or numeric).
#'
#' @return An object of the same class as inputs with values safely bounded and
#'   non-finite values replaced by \code{NA}.
#'
#' @keywords internal
safe_divide <- function(num, den) {
  if (inherits(num, "SpatRaster") || inherits(den, "SpatRaster")) {
    # terra safe division
    # Mask where denominator is 0
    zero_mask <- (den == 0)
    res <- num / den
    # Replace zeros in denominator and infinite values with NA
    res <- terra::ifel(zero_mask, NA, res)
    res <- terra::ifel(is.infinite(res), NA, res)
    return(res)
  } else {
    # numeric safe division
    zero_mask <- (den == 0)
    res <- num / den
    res[zero_mask | is.infinite(res)] <- NA
    return(res)
  }
}
