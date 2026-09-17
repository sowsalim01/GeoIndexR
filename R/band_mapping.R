#' Sensor Band Mapping Presets
#'
#' Provides standard band name mappings for commonly used multispectral sensors
#' and generic naming conventions.
#'
#' @param sensor Character string specifying the sensor preset. Supported options:
#'   \itemize{
#'     \item \code{"generic"}: Common names (\code{blue}, \code{green}, \code{red},
#'       \code{nir}, \code{swir}, \code{swir1}, \code{swir2}, \code{rededge}).
#'     \item \code{"sentinel2"} or \code{"s2"}: Sentinel-2 MSI bands (\code{B02}, \code{B03},
#'       \code{B04}, \code{B08}, \code{B11}, \code{B12}, etc.).
#'     \item \code{"landsat8"} / \code{"landsat9"} or \code{"l8"} / \code{"l9"}: Landsat 8/9 OLI bands
#'       (\code{B1} to \code{B7}).
#'     \item \code{"landsat7"} / \code{"landsat5"} or \code{"etm"} / \code{"tm"}: Landsat 4-7 TM/ETM+
#'       bands (\code{B1} to \code{B7}).
#'   }
#'   Defaults to \code{"generic"}.
#'
#' @return A named character vector where names represent standardized spectral
#'   band roles (e.g., \code{"nir"}, \code{"red"}) and values represent corresponding
#'   band or layer names for the selected sensor.
#'
#' @examples
#' # Generic mapping
#' band_mapping("generic")
#'
#' # Sentinel-2 band mapping
#' band_mapping("sentinel2")
#'
#' # Landsat 8/9 band mapping
#' band_mapping("landsat8")
#'
#' @export
band_mapping <- function(sensor = c("generic", "sentinel2", "s2",
                                    "landsat8", "landsat9", "l8", "l9",
                                    "landsat7", "landsat5", "tm", "etm")) {
  sensor <- match.arg(tolower(sensor[1]),
                      c("generic", "sentinel2", "s2",
                        "landsat8", "landsat9", "l8", "l9",
                        "landsat7", "landsat5", "tm", "etm"))

  if (sensor %in% c("sentinel2", "s2")) {
    c(
      coastal = "B01",
      blue = "B02",
      green = "B03",
      red = "B04",
      rededge1 = "B05",
      rededge2 = "B06",
      rededge3 = "B07",
      nir = "B08",
      rededge4 = "B8A",
      watervapor = "B09",
      cirrus = "B10",
      swir1 = "B11",
      swir2 = "B12",
      swir = "B11"
    )
  } else if (sensor %in% c("landsat8", "landsat9", "l8", "l9")) {
    c(
      coastal = "B1",
      blue = "B2",
      green = "B3",
      red = "B4",
      nir = "B5",
      swir1 = "B6",
      swir2 = "B7",
      pan = "B8",
      cirrus = "B9",
      swir = "B6"
    )
  } else if (sensor %in% c("landsat7", "landsat5", "tm", "etm")) {
    c(
      blue = "B1",
      green = "B2",
      red = "B3",
      nir = "B4",
      swir1 = "B5",
      thermal = "B6",
      swir2 = "B7",
      swir = "B5"
    )
  } else {
    c(
      blue = "blue",
      green = "green",
      red = "red",
      nir = "nir",
      swir = "swir",
      swir1 = "swir1",
      swir2 = "swir2",
      rededge = "rededge"
    )
  }
}

#' Resolve Bands in a SpatRaster Object
#'
#' Matches required band roles (e.g., \code{"nir"}, \code{"red"}) against the layers
#' of a \code{terra::SpatRaster} using custom user mapping, sensor presets, or
#' heuristic name aliases.
#'
#' @param image A \code{terra::SpatRaster} object.
#' @param required_bands Character vector of required standardized band names.
#' @param custom_mapping Optional named vector or list mapping required names
#'   to layer names or layer indices in \code{image}.
#' @param sensor Optional character string for sensor presets.
#' @param index_name Optional character string of the index being calculated (for
#'   error reporting).
#'
#' @return A named list of single-layer \code{terra::SpatRaster} objects.
#'
#' @keywords internal
resolve_bands <- function(image, required_bands, custom_mapping = NULL,
                          sensor = NULL, index_name = "Index") {
  if (!inherits(image, "SpatRaster")) {
    stop(sprintf("Expected a 'SpatRaster' object for '%s', but received '%s'.",
                 "image", class(image)[1]), call. = FALSE)
  }

  layer_names <- names(image)
  n_layers <- terra::nlyr(image)
  resolved <- list()
  missing_bands <- character(0)

  # Prepare lookup dictionary from sensor if specified
  sensor_map <- if (!is.null(sensor)) {
    tryCatch(band_mapping(sensor), error = function(e) character(0))
  } else {
    character(0)
  }

  # Common heuristic alias dictionary for fallback
  alias_dict <- list(
    blue = c("blue", "b02", "b2", "b_02", "b_2"),
    green = c("green", "b03", "b3", "b_03", "b_3"),
    red = c("red", "b04", "b4", "b_04", "b_4"),
    nir = c("nir", "b08", "b8", "b8a", "b08a", "b5", "b_08", "b_8", "b_5"),
    swir = c("swir", "swir1", "swir2", "b11", "b6", "b12", "b7", "b_11", "b_6"),
    swir1 = c("swir1", "swir", "b11", "b6", "b_11", "b_6"),
    swir2 = c("swir2", "b12", "b7", "b_12", "b_7"),
    rededge = c("rededge", "rededge1", "b05", "b5")
  )

  for (band in required_bands) {
    band_std <- tolower(trimws(band))
    found_layer <- NULL

    # 1. Check custom_mapping
    if (!is.null(custom_mapping)) {
      # Match by name in custom_mapping
      m_idx <- which(tolower(names(custom_mapping)) == band_std)
      if (length(m_idx) > 0) {
        val <- custom_mapping[[m_idx[1]]]
        if (is.numeric(val)) {
          if (val >= 1 && val <= n_layers) {
            found_layer <- image[[val]]
          }
        } else if (is.character(val)) {
          idx <- which(tolower(layer_names) == tolower(val))
          if (length(idx) > 0) {
            found_layer <- image[[idx[1]]]
          }
        }
      }
    }

    # 2. Check sensor preset if not yet found
    if (is.null(found_layer) && length(sensor_map) > 0) {
      if (band_std %in% names(sensor_map)) {
        target_name <- sensor_map[[band_std]]
        idx <- which(tolower(layer_names) == tolower(target_name))
        if (length(idx) > 0) {
          found_layer <- image[[idx[1]]]
        }
      }
    }

    # 3. Direct exact case-insensitive match in layer names
    if (is.null(found_layer)) {
      idx <- which(tolower(layer_names) == band_std)
      if (length(idx) > 0) {
        found_layer <- image[[idx[1]]]
      }
    }

    # 4. Fallback: heuristic aliases
    if (is.null(found_layer) && band_std %in% names(alias_dict)) {
      candidates <- alias_dict[[band_std]]
      for (cand in candidates) {
        idx <- which(tolower(layer_names) == cand)
        if (length(idx) > 0) {
          found_layer <- image[[idx[1]]]
          break
        }
      }
    }

    if (!is.null(found_layer)) {
      resolved[[band_std]] <- found_layer
    } else {
      missing_bands <- c(missing_bands, band)
    }
  }

  if (length(missing_bands) > 0) {
    stop(
      sprintf(
        "\nIndex '%s' requires the following bands:\n  %s\nAvailable layers in raster:\n  %s\nMissing band(s):\n  %s",
        index_name,
        paste(required_bands, collapse = ", "),
        if (length(layer_names) > 0) paste(layer_names, collapse = ", ") else "(unnamed layers)",
        paste(missing_bands, collapse = ", ")
      ),
      call. = FALSE
    )
  }

  resolved
}
