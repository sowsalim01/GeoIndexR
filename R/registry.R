#' Spectral Indices Registry
#'
#' Provides the catalog and metadata of all spectral and geospatial indices
#' supported by `GeoIndexR`.
#'
#' @param category Optional character string filtering indices by category
#'   (e.g., `"vegetation"`, `"water"`, `"urban"`, `"soil"`, `"moisture"`).
#'   Defaults to `NULL` (returns all indices).
#'
#' @return A `data.frame` containing index metadata:
#'   \item{index}{Index code (e.g., `"NDVI"`).}
#'   \item{name}{Full descriptive name.}
#'   \item{category}{Category of the index.}
#'   \item{required_bands}{Comma-separated list of required standard band names.}
#'   \item{formula}{Mathematical formula in human-readable format.}
#'   \item{range}{Theoretical or expected value range.}
#'   \item{reference}{Key scientific reference citation.}
#'
#' @examples
#' # List all available indices
#' index_registry()
#'
#' # Filter by category
#' index_registry(category = "water")
#'
#' @export
index_registry <- function(category = NULL) {
  indices <- list(
    list(
      index = "NDVI",
      name = "Normalized Difference Vegetation Index",
      category = "vegetation",
      required_bands = c("nir", "red"),
      default_params = list(),
      formula = "(nir - red) / (nir + red)",
      range = "[-1, 1]",
      reference = "Rouse, J. W., et al. (1974). Monitoring the vernal advancement and retrogradation (Green wave effect) of natural vegetation. NASA/GSFC Type III Final Report."
    ),
    list(
      index = "SAVI",
      name = "Soil Adjusted Vegetation Index",
      category = "vegetation",
      required_bands = c("nir", "red"),
      default_params = list(L = 0.5),
      formula = "((nir - red) / (nir + red + L)) * (1 + L)",
      range = "[-1, 1]",
      reference = "Huete, A. R. (1988). A soil-adjusted vegetation index (SAVI). Remote Sensing of Environment, 25(3), 295-309."
    ),
    list(
      index = "EVI",
      name = "Enhanced Vegetation Index",
      category = "vegetation",
      required_bands = c("nir", "red", "blue"),
      default_params = list(G = 2.5, C1 = 6.0, C2 = 7.5, L = 1.0),
      formula = "G * (nir - red) / (nir + C1 * red - C2 * blue + L)",
      range = "[-1, 1]",
      reference = "Liu, H. Q., & Huete, A. (1995). A feedback based modification of the NDVI to minimize canopy background and atmospheric noise. IEEE TGRS, 33(2), 457-465."
    ),
    list(
      index = "GNDVI",
      name = "Green Normalized Difference Vegetation Index",
      category = "vegetation",
      required_bands = c("nir", "green"),
      default_params = list(),
      formula = "(nir - green) / (nir + green)",
      range = "[-1, 1]",
      reference = "Gitelson, A. A., et al. (1996). Use of a green channel in remote sensing of global vegetation from EOS-MODIS. Remote Sensing of Environment, 58(3), 289-298."
    ),
    list(
      index = "NDWI",
      name = "Normalized Difference Water Index",
      category = "water",
      required_bands = c("green", "nir"),
      default_params = list(),
      formula = "(green - nir) / (green + nir)",
      range = "[-1, 1]",
      reference = "McFeeters, S. K. (1996). The use of the Normalized Difference Water Index (NDWI) in the delineation of open water features. International Journal of Remote Sensing, 17(7), 1425-1432."
    ),
    list(
      index = "MNDWI",
      name = "Modified Normalized Difference Water Index",
      category = "water",
      required_bands = c("green", "swir"),
      default_params = list(),
      formula = "(green - swir) / (green + swir)",
      range = "[-1, 1]",
      reference = "Xu, H. (2006). Modification of normalised difference water index (NDWI) to enhance open water features in remotely sensed imagery. International Journal of Remote Sensing, 27(14), 3025-3033."
    ),
    list(
      index = "NDBI",
      name = "Normalized Difference Built-up Index",
      category = "urban",
      required_bands = c("swir", "nir"),
      default_params = list(),
      formula = "(swir - nir) / (swir + nir)",
      range = "[-1, 1]",
      reference = "Zha, Y., et al. (2003). Use of normalized difference built-up index in automatically mapping urban areas from TM imagery. International Journal of Remote Sensing, 24(3), 583-594."
    ),
    list(
      index = "NDMI",
      name = "Normalized Difference Moisture Index",
      category = "moisture",
      required_bands = c("nir", "swir"),
      default_params = list(),
      formula = "(nir - swir) / (nir + swir)",
      range = "[-1, 1]",
      reference = "Gao, B. C. (1996). NDWI—A normalized difference water index for remote sensing of vegetation liquid water from space. Remote Sensing of Environment, 58(3), 257-266."
    ),
    list(
      index = "BSI",
      name = "Bare Soil Index",
      category = "soil",
      required_bands = c("swir", "red", "nir", "blue"),
      default_params = list(),
      formula = "((swir + red) - (nir + blue)) / ((swir + red) + (nir + blue))",
      range = "[-1, 1]",
      reference = "Rikimaru, A., et al. (2002). Tropical forest cover density mapping. International Journal of Applied Earth Observation and Geoinformation, 4(1), 39-47."
    )
  )

  df <- data.frame(
    index = vapply(indices, function(x) x$index, character(1)),
    name = vapply(indices, function(x) x$name, character(1)),
    category = vapply(indices, function(x) x$category, character(1)),
    required_bands = vapply(indices, function(x) paste(x$required_bands, collapse = ", "), character(1)),
    formula = vapply(indices, function(x) x$formula, character(1)),
    range = vapply(indices, function(x) x$range, character(1)),
    reference = vapply(indices, function(x) x$reference, character(1)),
    stringsAsFactors = FALSE
  )

  if (!is.null(category)) {
    category_lower <- tolower(trimws(category))
    valid_cats <- unique(df$category)
    if (!category_lower %in% valid_cats) {
      warning(
        sprintf("Unknown category '%s'. Available categories: %s",
                category, paste(valid_cats, collapse = ", ")),
        call. = FALSE
      )
    }
    df <- df[df$category == category_lower, , drop = FALSE]
  }

  rownames(df) <- NULL
  df
}

#' Get Metadata for a Single Spectral Index
#'
#' Retrieves complete metadata and default parameters for a specified index.
#'
#' @param index Character string specifying the index code (case-insensitive,
#'   e.g. `"ndvi"` or `"NDVI"`).
#'
#' @return A list containing the index attributes (`index`, `name`, `category`,
#'   `required_bands`, `default_params`, `formula`, `range`, `reference`).
#'
#' @keywords internal
get_index_meta <- function(index) {
  if (missing(index) || length(index) != 1 || !is.character(index)) {
    stop("'index' must be a single character string.", call. = FALSE)
  }

  all_indices <- list(
    NDVI = list(
      index = "NDVI",
      name = "Normalized Difference Vegetation Index",
      category = "vegetation",
      required_bands = c("nir", "red"),
      default_params = list(),
      formula = "(nir - red) / (nir + red)",
      range = "[-1, 1]",
      reference = "Rouse et al. (1974)"
    ),
    SAVI = list(
      index = "SAVI",
      name = "Soil Adjusted Vegetation Index",
      category = "vegetation",
      required_bands = c("nir", "red"),
      default_params = list(L = 0.5),
      formula = "((nir - red) / (nir + red + L)) * (1 + L)",
      range = "[-1, 1]",
      reference = "Huete (1988)"
    ),
    EVI = list(
      index = "EVI",
      name = "Enhanced Vegetation Index",
      category = "vegetation",
      required_bands = c("nir", "red", "blue"),
      default_params = list(G = 2.5, C1 = 6.0, C2 = 7.5, L = 1.0),
      formula = "G * (nir - red) / (nir + C1 * red - C2 * blue + L)",
      range = "[-1, 1]",
      reference = "Liu & Huete (1995)"
    ),
    GNDVI = list(
      index = "GNDVI",
      name = "Green Normalized Difference Vegetation Index",
      category = "vegetation",
      required_bands = c("nir", "green"),
      default_params = list(),
      formula = "(nir - green) / (nir + green)",
      range = "[-1, 1]",
      reference = "Gitelson et al. (1996)"
    ),
    NDWI = list(
      index = "NDWI",
      name = "Normalized Difference Water Index",
      category = "water",
      required_bands = c("green", "nir"),
      default_params = list(),
      formula = "(green - nir) / (green + nir)",
      range = "[-1, 1]",
      reference = "McFeeters (1996)"
    ),
    MNDWI = list(
      index = "MNDWI",
      name = "Modified Normalized Difference Water Index",
      category = "water",
      required_bands = c("green", "swir"),
      default_params = list(),
      formula = "(green - swir) / (green + swir)",
      range = "[-1, 1]",
      reference = "Xu (2006)"
    ),
    NDBI = list(
      index = "NDBI",
      name = "Normalized Difference Built-up Index",
      category = "urban",
      required_bands = c("swir", "nir"),
      default_params = list(),
      formula = "(swir - nir) / (swir + nir)",
      range = "[-1, 1]",
      reference = "Zha et al. (2003)"
    ),
    NDMI = list(
      index = "NDMI",
      name = "Normalized Difference Moisture Index",
      category = "moisture",
      required_bands = c("nir", "swir"),
      default_params = list(),
      formula = "(nir - swir) / (nir + swir)",
      range = "[-1, 1]",
      reference = "Gao (1996)"
    ),
    BSI = list(
      index = "BSI",
      name = "Bare Soil Index",
      category = "soil",
      required_bands = c("swir", "red", "nir", "blue"),
      default_params = list(),
      formula = "((swir + red) - (nir + blue)) / ((swir + red) + (nir + blue))",
      range = "[-1, 1]",
      reference = "Rikimaru et al. (2002)"
    )
  )

  key <- toupper(trimws(index))
  if (!key %in% names(all_indices)) {
    avail <- paste(names(all_indices), collapse = ", ")
    stop(
      sprintf("Unknown index '%s'. Available indices: %s.", index, avail),
      call. = FALSE
    )
  }

  all_indices[[key]]
}

#' List Available Index Names
#'
#' Returns a character vector of all supported spectral index codes.
#'
#' @param category Optional category filter.
#'
#' @return Character vector of index names (e.g. `c("NDVI", "SAVI", ...)`).
#'
#' @examples
#' list_indices()
#' list_indices("vegetation")
#'
#' @export
list_indices <- function(category = NULL) {
  reg <- index_registry(category = category)
  reg$index
}
