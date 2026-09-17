#' Compute a Spectral Index from Multispectral Raster Data
#'
#' Calculates a specified spectral or geospatial index from a \code{terra::SpatRaster}
#' object or a raster file path. Band names are automatically resolved using heuristic
#' matching, sensor presets, or explicit user mapping.
#'
#' @param image A \code{terra::SpatRaster} object or a character string specifying the
#'   file path to a raster image on disk.
#' @param index Character string specifying the index to compute (case-insensitive,
#'   e.g., \code{"NDVI"}, \code{"SAVI"}, \code{"EVI"}, \code{"NDWI"}, etc.).
#'   See \code{\link{list_indices}} or \code{\link{index_registry}} for supported indices.
#' @param bands Optional named vector or list specifying custom band mapping
#'   (e.g., \code{c(nir = "B08", red = "B04")} or \code{c(nir = 4, red = 3)}).
#' @param scale_factor Optional numeric scaling divisor (e.g., \code{10000} for
#'   Sentinel-2 L2A or Landsat surface reflectance) to convert integer Digital Numbers
#'   into physical reflectance \code{[0, 1]}.
#' @param sensor Optional character string specifying a sensor preset for automatic
#'   band name resolution (e.g., \code{"sentinel2"}, \code{"landsat8"}, \code{"landsat9"}).
#' @param ... Additional parameters passed to the index calculation function
#'   (e.g., soil adjustment factor \code{L} for SAVI, or gain factor \code{G} for EVI).
#'
#' @return A single-layer \code{terra::SpatRaster} object containing the computed
#'   index values, with layer name set to the uppercase index code, preserving all
#'   original spatial properties (CRS, resolution, extent, dimensions).
#'
#' @examples
#' img <- get_example_data()
#'
#' # 1. Compute NDVI
#' ndvi <- geo_index(img, "NDVI")
#' print(ndvi)
#'
#' # 2. Compute SAVI with custom parameter
#' savi <- geo_index(img, "SAVI", L = 0.5)
#'
#' # 3. Compute EVI with scale factor for raw DN values
#' evi <- geo_index(img, "EVI", scale_factor = 1)
#'
#' @export
geo_index <- function(image, index, bands = NULL, scale_factor = NULL, sensor = NULL, ...) {
  image <- validate_raster_input(image, "image")

  if (missing(index) || length(index) != 1 || !is.character(index) || !nzchar(trimws(index))) {
    stop("Argument 'index' must be a single character string.", call. = FALSE)
  }

  meta <- get_index_meta(index)
  index_code <- meta$index

  # Resolve required bands from raster
  resolved_layers <- resolve_bands(
    image = image,
    required_bands = meta$required_bands,
    custom_mapping = bands,
    sensor = sensor,
    index_name = index_code,
    scale_factor = scale_factor
  )

  # Check if index is scale-sensitive and input values might be unscaled DNs
  if (is.null(scale_factor) && isTRUE(meta$scale_sensitive)) {
    # Check sample/minmax of first band
    b1 <- resolved_layers[[1]]
    mm <- tryCatch(terra::minmax(b1), error = function(e) matrix(c(0, 0), nrow = 2))
    max_val <- mm[2, 1]
    if (!is.na(max_val) && max_val > 10) {
      message(
        sprintf(
          "Notice: Index '%s' is scale-sensitive (requires reflectance in [0, 1]), but input band values exceed 10 (max = %.1f).\nIf this is raw/scaled satellite imagery (e.g. Sentinel-2 / Landsat DN), consider supplying 'scale_factor = 10000'.",
          index_code, max_val
        )
      )
    }
  }

  # Merge resolved layers with extra params and defaults
  call_args <- meta$default_params
  user_dots <- list(...)
  for (arg_name in names(user_dots)) {
    call_args[[arg_name]] <- user_dots[[arg_name]]
  }
  for (b in names(resolved_layers)) {
    call_args[[b]] <- resolved_layers[[b]]
  }

  fn_name <- paste0("calc_", tolower(index_code))
  fn <- get(fn_name, mode = "function", envir = asNamespace("GeoIndexR"))

  res <- do.call(fn, call_args)
  if (inherits(res, "SpatRaster")) {
    names(res) <- index_code
  }
  res
}
