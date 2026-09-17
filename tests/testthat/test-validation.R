test_that("check_raster validates SpatRaster inputs correctly", {
  r <- terra::rast(nrows = 2, ncols = 2, vals = 1)
  expect_invisible(check_raster(r))
  expect_error(check_raster("not_a_raster"), "must be a terra 'SpatRaster'")
})

test_that("safe_divide handles zero division and NaN for numerics and rasters", {
  # Numeric test
  num <- c(10, 0, 5, 0)
  den <- c(2, 0, 0, 5)
  res_num <- safe_divide(num, den)
  expect_equal(res_num[1], 5)
  expect_true(is.na(res_num[2]))
  expect_true(is.na(res_num[3]))
  expect_equal(res_num[4], 0)

  # SpatRaster test
  r_num <- terra::rast(nrows = 2, ncols = 2, vals = c(10, 0, 5, 0))
  r_den <- terra::rast(nrows = 2, ncols = 2, vals = c(2, 0, 0, 5))
  res_rast <- safe_divide(r_num, r_den)
  expect_s4_class(res_rast, "SpatRaster")
  vals <- terra::values(res_rast, mat = FALSE)
  expect_equal(vals[1], 5)
  expect_true(is.na(vals[2]))
  expect_true(is.na(vals[3]))
  expect_equal(vals[4], 0)
})

test_that("check_spatial_compatibility catches dimension mismatch", {
  r1 <- terra::rast(nrows = 5, ncols = 5, vals = 1)
  r2 <- terra::rast(nrows = 10, ncols = 10, vals = 1)
  expect_error(
    check_spatial_compatibility(list(b1 = r1, b2 = r2)),
    "Dimension mismatch"
  )
})
