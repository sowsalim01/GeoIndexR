## Code to prepare `example_multispectral` dataset

terra_proj <- system.file("proj", package = "terra")
if (nzchar(terra_proj) && dir.exists(terra_proj)) {
  Sys.setenv(PROJ_LIB = terra_proj)
  Sys.setenv(PROJ_DATA = terra_proj)
}

set.seed(42)

# Create a small 10x10 synthetic raster with realistic multispectral profiles
# Dimensions: 10 rows, 10 cols, 6 bands
# Extent in UTM 31N (Paris area as realistic coordinates)
ext <- terra::ext(440000, 440100, 5410000, 5410100)
crs_str <- "EPSG:32631"

n_pixels <- 100

# Simulated land cover profiles (reflectance in [0, 1])
# 1. Healthy vegetation (high NIR, low Red, low-mid Green, low Blue)
veg_blue  <- runif(40, 0.02, 0.05)
veg_green <- runif(40, 0.06, 0.12)
veg_red   <- runif(40, 0.03, 0.06)
veg_nir   <- runif(40, 0.50, 0.85)
veg_swir1 <- runif(40, 0.15, 0.25)
veg_swir2 <- runif(40, 0.05, 0.12)

# 2. Water body (low NIR, moderate Blue-Green, low SWIR)
wat_blue  <- runif(30, 0.05, 0.10)
wat_green <- runif(30, 0.04, 0.08)
wat_red   <- runif(30, 0.02, 0.04)
wat_nir   <- runif(30, 0.01, 0.03)
wat_swir1 <- runif(30, 0.005, 0.015)
wat_swir2 <- runif(30, 0.001, 0.010)

# 3. Built-up / Bare soil (high SWIR and Red, moderate NIR, moderate Blue)
urb_blue  <- runif(30, 0.12, 0.20)
urb_green <- runif(30, 0.15, 0.25)
urb_red   <- runif(30, 0.20, 0.35)
urb_nir   <- runif(30, 0.25, 0.38)
urb_swir1 <- runif(30, 0.35, 0.55)
urb_swir2 <- runif(30, 0.25, 0.45)

blue_vals  <- c(veg_blue,  wat_blue,  urb_blue)
green_vals <- c(veg_green, wat_green, urb_green)
red_vals   <- c(veg_red,   wat_red,   urb_red)
nir_vals   <- c(veg_nir,   wat_nir,   urb_nir)
swir1_vals <- c(veg_swir1, wat_swir1, urb_swir1)
swir2_vals <- c(veg_swir2, wat_swir2, urb_swir2)

# Introduce 1 NA pixel at coordinate (1, 1) for boundary/NA verification
blue_vals[1]  <- NA
green_vals[1] <- NA
red_vals[1]   <- NA
nir_vals[1]   <- NA
swir1_vals[1] <- NA
swir2_vals[1] <- NA

r_blue  <- terra::rast(nrows = 10, ncols = 10, ext = ext, crs = crs_str, vals = blue_vals)
r_green <- terra::rast(nrows = 10, ncols = 10, ext = ext, crs = crs_str, vals = green_vals)
r_red   <- terra::rast(nrows = 10, ncols = 10, ext = ext, crs = crs_str, vals = red_vals)
r_nir   <- terra::rast(nrows = 10, ncols = 10, ext = ext, crs = crs_str, vals = nir_vals)
r_swir1 <- terra::rast(nrows = 10, ncols = 10, ext = ext, crs = crs_str, vals = swir1_vals)
r_swir2 <- terra::rast(nrows = 10, ncols = 10, ext = ext, crs = crs_str, vals = swir2_vals)

example_multispectral <- c(r_blue, r_green, r_red, r_nir, r_swir1, r_swir2)
names(example_multispectral) <- c("blue", "green", "red", "nir", "swir1", "swir2")

# Note: In packages, terra SpatRaster objects should be serialized properly or
# saved via terra::wrap() if stored as RDA, or generated dynamically.
# terra recommends wrap() when storing SpatRaster in RDA.
# To be maximally portable and CRAN-compliant:
# We wrap it or store packed raster or provide sample dataset via a helper function.
example_multispectral_packed <- terra::wrap(example_multispectral)

dir.create("data", showWarnings = FALSE)
save(example_multispectral_packed, file = "data/example_multispectral.rda", compress = "xz")
