#' Visualize a Spectral Index with Thematic Color Palettes
#'
#' Plots a single-layer or selected layer from a \code{terra::SpatRaster} index object
#' using tailored color palettes designed for vegetation, water, soil, and urban analysis.
#'
#' @param x A \code{terra::SpatRaster} object containing index values.
#' @param index Optional character string specifying which layer to plot if \code{x}
#'   contains multiple layers.
#' @param main Optional plot title. Defaults to the layer name.
#' @param col Optional color palette. If \code{NULL} (default), an appropriate palette
#'   is automatically chosen based on the index category.
#' @param ... Additional graphical arguments passed to \code{terra::plot}.
#'
#' @return Invisible \code{terra::SpatRaster} object that was plotted.
#'
#' @examples
#' img <- get_example_data()
#' ndvi <- geo_index(img, "NDVI")
#' plot_index(ndvi)
#'
#' @export
plot_index <- function(x, index = NULL, main = NULL, col = NULL, ...) {
  check_raster(x, "x")

  # Select layer
  target <- if (!is.null(index)) {
    if (!index %in% names(x)) {
      stop(sprintf("Layer '%s' not found in raster. Available layers: %s.",
                   index, paste(names(x), collapse = ", ")), call. = FALSE)
    }
    x[[index]]
  } else if (terra::nlyr(x) == 1) {
    x
  } else {
    # Default to first layer if multi-layer and index not specified
    message(sprintf("Multiple layers found. Plotting first layer: '%s'.", names(x)[1]))
    x[[1]]
  }

  lyr_name <- toupper(names(target)[1])
  if (is.null(main)) {
    main <- lyr_name
  }

  if (is.null(col)) {
    # Auto-detect category
    cat_lookup <- tryCatch(get_index_meta(lyr_name)$category, error = function(e) "generic")

    col <- switch(
      cat_lookup,
      vegetation = grDevices::colorRampPalette(
        c("#8c510a", "#d8b365", "#f6e8c3", "#c7eae5", "#5ab4ac", "#01665e")
      )(100),
      water = grDevices::colorRampPalette(
        c("#f7fbff", "#deebf7", "#9ecae1", "#4292c6", "#08519c", "#08306b")
      )(100),
      urban = grDevices::colorRampPalette(
        c("#f7f7f7", "#cccccc", "#ef6548", "#cc4c02", "#8c2d04")
      )(100),
      soil = grDevices::colorRampPalette(
        c("#f7f7f7", "#fee8c8", "#fdbb84", "#e34a33", "#b30000")
      )(100),
      moisture = grDevices::colorRampPalette(
        c("#ffffcc", "#a1dab4", "#41b6c4", "#2c7fb8", "#253494")
      )(100),
      grDevices::terrain.colors(100)
    )
  }

  terra::plot(target, col = col, main = main, ...)
  invisible(target)
}
