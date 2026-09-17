#' Get Example Multispectral SpatRaster
#'
#' Returns a ready-to-use synthetic 6-band \code{terra::SpatRaster} for fast,
#' reproducible examples and unit testing without downloading satellite scenes.
#'
#' The raster is generated programmatically (10 x 10 pixels, 100 m x 100 m
#' extent, EPSG:32631). It contains three simulated land-cover types:
#' healthy vegetation (pixels 2-40), water (pixels 41-70), and built-up /
#' bare soil (pixels 71-100). Pixel 1 is \code{NA} in all bands for
#' boundary / NA-handling verification.
#'
#' Spectral bands (reflectance 0-1):
#' \itemize{
#'   \item \code{blue}:  Blue (0.45 - 0.51 um)
#'   \item \code{green}: Green (0.53 - 0.59 um)
#'   \item \code{red}:   Red (0.64 - 0.67 um)
#'   \item \code{nir}:   Near-infrared (0.85 - 0.88 um)
#'   \item \code{swir1}: Short-wave infrared 1 (1.57 - 1.65 um)
#'   \item \code{swir2}: Short-wave infrared 2 (2.11 - 2.29 um)
#' }
#'
#' @return A \code{terra::SpatRaster} with 6 layers named
#'   \code{"blue"}, \code{"green"}, \code{"red"}, \code{"nir"},
#'   \code{"swir1"}, \code{"swir2"}.
#'
#' @examples
#' img <- get_example_data()
#' print(img)
#' terra::nlyr(img)
#'
#' @export
get_example_data <- function() {
  terra_proj <- system.file("proj", package = "terra")
  if (nzchar(terra_proj) && dir.exists(terra_proj)) {
    Sys.setenv(PROJ_LIB = terra_proj)
    Sys.setenv(PROJ_DATA = terra_proj)
  }

  set.seed(42)

  ext <- terra::ext(440000, 440100, 5410000, 5410100)

  # --- Healthy vegetation (40 pixels) ---
  veg_blue  <- stats::runif(40, 0.02, 0.05)
  veg_green <- stats::runif(40, 0.06, 0.12)
  veg_red   <- stats::runif(40, 0.03, 0.06)
  veg_nir   <- stats::runif(40, 0.50, 0.85)
  veg_swir1 <- stats::runif(40, 0.15, 0.25)
  veg_swir2 <- stats::runif(40, 0.05, 0.12)

  # --- Water body (30 pixels) ---
  wat_blue  <- stats::runif(30, 0.05, 0.10)
  wat_green <- stats::runif(30, 0.04, 0.08)
  wat_red   <- stats::runif(30, 0.02, 0.04)
  wat_nir   <- stats::runif(30, 0.01, 0.03)
  wat_swir1 <- stats::runif(30, 0.005, 0.015)
  wat_swir2 <- stats::runif(30, 0.001, 0.010)

  # --- Built-up / bare soil (30 pixels) ---
  urb_blue  <- stats::runif(30, 0.12, 0.20)
  urb_green <- stats::runif(30, 0.15, 0.25)
  urb_red   <- stats::runif(30, 0.20, 0.35)
  urb_nir   <- stats::runif(30, 0.25, 0.38)
  urb_swir1 <- stats::runif(30, 0.35, 0.55)
  urb_swir2 <- stats::runif(30, 0.25, 0.45)

  blue_vals  <- c(veg_blue,  wat_blue,  urb_blue)
  green_vals <- c(veg_green, wat_green, urb_green)
  red_vals   <- c(veg_red,   wat_red,   urb_red)
  nir_vals   <- c(veg_nir,   wat_nir,   urb_nir)
  swir1_vals <- c(veg_swir1, wat_swir1, urb_swir1)
  swir2_vals <- c(veg_swir2, wat_swir2, urb_swir2)

  # Pixel 1 = NA for boundary / NA-handling tests
  blue_vals[1]  <- NA
  green_vals[1] <- NA
  red_vals[1]   <- NA
  nir_vals[1]   <- NA
  swir1_vals[1] <- NA
  swir2_vals[1] <- NA

  make_layer <- function(vals) {
    terra::rast(nrows = 10, ncols = 10, ext = ext, vals = vals)
  }

  r <- c(
    make_layer(blue_vals),
    make_layer(green_vals),
    make_layer(red_vals),
    make_layer(nir_vals),
    make_layer(swir1_vals),
    make_layer(swir2_vals)
  )
  names(r) <- c("blue", "green", "red", "nir", "swir1", "swir2")

  suppressWarnings(tryCatch({
    terra::crs(r) <- "EPSG:32631"
  }, error = function(e) NULL))

  r
}
