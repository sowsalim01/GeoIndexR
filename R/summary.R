#' Summary Statistics for Spectral Indices
#'
#' Computes descriptive statistics for one or multiple spectral index layers in a
#' \code{terra::SpatRaster} object, including min, max, mean, median, standard deviation,
#' and NA percentage.
#'
#' @param x A \code{terra::SpatRaster} object containing one or more index layers.
#' @param digits Integer indicating the number of decimal places to round results.
#'   Defaults to \code{4}.
#'
#' @return A \code{data.frame} with one row per layer:
#'   \item{index}{Layer/index name.}
#'   \item{min}{Minimum index value.}
#'   \item{max}{Maximum index value.}
#'   \item{mean}{Mean index value.}
#'   \item{median}{Median index value.}
#'   \item{sd}{Standard deviation.}
#'   \item{na_pct}{Percentage of NA values (0 to 100).}
#'   \item{total_cells}{Total number of raster cells.}
#'
#' @examples
#' img <- get_example_data()
#' ndvi <- geo_index(img, "NDVI")
#' index_summary(ndvi)
#'
#' # Multi-layer summary
#' stack <- geo_indices(img, c("NDVI", "NDWI", "NDBI"))
#' index_summary(stack)
#'
#' @export
index_summary <- function(x, digits = 4) {
  check_raster(x, "x")

  n_lyrs <- terra::nlyr(x)
  lyr_names <- names(x)
  total_cells <- terra::ncell(x)

  res_list <- vector("list", n_lyrs)

  for (i in seq_len(n_lyrs)) {
    vals <- terra::values(x[[i]], mat = FALSE)
    n_na <- sum(is.na(vals))
    na_pct <- round((n_na / total_cells) * 100, 2)
    clean_vals <- vals[!is.na(vals)]

    if (length(clean_vals) == 0) {
      res_list[[i]] <- data.frame(
        index = lyr_names[i],
        min = NA_real_,
        max = NA_real_,
        mean = NA_real_,
        median = NA_real_,
        sd = NA_real_,
        na_pct = na_pct,
        total_cells = total_cells,
        stringsAsFactors = FALSE
      )
    } else {
      res_list[[i]] <- data.frame(
        index = lyr_names[i],
        min = round(min(clean_vals), digits),
        max = round(max(clean_vals), digits),
        mean = round(mean(clean_vals), digits),
        median = round(stats::median(clean_vals), digits),
        sd = round(stats::sd(clean_vals), digits),
        na_pct = na_pct,
        total_cells = total_cells,
        stringsAsFactors = FALSE
      )
    }
  }

  out <- do.call(rbind, res_list)
  rownames(out) <- NULL
  class(out) <- c("geo_index_summary", "data.frame")
  out
}

#' @export
print.geo_index_summary <- function(x, ...) {
  cat("\n=== GeoIndexR Spectral Summary ===\n\n")
  print.data.frame(x, row.names = FALSE)
  cat("\n")
  invisible(x)
}
