test_that("scientific verification: EVI formula with known physical reflectance", {
  # Known synthetic profile (physical reflectance in [0, 1])
  # blue = 0.10, red = 0.20, nir = 0.50
  # Parameters: G = 2.5, C1 = 6.0, C2 = 7.5, L = 1.0
  # Numerator:   G * (nir - red) = 2.5 * (0.50 - 0.20) = 2.5 * 0.30 = 0.75
  # Denominator: nir + C1 * red - C2 * blue + L
  #            = 0.50 + 6.0 * 0.20 - 7.5 * 0.10 + 1.0
  #            = 0.50 + 1.20 - 0.75 + 1.0 = 1.95
  # Expected:    0.75 / 1.95 = 0.3846153846...

  expected_evi <- 0.75 / 1.95

  # 1. Numeric calculation
  res_num <- calc_evi(nir = 0.50, red = 0.20, blue = 0.10)
  expect_equal(res_num, expected_evi, tolerance = 1e-6)

  # 2. SpatRaster calculation
  r_blue <- terra::rast(nrows = 2, ncols = 2, vals = rep(0.10, 4))
  r_red  <- terra::rast(nrows = 2, ncols = 2, vals = rep(0.20, 4))
  r_nir  <- terra::rast(nrows = 2, ncols = 2, vals = rep(0.50, 4))
  stack_refl <- c(r_blue, r_red, r_nir)
  names(stack_refl) <- c("blue", "red", "nir")

  evi_rast <- geo_index(stack_refl, "EVI")
  vals_refl <- terra::values(evi_rast, mat = FALSE)
  expect_true(all(abs(vals_refl - expected_evi) < 1e-6))
})

test_that("scientific verification: EVI with raw integer Digital Numbers and scale_factor", {
  # Raw integer DNs as typically found in Sentinel-2 / Landsat L2A (multiplied by 10000)
  # blue = 1000, red = 2000, nir = 5000
  r_blue_dn <- terra::rast(nrows = 2, ncols = 2, vals = rep(1000, 4))
  r_red_dn  <- terra::rast(nrows = 2, ncols = 2, vals = rep(2000, 4))
  r_nir_dn  <- terra::rast(nrows = 2, ncols = 2, vals = rep(5000, 4))
  stack_dn <- c(r_blue_dn, r_red_dn, r_nir_dn)
  names(stack_dn) <- c("blue", "red", "nir")

  expected_evi <- 0.75 / 1.95

  # With scale_factor = 10000, result must be identical to physical reflectance
  evi_scaled <- geo_index(stack_dn, "EVI", scale_factor = 10000)
  vals_scaled <- terra::values(evi_scaled, mat = FALSE)
  expect_true(all(abs(vals_scaled - expected_evi) < 1e-6))
})

test_that("EVI custom parameter overrides work as intended", {
  # Custom G = 2.0, L = 0.5
  # Num: 2.0 * 0.30 = 0.60
  # Den: 0.50 + 1.20 - 0.75 + 0.5 = 1.45
  expected_custom <- 0.60 / 1.45

  res_custom <- calc_evi(nir = 0.50, red = 0.20, blue = 0.10, G = 2.0, L = 0.5)
  expect_equal(res_custom, expected_custom, tolerance = 1e-6)
})
