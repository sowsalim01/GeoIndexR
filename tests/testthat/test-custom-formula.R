test_that("geo_index_custom computes standard ratio formulas", {
  img <- get_example_data()

  custom_ndvi <- geo_index_custom(
    img,
    formula = "(nir - red) / (nir + red)",
    bands = c(red = "red", nir = "nir"),
    name = "MyNDVI"
  )

  expect_s4_class(custom_ndvi, "SpatRaster")
  expect_equal(names(custom_ndvi), "MyNDVI")

  # Must equal standard NDVI
  std_ndvi <- geo_index(img, "NDVI")
  diff_vals <- terra::values(abs(custom_ndvi - std_ndvi), mat = FALSE, na.rm = TRUE)
  expect_true(all(diff_vals < 1e-6))
})

test_that("geo_index_custom supports custom parameters", {
  img <- get_example_data()

  custom_evi <- geo_index_custom(
    img,
    formula = "G * (nir - red) / (nir + C1 * red - C2 * blue + L)",
    bands = c(blue = "blue", red = "red", nir = "nir"),
    params = list(G = 2.5, C1 = 6.0, C2 = 7.5, L = 1.0),
    name = "MyEVI"
  )

  std_evi <- geo_index(img, "EVI")
  diff_vals <- terra::values(abs(custom_evi - std_evi), mat = FALSE, na.rm = TRUE)
  expect_true(all(diff_vals < 1e-6))
})

test_that("geo_index_custom supports math functions sqrt, abs, exp, log", {
  img <- get_example_data()

  # Square root & absolute value
  custom_sqrt <- geo_index_custom(
    img,
    formula = "sqrt(abs(nir - red))",
    bands = c(nir = "nir", red = "red"),
    name = "SqrtDiff"
  )

  expect_s4_class(custom_sqrt, "SpatRaster")
  vals <- terra::values(custom_sqrt, mat = FALSE, na.rm = TRUE)
  expect_true(all(vals >= 0))
})

test_that("geo_index_custom blocks malicious or forbidden code in formula", {
  img <- get_example_data()

  # Forbidden system call
  expect_error(
    geo_index_custom(img, formula = "system('ls') + nir", bands = c(nir = "nir")),
    "Forbidden or unknown function"
  )

  # Forbidden eval call
  expect_error(
    geo_index_custom(img, formula = "eval(parse(text='1+1')) * nir", bands = c(nir = "nir")),
    "Forbidden or unknown function"
  )

  # Syntax error
  expect_error(
    geo_index_custom(img, formula = "(nir - red /", bands = c(nir = "nir", red = "red")),
    "Formula syntax error"
  )

  # Unknown band
  expect_error(
    geo_index_custom(img, formula = "(nir - unknown_band) / (nir + unknown_band)", bands = c(nir = "nir")),
    "Unknown variable"
  )
})
