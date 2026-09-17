test_that("scientific verification: NDVI formula and values", {
  # Exact theoretical: (0.8 - 0.2) / (0.8 + 0.2) = 0.6
  expect_equal(calc_ndvi(nir = 0.8, red = 0.2), 0.6)

  # SpatRaster calculation
  r_nir <- terra::rast(nrows = 2, ncols = 2, vals = c(0.8, 0.5, 0.3, 0))
  r_red <- terra::rast(nrows = 2, ncols = 2, vals = c(0.2, 0.5, 0.1, 0))
  res <- calc_ndvi(r_nir, r_red)

  expect_s4_class(res, "SpatRaster")
  expect_equal(names(res), "NDVI")

  vals <- terra::values(res, mat = FALSE)
  expect_equal(vals[1], 0.6)
  expect_equal(vals[2], 0.0)
  expect_equal(vals[3], 0.5)
  expect_true(is.na(vals[4])) # 0 / 0 safe division -> NA
})

test_that("scientific verification: SAVI formula and parameter L", {
  # ((0.8 - 0.2) / (0.8 + 0.2 + 0.5)) * 1.5 = 0.6
  expect_equal(calc_savi(nir = 0.8, red = 0.2, L = 0.5), 0.6)

  # Custom L factor
  val_custom <- calc_savi(nir = 0.8, red = 0.2, L = 1.0)
  expected_custom <- ((0.8 - 0.2) / (0.8 + 0.2 + 1.0)) * 2.0
  expect_equal(val_custom, expected_custom)
})

test_that("scientific verification: EVI formula and default parameters", {
  # G * (nir - red) / (nir + C1 * red - C2 * blue + L)
  # 2.5 * (0.8 - 0.2) / (0.8 + 6 * 0.2 - 7.5 * 0.1 + 1) = 1.5 / 2.25 = 2/3
  res <- calc_evi(nir = 0.8, red = 0.2, blue = 0.1)
  expect_equal(res, 2 / 3)
})

test_that("scientific verification: MSAVI formula", {
  # (2*0.8 + 1 - sqrt((2*0.8 + 1)^2 - 8*(0.8 - 0.2))) / 2
  # (2.6 - sqrt(2.6^2 - 8*0.6)) / 2 = (2.6 - sqrt(6.76 - 4.8)) / 2 = (2.6 - sqrt(1.96)) / 2
  # = (2.6 - 1.4) / 2 = 1.2 / 2 = 0.6
  expect_equal(calc_msavi(nir = 0.8, red = 0.2), 0.6)
})

test_that("scientific verification: OSAVI formula", {
  # ((0.8 - 0.2) / (0.8 + 0.2 + 0.16)) * 1.16 = (0.6 / 1.16) * 1.16 = 0.6
  expect_equal(calc_osavi(nir = 0.8, red = 0.2, theta = 0.16), 0.6)
})

test_that("scientific verification: ARVI formula", {
  # rb = 0.2 - 1.0*(0.1 - 0.2) = 0.2 - (-0.1) = 0.3
  # (0.7 - 0.3) / (0.7 + 0.3) = 0.4 / 1.0 = 0.4
  expect_equal(calc_arvi(nir = 0.7, red = 0.2, blue = 0.1, gamma = 1.0), 0.4)
})

test_that("scientific verification: GNDVI formula", {
  # (0.8 - 0.2) / (0.8 + 0.2) = 0.6
  expect_equal(calc_gndvi(nir = 0.8, green = 0.2), 0.6)
})

test_that("scientific verification: NDWI formula", {
  # (0.6 - 0.2) / (0.6 + 0.2) = 0.5
  expect_equal(calc_ndwi(green = 0.6, nir = 0.2), 0.5)
})

test_that("scientific verification: MNDWI formula", {
  # (0.7 - 0.1) / (0.7 + 0.1) = 0.75
  expect_equal(calc_mndwi(green = 0.7, swir1 = 0.1), 0.75)
})

test_that("scientific verification: AWEI formula", {
  # 4 * (0.5 - 0.1) - (0.25 * 0.2 + 2.75 * 0.05)
  # 4 * 0.4 - (0.05 + 0.1375) = 1.6 - 0.1875 = 1.4125
  expect_equal(calc_awei(green = 0.5, nir = 0.2, swir1 = 0.1, swir2 = 0.05), 1.4125)
})

test_that("scientific verification: NDBI formula", {
  # (0.6 - 0.2) / (0.6 + 0.2) = 0.5
  expect_equal(calc_ndbi(swir1 = 0.6, nir = 0.2), 0.5)
})

test_that("scientific verification: IBI formula", {
  res <- calc_ibi(swir1 = 0.6, nir = 0.3, red = 0.2, green = 0.1)
  expect_true(is.numeric(res) && length(res) == 1 && !is.na(res))
})

test_that("scientific verification: NDMI formula", {
  # (0.7 - 0.3) / (0.7 + 0.3) = 0.4
  expect_equal(calc_ndmi(nir = 0.7, swir1 = 0.3), 0.4)
})

test_that("scientific verification: MSI formula", {
  # 0.4 / 0.8 = 0.5
  expect_equal(calc_msi(swir1 = 0.4, nir = 0.8), 0.5)
})

test_that("scientific verification: BSI formula", {
  # ((0.5 + 0.4) - (0.2 + 0.1)) / ((0.5 + 0.4) + (0.2 + 0.1)) = 0.6 / 1.2 = 0.5
  expect_equal(calc_bsi(swir1 = 0.5, red = 0.4, nir = 0.2, blue = 0.1), 0.5)
})

test_that("scientific verification: NDSI formula", {
  # (0.8 - 0.2) / (0.8 + 0.2) = 0.6
  expect_equal(calc_ndsi(green = 0.8, swir1 = 0.2), 0.6)
})

test_that("calc_index dispatches dynamically and handles errors", {
  res1 <- calc_index("NDVI", nir = 0.8, red = 0.2)
  expect_equal(res1, 0.6)

  res2 <- calc_index("savi", nir = 0.8, red = 0.2)
  expect_equal(res2, 0.6)

  # Missing band error
  expect_error(calc_index("NDVI", nir = 0.8), "Missing: red")
  expect_error(calc_index("NONEXISTENT", nir = 0.8), "is not in the registry")
})

test_that("get_example_data loads correctly", {
  img <- get_example_data()
  expect_s4_class(img, "SpatRaster")
  expect_equal(terra::nlyr(img), 6)
  expect_equal(names(img), c("blue", "green", "red", "nir", "swir1", "swir2"))
})
