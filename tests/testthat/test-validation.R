test_that("check_raster and validate_raster_input validate inputs correctly", {
  r <- terra::rast(nrows = 2, ncols = 2, vals = 1)
  expect_invisible(check_raster(r))
  expect_s4_class(validate_raster_input(r), "SpatRaster")
  expect_error(check_raster("not_a_raster"), "must be a SpatRaster or valid file path")
  expect_error(validate_raster_input("not_a_real_file.tif"), "does not exist")
  expect_error(validate_raster_input(12345), "must be a SpatRaster or a valid raster file path")
})

test_that("safe_divide handles zero division, singularity, and NaN for numerics and rasters", {
  # Numeric test
  num <- c(10, 0, 5, 0, 1)
  den <- c(2, 0, 0, 5, 1e-8) # 1e-8 is smaller than tol = 1e-6 -> NA
  res_num <- safe_divide(num, den, tol = 1e-6)
  expect_equal(res_num[1], 5)
  expect_true(is.na(res_num[2]))
  expect_true(is.na(res_num[3]))
  expect_equal(res_num[4], 0)
  expect_true(is.na(res_num[5]))

  # SpatRaster test
  r_num <- terra::rast(nrows = 2, ncols = 2, vals = c(10, 0, 5, 1))
  r_den <- terra::rast(nrows = 2, ncols = 2, vals = c(2, 0, 0, 1e-8))
  res_rast <- safe_divide(r_num, r_den, tol = 1e-6)
  expect_s4_class(res_rast, "SpatRaster")
  vals <- terra::values(res_rast, mat = FALSE)
  expect_equal(vals[1], 5)
  expect_true(is.na(vals[2]))
  expect_true(is.na(vals[3]))
  expect_true(is.na(vals[4]))
})

test_that("check_spatial_compatibility catches dimension mismatch", {
  r1 <- terra::rast(nrows = 5, ncols = 5, vals = 1)
  r2 <- terra::rast(nrows = 10, ncols = 10, vals = 1)
  expect_error(
    check_spatial_compatibility(list(b1 = r1, b2 = r2)),
    "Dimension mismatch"
  )
})
