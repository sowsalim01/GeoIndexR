#' Example Multispectral Raster Dataset
#'
#' A small synthetic multispectral raster designed for fast, reproducible examples
#' and automated unit testing without downloading large satellite scenes.
#'
#' Contains 6 spectral bands:
#' \itemize{
#'   \item \code{blue}: Blue band (0.45 - 0.51 um)
#'   \item \code{green}: Green band (0.53 - 0.59 um)
#'   \item \code{red}: Red band (0.64 - 0.67 um)
#'   \item \code{nir}: Near-infrared band (0.85 - 0.88 um)
#'   \item \code{swir1}: Short-wave infrared 1 (1.57 - 1.65 um)
#'   \item \code{swir2}: Short-wave infrared 2 (2.11 - 2.29 um)
#' }
#' Dimensions: 10 x 10 pixels (100 m x 100 m extent), UTM 31N projection (EPSG:32631).
#' Reflectance values range from 0 to 1.
#'
#' @format A packed \code{terra} raster object (\code{PackedSpatRaster}) stored in RDA format.
#'   Use \code{\link{get_example_data}} to obtain the unpacked \code{SpatRaster}.
#' @source Synthetically generated for package demonstrations.
#' @name example_multispectral_packed
"example_multispectral_packed"

#' Get Example Multispectral SpatRaster
#'
#' Returns the ready-to-use unpacked \code{terra::SpatRaster} representing the
#' bundled 6-band example dataset.
#'
#' @return A \code{terra::SpatRaster} with 6 layers: \code{"blue"}, \code{"green"},
#'   \code{"red"}, \code{"nir"}, \code{"swir1"}, \code{"swir2"}.
#'
#' @examples
#' img <- get_example_data()
#' print(img)
#' terra::nlyr(img)
#'
#' @export
get_example_data <- function() {
  # 1. Direct variable access if LazyData is active
  if (exists("example_multispectral_packed", envir = asNamespace("GeoIndexR"), inherits = FALSE)) {
    packed <- get("example_multispectral_packed", envir = asNamespace("GeoIndexR"))
    return(terra::unwrap(packed))
  }

  # 2. Check installed package data or source data
  candidates <- c(
    system.file("data", "example_multispectral.rda", package = "GeoIndexR"),
    file.path("data", "example_multispectral.rda"),
    file.path("..", "data", "example_multispectral.rda")
  )
  for (cand in candidates) {
    if (nzchar(cand) && file.exists(cand)) {
      env <- new.env(parent = emptyenv())
      load(cand, envir = env)
      if (exists("example_multispectral_packed", envir = env)) {
        return(terra::unwrap(env$example_multispectral_packed))
      }
    }
  }

  # 3. Fallback to utils::data
  env <- new.env(parent = emptyenv())
  tryCatch(
    utils::data("example_multispectral_packed", package = "GeoIndexR", envir = env),
    error = function(e) NULL
  )
  if (exists("example_multispectral_packed", envir = env)) {
    return(terra::unwrap(env$example_multispectral_packed))
  }

  stop("Example dataset 'example_multispectral_packed' could not be found.", call. = FALSE)
}
