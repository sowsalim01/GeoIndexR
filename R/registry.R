#' Central Registry of Spectral and Geospatial Indices
#'
#' Retrieves metadata for all built-in spectral indices or a specific index by name
#' or category. Metadata includes mathematical formulas, required spectral bands,
#' parameter defaults, purpose, interpretation guidelines, limitations, scale sensitivity,
#' and scientific literature references.
#'
#' @param category Optional character string to filter indices by category
#'   (e.g., \code{"vegetation"}, \code{"water"}, \code{"urban"}, \code{"soil"}, \code{"moisture"}, \code{"snow"}).
#'
#' @return A \code{data.frame} containing the registry of supported indices and their metadata.
#'
#' @examples
#' # View all indices
#' reg <- index_registry()
#' reg[, c("index", "name", "category")]
#'
#' # View vegetation indices only
#' veg_reg <- index_registry(category = "vegetation")
#' veg_reg$index
#'
#' @export
index_registry <- function(category = NULL) {
  indices <- list(
    # --- VEGETATION INDICES ---
    list(
      index = "NDVI",
      name = "Normalized Difference Vegetation Index",
      category = "vegetation",
      purpose = "Vegetation greenness, biomass, and vigor monitoring.",
      description = "Measures chlorophyll absorption in red vs scattering in near-infrared.",
      interpretation = "Higher values (> 0.3) represent green, healthy vegetation. Dense canopies reach 0.6-0.9. Bare soils are near 0.1-0.2. Water is negative.",
      limitations = "Saturates over dense, closed-canopy vegetation; sensitive to soil background at low vegetation cover.",
      requires_reflectance = FALSE,
      scale_sensitive = FALSE,
      valid_range = c(-1.0, 1.0),
      required_bands = c("nir", "red"),
      default_params = list(),
      formula = "(nir - red) / (nir + red)",
      reference = "Rouse et al. (1974)"
    ),
    list(
      index = "SAVI",
      name = "Soil Adjusted Vegetation Index",
      category = "vegetation",
      purpose = "Vegetation monitoring in arid, semiarid, or sparse canopy regions.",
      description = "Applies a soil-adjustment factor L to suppress soil background brightness.",
      interpretation = "Ranges typically from -1 to 1. Higher values indicate more vegetation canopy. L = 0.5 is standard for intermediate vegetation cover.",
      limitations = "Requires estimating or fixing the soil line adjustment factor L.",
      requires_reflectance = TRUE,
      scale_sensitive = TRUE,
      valid_range = c(-1.5, 1.5),
      required_bands = c("nir", "red"),
      default_params = list(L = 0.5),
      formula = "((nir - red) / (nir + red + L)) * (1 + L)",
      reference = "Huete (1988)"
    ),
    list(
      index = "EVI",
      name = "Enhanced Vegetation Index",
      category = "vegetation",
      purpose = "High biomass vegetation monitoring with reduced atmospheric and canopy background noise.",
      description = "Incorporates the blue band to correct for aerosol scattering and background canopy reflectance.",
      interpretation = "Typical values for healthy vegetation range between 0.2 and 0.8. Requires physical surface reflectance in [0, 1].",
      limitations = "Sensitive to input data scaling; requires high quality surface reflectance with valid blue band.",
      requires_reflectance = TRUE,
      scale_sensitive = TRUE,
      valid_range = c(-1.0, 1.0),
      required_bands = c("nir", "red", "blue"),
      default_params = list(G = 2.5, C1 = 6.0, C2 = 7.5, L = 1.0),
      formula = "G * (nir - red) / (nir + C1 * red - C2 * blue + L)",
      reference = "Liu & Huete (1995)"
    ),
    list(
      index = "MSAVI",
      name = "Modified Soil Adjusted Vegetation Index 2",
      category = "vegetation",
      purpose = "Vegetation monitoring in sparse canopies without requiring an empirical soil parameter.",
      description = "Derives an inductive soil factor to eliminate the manual specification of L in SAVI.",
      interpretation = "Values range from 0 to 1 for green vegetation. Suppresses soil brightness effects automatically.",
      limitations = "Requires physical surface reflectance.",
      requires_reflectance = TRUE,
      scale_sensitive = TRUE,
      valid_range = c(-1.0, 1.0),
      required_bands = c("nir", "red"),
      default_params = list(),
      formula = "(2 * nir + 1 - sqrt((2 * nir + 1)^2 - 8 * (nir - red))) / 2",
      reference = "Qi et al. (1994)"
    ),
    list(
      index = "OSAVI",
      name = "Optimized Soil-Adjusted Vegetation Index",
      category = "vegetation",
      purpose = "Standardized soil-adjusted vegetation index with fixed optimal parameter.",
      description = "Uses a standard theta = 0.16 canopy background factor.",
      interpretation = "Values from 0.2 to 0.9 indicate healthy vegetation with minimal soil interference.",
      limitations = "Requires physical reflectance in [0, 1].",
      requires_reflectance = TRUE,
      scale_sensitive = TRUE,
      valid_range = c(-1.0, 1.0),
      required_bands = c("nir", "red"),
      default_params = list(theta = 0.16),
      formula = "((nir - red) / (nir + red + theta)) * (1 + theta)",
      reference = "Rondeaux et al. (1996)"
    ),
    list(
      index = "ARVI",
      name = "Atmospherically Resistant Vegetation Index",
      category = "vegetation",
      purpose = "Vegetation monitoring under atmospheric haze or aerosol conditions.",
      description = "Uses blue band to correct atmospheric scattering in the red channel.",
      interpretation = "Similar interpretation to NDVI but more robust in smoky or hazy atmospheres.",
      limitations = "Sensitive to blue band radiometric calibration.",
      requires_reflectance = TRUE,
      scale_sensitive = TRUE,
      valid_range = c(-1.0, 1.0),
      required_bands = c("nir", "red", "blue"),
      default_params = list(gamma = 1.0),
      formula = "(nir - (red - gamma * (blue - red))) / (nir + (red - gamma * (blue - red)))",
      reference = "Kaufman & Tanre (1992)"
    ),
    list(
      index = "GNDVI",
      name = "Green Normalized Difference Vegetation Index",
      category = "vegetation",
      purpose = "Chlorophyll concentration and photosynthetic activity assessment.",
      description = "Substitutes green for red to enhance sensitivity to chlorophyll content at mid-to-high biomass.",
      interpretation = "Values > 0.4 indicate high green biomass and chlorophyll concentration.",
      limitations = "Less sensitive to early stage sparse canopy than NDVI.",
      requires_reflectance = FALSE,
      scale_sensitive = FALSE,
      valid_range = c(-1.0, 1.0),
      required_bands = c("nir", "green"),
      default_params = list(),
      formula = "(nir - green) / (nir + green)",
      reference = "Gitelson et al. (1996)"
    ),

    # --- WATER INDICES ---
    list(
      index = "NDWI",
      name = "Normalized Difference Water Index",
      category = "water",
      purpose = "Delineation and mapping of open surface water bodies.",
      description = "Contrasts green reflectance with NIR absorption by water.",
      interpretation = "Positive values (> 0) generally correspond to open water bodies. Vegetation and soil produce negative values.",
      limitations = "Can misclassify built-up areas and dark shadows as water.",
      requires_reflectance = FALSE,
      scale_sensitive = FALSE,
      valid_range = c(-1.0, 1.0),
      required_bands = c("green", "nir"),
      default_params = list(),
      formula = "(green - nir) / (green + nir)",
      reference = "McFeeters (1996)"
    ),
    list(
      index = "MNDWI",
      name = "Modified Normalized Difference Water Index",
      category = "water",
      purpose = "Open water feature extraction in urban and built-up environments.",
      description = "Substitutes SWIR for NIR to suppress built-up noise and enhance water contrast.",
      interpretation = "Positive values represent water bodies; built-up, soil, and vegetation have negative values.",
      limitations = "Cloud shadows can occasionally produce false positives.",
      requires_reflectance = FALSE,
      scale_sensitive = FALSE,
      valid_range = c(-1.0, 1.0),
      required_bands = c("green", "swir1"),
      default_params = list(),
      formula = "(green - swir1) / (green + swir1)",
      reference = "Xu (2006)"
    ),
    list(
      index = "AWEI",
      name = "Automated Water Extraction Index",
      category = "water",
      purpose = "Surface water extraction with improved suppression of shadow and dark impervious surfaces.",
      description = "Combines Green, NIR, SWIR1, and SWIR2 bands.",
      interpretation = "Positive values (> 0) classify as water pixels.",
      limitations = "Requires physical reflectance and 4 separate spectral bands.",
      requires_reflectance = TRUE,
      scale_sensitive = TRUE,
      valid_range = c(-5.0, 5.0),
      required_bands = c("green", "nir", "swir1", "swir2"),
      default_params = list(),
      formula = "4 * (green - swir1) - (0.25 * nir + 2.75 * swir2)",
      reference = "Feyisa et al. (2014)"
    ),

    # --- URBAN / BUILT-UP INDICES ---
    list(
      index = "NDBI",
      name = "Normalized Difference Built-up Index",
      category = "urban",
      purpose = "Mapping impervious surfaces, urban extents, and built-up areas.",
      description = "Exploits higher SWIR reflectance relative to NIR in urban surfaces.",
      interpretation = "Positive values (> 0) indicate built-up and impervious surfaces; vegetation has negative values.",
      limitations = "Can exhibit confusion between bare soil and built-up areas.",
      requires_reflectance = FALSE,
      scale_sensitive = FALSE,
      valid_range = c(-1.0, 1.0),
      required_bands = c("swir1", "nir"),
      default_params = list(),
      formula = "(swir1 - nir) / (swir1 + nir)",
      reference = "Zha et al. (2003)"
    ),
    list(
      index = "IBI",
      name = "Index-Based Built-Up Index",
      category = "urban",
      purpose = "Enhanced built-up land extraction by synthesizing NDBI, SAVI, and MNDWI.",
      description = "Subtracts combined vegetation and water signals from the built-up signal.",
      interpretation = "Positive values highlight built-up areas with high contrast against surrounding soil/vegetation.",
      limitations = "Requires green, red, NIR, and SWIR bands.",
      requires_reflectance = TRUE,
      scale_sensitive = TRUE,
      valid_range = c(-2.0, 2.0),
      required_bands = c("swir1", "nir", "red", "green"),
      default_params = list(L = 0.5),
      formula = "((swir1 - nir) / (swir1 + nir) - (((nir - red) * 1.5 / (nir + red + 0.5)) + (green - swir1) / (green + swir1)) / 2) / ((swir1 - nir) / (swir1 + nir) + (((nir - red) * 1.5 / (nir + red + 0.5)) + (green - swir1) / (green + swir1)) / 2)",
      reference = "Xu (2007)"
    ),

    # --- MOISTURE INDICES ---
    list(
      index = "NDMI",
      name = "Normalized Difference Moisture Index",
      category = "moisture",
      purpose = "Vegetation canopy liquid water content and canopy water stress assessment.",
      description = "Contrasts NIR reflectance with SWIR liquid water absorption.",
      interpretation = "Values from 0.2 to 0.8 indicate moist, healthy vegetation canopy. Negative values indicate dry soil or severe drought stress.",
      limitations = "Affected by soil background moisture in sparse canopies.",
      requires_reflectance = FALSE,
      scale_sensitive = FALSE,
      valid_range = c(-1.0, 1.0),
      required_bands = c("nir", "swir1"),
      default_params = list(),
      formula = "(nir - swir1) / (nir + swir1)",
      reference = "Gao (1996)"
    ),
    list(
      index = "MSI",
      name = "Moisture Stress Index",
      category = "moisture",
      purpose = "Plant water stress detection and canopy water loss monitoring.",
      description = "Simple ratio of SWIR1 to NIR reflectance.",
      interpretation = "Higher values (> 1.0) indicate increased canopy water stress; lower values (< 0.6) indicate healthy hydrated canopy.",
      limitations = "Ratio index with open upper scale.",
      requires_reflectance = FALSE,
      scale_sensitive = FALSE,
      valid_range = c(0.0, 10.0),
      required_bands = c("swir1", "nir"),
      default_params = list(),
      formula = "swir1 / nir",
      reference = "Rock et al. (1986)"
    ),

    # --- SOIL INDICES ---
    list(
      index = "BSI",
      name = "Bare Soil Index",
      category = "soil",
      purpose = "Identification and mapping of bare soils and agricultural fallow fields.",
      description = "Combines blue, red, NIR, and SWIR bands to isolate bare soil from vegetation and impervious land.",
      interpretation = "Higher positive values (> 0.1) correspond to exposed bare soil and uncultivated fields.",
      limitations = "Requires 4 separate spectral bands.",
      requires_reflectance = TRUE,
      scale_sensitive = TRUE,
      valid_range = c(-1.0, 1.0),
      required_bands = c("swir1", "red", "nir", "blue"),
      default_params = list(),
      formula = "((swir1 + red) - (nir + blue)) / ((swir1 + red) + (nir + blue))",
      reference = "Rikimaru et al. (2002)"
    ),

    # --- SNOW INDICES ---
    list(
      index = "NDSI",
      name = "Normalized Difference Snow Index",
      category = "snow",
      purpose = "Snow and ice cover mapping and glacier extent monitoring.",
      description = "Exploits high green reflectance and strong SWIR absorption by snow/ice.",
      interpretation = "Values > 0.4 indicate snow/ice cover. Clouds typically have lower or near-zero NDSI.",
      limitations = "Can confuse mixed snow-vegetation pixels.",
      requires_reflectance = FALSE,
      scale_sensitive = FALSE,
      valid_range = c(-1.0, 1.0),
      required_bands = c("green", "swir1"),
      default_params = list(),
      formula = "(green - swir1) / (green + swir1)",
      reference = "Hall et al. (1995)"
    )
  )

  df <- data.frame(
    index = vapply(indices, `[[`, character(1), "index"),
    name = vapply(indices, `[[`, character(1), "name"),
    category = vapply(indices, `[[`, character(1), "category"),
    purpose = vapply(indices, `[[`, character(1), "purpose"),
    description = vapply(indices, `[[`, character(1), "description"),
    interpretation = vapply(indices, `[[`, character(1), "interpretation"),
    limitations = vapply(indices, `[[`, character(1), "limitations"),
    requires_reflectance = vapply(indices, `[[`, logical(1), "requires_reflectance"),
    scale_sensitive = vapply(indices, `[[`, logical(1), "scale_sensitive"),
    required_bands = vapply(indices, function(x) paste(x$required_bands, collapse = ", "), character(1)),
    formula = vapply(indices, `[[`, character(1), "formula"),
    reference = vapply(indices, `[[`, character(1), "reference"),
    stringsAsFactors = FALSE
  )

  if (!is.null(category)) {
    cat_clean <- tolower(trimws(category))
    df <- df[df$category == cat_clean, , drop = FALSE]
    if (nrow(df) == 0) {
      warning(sprintf("No indices found for category '%s'.", category), call. = FALSE)
    }
  }

  rownames(df) <- NULL
  df
}

#' Retrieve Metadata for a Single Spectral Index
#'
#' @param index Character string specifying index name (e.g., \code{"NDVI"}).
#'
#' @return A list containing detailed index metadata, parameter defaults, and formulas.
#'
#' @keywords internal
get_index_meta <- function(index) {
  if (missing(index) || length(index) != 1 || !is.character(index) || !nzchar(trimws(index))) {
    stop("Argument 'index' must be a single non-empty character string.", call. = FALSE)
  }

  idx_clean <- toupper(trimws(index))
  reg <- index_registry()
  matched_row <- which(reg$index == idx_clean)

  if (length(matched_row) == 0) {
    available <- paste(reg$index, collapse = ", ")
    stop(
      sprintf("Index '%s' is not in the registry.\nSupported indices: %s.\nFor custom formulas, use 'geo_index_custom()'.",
              index, available),
      call. = FALSE
    )
  }

  row <- reg[matched_row, ]
  bands <- trimws(unlist(strsplit(row$required_bands, ",\\s*")))

  # Extract default params for specific indices
  default_params <- switch(
    idx_clean,
    SAVI = list(L = 0.5),
    EVI = list(G = 2.5, C1 = 6.0, C2 = 7.5, L = 1.0),
    OSAVI = list(theta = 0.16),
    ARVI = list(gamma = 1.0),
    IBI = list(L = 0.5),
    list()
  )

  valid_range <- switch(
    idx_clean,
    AWEI = c(-5.0, 5.0),
    MSI = c(0.0, 10.0),
    IBI = c(-2.0, 2.0),
    SAVI = c(-1.5, 1.5),
    c(-1.0, 1.0)
  )

  list(
    index = row$index,
    name = row$name,
    category = row$category,
    purpose = row$purpose,
    description = row$description,
    interpretation = row$interpretation,
    limitations = row$limitations,
    requires_reflectance = row$requires_reflectance,
    scale_sensitive = row$scale_sensitive,
    valid_range = valid_range,
    required_bands = bands,
    default_params = default_params,
    formula = row$formula,
    reference = row$reference
  )
}

#' List Supported Spectral Index Codes
#'
#' @param category Optional character string to filter by category.
#'
#' @return A character vector of index codes.
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
