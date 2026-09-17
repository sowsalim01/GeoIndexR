test_that("scale_factor properly scales raw DN values to reflectance in geo_index", {
  r_red_dn <- terra::rast(nrows = 2, ncols = 2, vals = rep(2000, 4))
  r_nir_dn <- terra::rast(nrows = 2, ncols = 2, vals = rep(8000, 4))
  stack_dn <- c(r_red_dn, r_nir_dn)
  names(stack_dn) <- c("red", "nir")

  # SAVI with scale_factor = 10000:
  # nir = 0.8, red = 0.2, L = 0.5
  # Expected: ((0.8 - 0.2) / (0.8 + 0.2 + 0.5)) * 1.5 = (0.6 / 1.5) * 1.5 = 0.6
  savi_res <- geo_index(stack_dn, "SAVI", scale_factor = 10000)
  vals <- terra::values(savi_res, mat = FALSE)
  expect_true(all(abs(vals - 0.6) < 1e-6))
})

test_that("scale_factor works in geo_index_custom", {
  r_red_dn <- terra::rast(nrows = 2, ncols = 2, vals = rep(2000, 4))
  r_nir_dn <- terra::rast(nrows = 2, ncols = 2, vals = rep(8000, 4))
  stack_dn <- c(r_red_dn, r_nir_dn)
  names(stack_dn) <- c("red", "nir")

  custom_savi <- geo_index_custom(
    stack_dn,
    formula = "((nir - red) / (nir + red + L)) * (1 + L)",
    bands = c(red = "red", nir = "nir"),
    params = list(L = 0.5),
    scale_factor = 10000,
    name = "ScaledSAVI"
  )

  vals <- terra::values(custom_savi, mat = FALSE)
  expect_true(all(abs(vals - 0.6) < 1e-6))
})
