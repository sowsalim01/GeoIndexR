test_that("band_mapping returns correct presets", {
  gen <- band_mapping("generic")
  expect_true(is.character(gen))
  expect_equal(gen[["nir"]], "nir")
  expect_equal(gen[["red"]], "red")

  s2 <- band_mapping("sentinel2")
  expect_equal(s2[["nir"]], "B08")
  expect_equal(s2[["red"]], "B04")
  expect_equal(s2[["blue"]], "B02")

  l8 <- band_mapping("landsat8")
  expect_equal(l8[["nir"]], "B5")
  expect_equal(l8[["red"]], "B4")
})

test_that("resolve_bands works with explicit layer names", {
  r <- terra::rast(nrows = 5, ncols = 5, nlyrs = 3)
  names(r) <- c("red", "green", "nir")
  terra::values(r) <- 1

  res <- resolve_bands(r, required_bands = c("nir", "red"), index_name = "NDVI")
  expect_type(res, "list")
  expect_named(res, c("nir", "red"))
  expect_s4_class(res$nir, "SpatRaster")
})

test_that("resolve_bands works with sensor presets and custom mapping", {
  # Sentinel-2 style layer names
  r_s2 <- terra::rast(nrows = 5, ncols = 5, nlyrs = 3)
  names(r_s2) <- c("B02", "B04", "B08")
  terra::values(r_s2) <- 1

  res_s2 <- resolve_bands(r_s2, required_bands = c("nir", "red"), sensor = "sentinel2")
  expect_named(res_s2, c("nir", "red"))

  # Custom numeric mapping
  custom <- c(nir = 3, red = 2)
  res_custom <- resolve_bands(r_s2, required_bands = c("nir", "red"), custom_mapping = custom)
  expect_named(res_custom, c("nir", "red"))
})

test_that("resolve_bands errors informatively when bands are missing", {
  r_partial <- terra::rast(nrows = 5, ncols = 5, nlyrs = 2)
  names(r_partial) <- c("blue", "green")

  expect_error(
    resolve_bands(r_partial, required_bands = c("nir", "red"), index_name = "NDVI"),
    "Missing band"
  )
})
