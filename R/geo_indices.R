#' Compute Multiple Spectral Indices from Multispectral Raster Data
#'
#' Computes a collection of spectral indices from a multispectral \code{terra::SpatRaster}
#' and returns the results stacked into a multi-layer \code{SpatRaster}.
#'
#' @param image A \code{terra::SpatRaster} object containing multispectral bands.
#' @param indices Character vector of index codes to compute (e.g.,
#'   \code{c("NDVI", "NDWI", "NDBI", "NDMI")}).
#' @param bands Optional named vector or list specifying custom band mapping.
#' @param sensor Optional character string specifying a sensor preset.
#' @param ... Additional parameters passed to index calculation functions.
#'
#' @return A multi-layer \code{terra::SpatRaster} where each layer corresponds to
#'   one computed index, named accordingly.
#'
#' @examples
#' img <- get_example_data()
#'
#' # Compute NDVI, NDWI and MNDWI simultaneously
#' stack <- geo_indices(img, c("NDVI", "NDWI", "MNDWI"))
#' print(stack)
#' names(stack)
#'
#' @export
geo_indices <- function(image, indices, bands = NULL, sensor = NULL, ...) {
  check_raster(image, "image")

  if (missing(indices) || length(indices) == 0 || !is.character(indices)) {
    stop("Argument 'indices' must be a non-empty character vector of index codes.", call. = FALSE)
  }

  results <- list()
  for (idx in indices) {
    res <- geo_index(
      image = image,
      index = idx,
      bands = bands,
      sensor = sensor,
      ...
    )
    results[[names(res)]] <- res
  }

  stacked <- terra::rast(results)
  names(stacked) <- names(results)
  stacked
}
