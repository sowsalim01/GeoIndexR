#' Validate Raster Input or Filepath
#'
#' Verifies that the provided input is either a valid \code{terra::SpatRaster}
#' object or a valid file path pointing to an existing raster file on disk.
#' If a file path is provided, it is automatically loaded as a \code{SpatRaster}.
#'
#' @param x An object or file path to check.
#' @param arg_name Character string specifying the argument name for error messages.
#'
#' @return A \code{terra::SpatRaster} object.
#'
#' @keywords internal
validate_raster_input <- function(x, arg_name = "image") {
  if (is.character(x)) {
    if (length(x) != 1 || !nzchar(x)) {
      stop(sprintf("Argument '%s' must be a single non-empty file path or a SpatRaster.", arg_name),
           call. = FALSE)
    }
    if (!file.exists(x)) {
      stop(sprintf("Raster file '%s' specified in '%s' does not exist.", x, arg_name),
           call. = FALSE)
    }
    r <- tryCatch(
      terra::rast(x),
      error = function(e) {
        stop(sprintf("Failed to read raster file '%s': %s", x, e$message), call. = FALSE)
      }
    )
    return(r)
  }

  if (!inherits(x, "SpatRaster")) {
    stop(sprintf("Argument '%s' must be a SpatRaster or a valid raster file path, but received class '%s'.",
                 arg_name, class(x)[1]), call. = FALSE)
  }

  if (terra::nlyr(x) == 0) {
    stop(sprintf("Argument '%s' contains an empty SpatRaster (0 layers).", arg_name),
         call. = FALSE)
  }

  x
}

#' Check that an object is a SpatRaster
#'
#' @param x Object to check.
#' @param arg_name Name of the argument in the calling function.
#'
#' @return Invisible \code{TRUE} if valid; throws an error otherwise.
#'
#' @keywords internal
check_raster <- function(x, arg_name = "image") {
  if (!inherits(x, "SpatRaster")) {
    stop(sprintf("Argument '%s' must be a SpatRaster or valid file path, but received class '%s'.",
                 arg_name, class(x)[1]), call. = FALSE)
  }
  if (terra::nlyr(x) == 0) {
    stop(sprintf("Argument '%s' contains an empty SpatRaster (0 layers).", arg_name),
         call. = FALSE)
  }
  invisible(TRUE)
}

#' Check that an object is numeric or SpatRaster
#'
#' @param x Object to check.
#' @param arg_name Name of argument.
#'
#' @return Invisible \code{TRUE} if valid; throws error otherwise.
#'
#' @keywords internal
check_numeric_or_raster <- function(x, arg_name = "band") {
  if (!is.numeric(x) && !inherits(x, "SpatRaster")) {
    stop(sprintf("Argument '%s' must be numeric or a SpatRaster.", arg_name),
         call. = FALSE)
  }
  invisible(TRUE)
}

#' Check Spatial Compatibility Across Raster Bands
#'
#' Validates that a list of \code{terra::SpatRaster} objects share identical geometry,
#' CRS, and dimensions before computing pixel-wise operations.
#'
#' @param band_list Named list of \code{SpatRaster} or numeric objects.
#'
#' @return Invisible \code{TRUE} if all raster inputs are compatible.
#'
#' @keywords internal
check_spatial_compatibility <- function(band_list) {
  rasters <- band_list[vapply(band_list, inherits, logical(1), "SpatRaster")]
  if (length(rasters) <= 1) return(invisible(TRUE))

  ref <- rasters[[1]]
  ref_name <- names(rasters)[1]
  ref_crs <- terra::crs(ref)

  for (i in 2:length(rasters)) {
    curr <- rasters[[i]]
    curr_name <- names(rasters)[i]

    # Check dimensions
    if (terra::nrow(ref) != terra::nrow(curr) || terra::ncol(ref) != terra::ncol(curr)) {
      stop(
        sprintf(
          "Dimension mismatch between bands '%s' (%dx%d) and '%s' (%dx%d).",
          ref_name, terra::nrow(ref), terra::ncol(ref),
          curr_name, terra::nrow(curr), terra::ncol(curr)
        ),
        call. = FALSE
      )
    }

    # Compare geometry (extent, resolution)
    if (!terra::compareGeom(ref, curr, stopOnError = FALSE, crs = FALSE)) {
      stop(
        sprintf(
          "Spatial geometry (extent or resolution) mismatch between bands '%s' and '%s'.",
          ref_name, curr_name
        ),
        call. = FALSE
      )
    }

    # Compare CRS if defined
    curr_crs <- terra::crs(curr)
    if (nzchar(ref_crs) && nzchar(curr_crs) && ref_crs != curr_crs) {
      warning(
        sprintf("CRS difference detected between '%s' and '%s'. Calculation may yield unintended alignment.",
                ref_name, curr_name),
        call. = FALSE
      )
    }
  }

  invisible(TRUE)
}

#' Safe Division Function Handling Zeros, Singularity, and Non-Finite Values
#'
#' Performs division with protection against division by zero, near-zero denominator
#' singularities ($|den| < tol$), and non-finite values (\code{Inf}, \code{-Inf}, \code{NaN}),
#' replacing invalid results with \code{NA}.
#'
#' @param num Numerator (\code{SpatRaster} or numeric).
#' @param den Denominator (\code{SpatRaster} or numeric).
#' @param tol Singularity tolerance threshold. Values with $|den| < tol$ are safely
#'   converted to \code{NA}. Defaults to \code{1e-6}.
#'
#' @return An object of the same class as inputs with values safely bounded and
#'   non-finite values replaced by \code{NA}.
#'
#' @keywords internal
safe_divide <- function(num, den, tol = 1e-6) {
  if (inherits(num, "SpatRaster") || inherits(den, "SpatRaster")) {
    # terra safe division
    invalid_mask <- (abs(den) < tol) | is.na(den) | is.na(num)
    res <- num / den
    res <- terra::ifel(invalid_mask, NA, res)
    res <- terra::ifel(is.infinite(res) | is.nan(res), NA, res)
    return(res)
  } else {
    # numeric safe division
    invalid_mask <- (abs(den) < tol) | is.na(den) | is.na(num)
    res <- num / den
    res[invalid_mask | is.infinite(res) | is.nan(res)] <- NA
    return(res)
  }
}
