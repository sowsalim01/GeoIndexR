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

test_that("geo_index accepts custom parameters", {
  img <- get_example_data()
  savi1 <- geo_index(img, "SAVI", L = 0.5)
  savi2 <- geo_index(img, "SAVI", L = 1.0)

  expect_false(identical(terra::values(savi1), terra::values(savi2)))
})

test_that("geo_indices computes multiple indices into a multilayer SpatRaster", {
  img <- get_example_data()
  indices_req <- c("NDVI", "NDWI", "NDBI", "NDMI")
  stack <- geo_indices(img, indices = indices_req)

  expect_s4_class(stack, "SpatRaster")
  expect_equal(terra::nlyr(stack), 4)
  expect_equal(names(stack), indices_req)
})

test_that("geo_index_all computes all compatible indices", {
  img <- get_example_data()
  all_idx <- suppressMessages(geo_index_all(img))

  expect_s4_class(all_idx, "SpatRaster")
  expect_true(terra::nlyr(all_idx) >= 8)
  expect_true(all(c("NDVI", "SAVI", "EVI", "GNDVI", "NDWI", "MNDWI", "NDBI", "NDMI", "BSI") %in% names(all_idx)))
})

test_that("geo_index works with custom band mapping and sensor preset", {
  # Mock Sentinel-2 raster
  r <- terra::rast(nrows = 5, ncols = 5, nlyrs = 4)
  names(r) <- c("B02", "B03", "B04", "B08")
  terra::values(r) <- runif(100, 0.1, 0.8)

  # With sensor preset
  ndvi_s2 <- geo_index(r, "NDVI", sensor = "sentinel2")
  expect_equal(names(ndvi_s2), "NDVI")

  # With custom mapping
  custom_map <- c(nir = "B08", red = "B04")
  ndvi_custom <- geo_index(r, "NDVI", bands = custom_map)
  expect_equal(names(ndvi_custom), "NDVI")
  expect_equal(terra::values(ndvi_s2), terra::values(ndvi_custom))
})

test_that("geo_index errors informatively on invalid inputs", {
  expect_error(geo_index("not_a_raster", "NDVI"), "must be a terra 'SpatRaster'")

  img <- get_example_data()
  expect_error(geo_index(img, "INVALID"), "Unknown index")
})
