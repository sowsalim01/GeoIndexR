#' Compute a Custom Spectral or Geospatial Index
#'
#' Computes a custom spectral or geospatial index from a raster image or numeric
#' inputs using a user-defined mathematical formula. The formula is securely parsed,
#' validated against an AST whitelist of safe mathematical functions and operators,
#' and evaluated vectorially with \code{terra}.
#'
#' @param image A \code{terra::SpatRaster} object or a character string specifying
#'   the file path to a raster image on disk.
#' @param formula Character string specifying the mathematical expression to compute
#'   (e.g., \code{"(nir - red) / (nir + red)"} or
#'   \code{"G * (nir - red) / (nir + C1 * red - C2 * blue + L)"}).
#' @param bands Optional named vector or list specifying custom band mapping
#'   (e.g., \code{c(nir = 4, red = 3)} or \code{c(nir = "B08", red = "B04")}).
#' @param params Optional named list of numeric parameter constants used in the formula
#'   (e.g., \code{list(G = 2.5, C1 = 6.0, C2 = 7.5, L = 1.0)}).
#' @param name Character string specifying the name of the output index layer.
#'   Defaults to \code{"CustomIndex"}.
#' @param scale_factor Optional numeric scaling divisor (e.g., \code{10000} for
#'   Sentinel-2 or Landsat surface reflectance products) applied to input bands before
#'   evaluating the formula.
#' @param denominator_tolerance Numeric threshold for near-zero denominators.
#'   Divisions where the absolute denominator is smaller than this value are safely
#'   converted to \code{NA}. Defaults to \code{1e-6}.
#' @param sensor Optional character string specifying a sensor preset for automatic
#'   band name resolution (e.g., \code{"sentinel2"}, \code{"landsat8"}).
#' @param ... Additional named numeric constants passed directly to the formula evaluation.
#'
#' @return A single-layer \code{terra::SpatRaster} (or numeric object) containing
#'   the computed custom index values, preserving all original spatial properties.
#'
#' @examples
#' img <- get_example_data()
#'
#' # 1. Simple custom ratio index
#' custom_ratio <- geo_index_custom(
#'   img,
#'   formula = "(nir - red) / (nir + red)",
#'   bands = c(red = "red", nir = "nir"),
#'   name = "CustomNDVI"
#' )
#' print(custom_ratio)
#'
#' # 2. Custom parameterized index
#' custom_evi <- geo_index_custom(
#'   img,
#'   formula = "G * (nir - red) / (nir + C1 * red - C2 * blue + L)",
#'   bands = c(blue = "blue", red = "red", nir = "nir"),
#'   params = list(G = 2.5, C1 = 6.0, C2 = 7.5, L = 1.0),
#'   name = "CustomEVI"
#' )
#' print(custom_evi)
#'
#' @export
geo_index_custom <- function(image, formula, bands = NULL, params = list(),
                             name = "CustomIndex", scale_factor = NULL,
                             denominator_tolerance = 1e-6, sensor = NULL, ...) {
  # 1. Validate raster input or filepath
  image <- validate_raster_input(image, "image")

  if (missing(formula) || !is.character(formula) || length(formula) != 1 || !nzchar(trimws(formula))) {
    stop("Argument 'formula' must be a single non-empty character string.", call. = FALSE)
  }

  if (missing(name) || !is.character(name) || length(name) != 1 || !nzchar(trimws(name))) {
    name <- "CustomIndex"
  }

  # 2. Merge params and dots
  user_dots <- list(...)
  all_params <- as.list(params)
  for (arg_name in names(user_dots)) {
    all_params[[arg_name]] <- user_dots[[arg_name]]
  }

  # Validate params are numeric
  for (p in names(all_params)) {
    if (!is.numeric(all_params[[p]])) {
      stop(sprintf("Parameter '%s' must be numeric.", p), call. = FALSE)
    }
  }

  # 3. Determine candidate bands from custom_mapping, sensor preset, or raster layer names
  layer_names <- names(image)
  band_candidates <- unique(c(
    names(bands),
    layer_names,
    "blue", "green", "red", "nir", "nir2", "swir", "swir1", "swir2",
    "rededge", "rededge1", "rededge2", "rededge3", "thermal", "coastal"
  ))

  # 4. Parse and validate formula AST
  ast_meta <- parse_and_validate_formula(
    formula_str = formula,
    available_bands = band_candidates,
    param_names = names(all_params)
  )

  required_bands <- ast_meta$used_bands

  # 5. Resolve required bands from raster
  resolved_layers <- resolve_bands(
    image = image,
    required_bands = required_bands,
    custom_mapping = bands,
    sensor = sensor,
    index_name = name,
    scale_factor = scale_factor
  )

  # Check spatial compatibility
  check_spatial_compatibility(resolved_layers)

  # 6. Evaluate formula safely
  res <- evaluate_custom_formula(
    parsed_expr = ast_meta$parsed_expr,
    band_layers = resolved_layers,
    params = all_params,
    denominator_tolerance = denominator_tolerance
  )

  if (inherits(res, "SpatRaster")) {
    names(res) <- name
  }

  res
}
