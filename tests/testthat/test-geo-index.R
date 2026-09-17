test_that("geo_index computes single index and preserves spatial properties", {
  img <- get_example_data()

  ndvi <- geo_index(img, "NDVI")
  expect_s4_class(ndvi, "SpatRaster")
  expect_equal(terra::nlyr(ndvi), 1)
  expect_equal(names(ndvi), "NDVI")

  # Spatial properties match
  expect_equal(terra::nrow(ndvi), terra::nrow(img))
  expect_equal(terra::ncol(ndvi), terra::ncol(img))
  expect_equal(terra::res(ndvi), terra::res(img))
  expect_equal(as.vector(terra::ext(ndvi)), as.vector(terra::ext(img)))
  expect_equal(terra::crs(ndvi), terra::crs(img))

  # Values in valid range [-1, 1]
  vals <- terra::values(ndvi, mat = FALSE, na.rm = TRUE)
  expect_true(all(vals >= -1.0 & vals <= 1.0))
})

test_that("geo_index accepts direct file path as input", {
  img <- get_example_data()
  tmp_file <- tempfile(fileext = ".tif")
  on.exit(unlink(tmp_file), add = TRUE)
  terra::writeRaster(img, tmp_file, overwrite = TRUE)

  # Pass filepath string directly
  ndvi_from_file <- geo_index(tmp_file, "NDVI", bands = c(red = "red", nir = "nir"))
  expect_s4_class(ndvi_from_file, "SpatRaster")
  expect_equal(names(ndvi_from_file), "NDVI")

  # Non-existent file path error
  expect_error(
    geo_index("non_existent_image_12345.tif", "NDVI"),
    "does not exist"
  )
})

test_that("geo_index accepts custom parameters", {
  img <- get_example_data()
  savi1 <- geo_index(img, "SAVI", L = 0.5)
  savi2 <- geo_index(img, "SAVI", L = 1.0)

  expect_false(identical(terra::values(savi1), terra::values(savi2)))
})

test_that("geo_indices computes multiple indices into a multilayer SpatRaster", {
  img <- get_example_data()
  indices_req <- c("NDVI", "NDWI", "NDBI", "NDMI", "MSAVI", "OSAVI")
  stack <- geo_indices(img, indices = indices_req)

  expect_s4_class(stack, "SpatRaster")
  expect_equal(terra::nlyr(stack), 6)
  expect_equal(names(stack), indices_req)
})

test_that("geo_index_all computes all compatible indices", {
  img <- get_example_data()
  all_idx <- suppressMessages(geo_index_all(img))

  expect_s4_class(all_idx, "SpatRaster")
  expect_true(terra::nlyr(all_idx) >= 10)
  expect_true(all(c("NDVI", "SAVI", "EVI", "MSAVI", "OSAVI", "ARVI", "GNDVI", "NDWI", "MNDWI", "AWEI", "NDBI", "IBI", "NDMI", "MSI", "BSI", "NDSI") %in% names(all_idx)))
})

test_that("geo_index works with custom band mapping and sensor preset", {
  # Mock Sentinel-2 raster
  r <- terra::rast(nrows = 5, ncols = 5, nlyrs = 4)
  names(r) <- c("B02", "B03", "B04", "B08")
  terra::values(r) <- runif(100, 0.1, 0.8)

  # With sensor preset
  ndvi_s2 <- geo_index(r, "NDVI", sensor = "sentinel2")
  expect_equal(names(ndvi_s2), "NDVI")

  # With custom mapping by name
  custom_map <- c(nir = "B08", red = "B04")
  ndvi_custom <- geo_index(r, "NDVI", bands = custom_map)
  expect_equal(names(ndvi_custom), "NDVI")
  expect_equal(terra::values(ndvi_s2), terra::values(ndvi_custom))

  # With custom mapping by integer index
  ndvi_idx <- geo_index(r, "NDVI", bands = c(red = 3, nir = 4))
  expect_equal(terra::values(ndvi_custom), terra::values(ndvi_idx))
})

test_that("geo_index errors informatively on invalid inputs", {
  expect_error(geo_index(12345, "NDVI"), "must be a SpatRaster or a valid raster file path")

  img <- get_example_data()
  expect_error(geo_index(img, "UNKNOWN_INDEX_XYZ"), "is not in the registry")
})
