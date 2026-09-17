#' Compute All Eligible Spectral Indices Automatically
#'
#' Automatically detects which spectral indices can be computed given the available
#' bands in a \code{terra::SpatRaster} image and calculates all of them.
#'
#' @param image A \code{terra::SpatRaster} object containing multispectral bands.
#' @param bands Optional named vector or list specifying custom band mapping.
#' @param sensor Optional character string specifying a sensor preset.
#' @param quiet Logical. If \code{FALSE} (default), outputs an informative message
#'   listing which indices were detected and computed.
#' @param ... Additional parameters passed to index calculation functions.
#'
#' @return A multi-layer \code{terra::SpatRaster} containing all computable indices
#'   as individual layers.
#'
#' @examples
#' img <- get_example_data()
#'
#' # Compute all supported indices compatible with img bands
#' all_idx <- geo_index_all(img)
#' names(all_idx)
#'
#' @export
geo_index_all <- function(image, bands = NULL, sensor = NULL, quiet = FALSE, ...) {
  check_raster(image, "image")

  all_registered <- list_indices()
  eligible <- character(0)

  for (idx in all_registered) {
    meta <- get_index_meta(idx)
    can_resolve <- tryCatch({
      resolve_bands(
        image = image,
        required_bands = meta$required_bands,
        custom_mapping = bands,
        sensor = sensor,
        index_name = idx
      )
      TRUE
    }, error = function(e) FALSE)

    if (can_resolve) {
      eligible <- c(eligible, idx)
    }
  }

  if (length(eligible) == 0) {
    stop(
      sprintf(
        "No registered index could be computed with the available layers: %s.",
        paste(names(image), collapse = ", ")
      ),
      call. = FALSE
    )
  }

  if (!quiet) {
    message(sprintf("Computing %d compatible indices: %s",
                    length(eligible), paste(eligible, collapse = ", ")))
  }

  geo_indices(image = image, indices = eligible, bands = bands, sensor = sensor, ...)
}
