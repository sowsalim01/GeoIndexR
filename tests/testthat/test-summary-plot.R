test_that("index_summary produces expected data.frame structure with percentiles", {
  img <- get_example_data()
  ndvi <- geo_index(img, "NDVI")

  s <- index_summary(ndvi)
  expect_s3_class(s, "data.frame")
  expect_equal(nrow(s), 1)
  expect_equal(s$index[1], "NDVI")
  expect_true(all(c("min", "max", "mean", "median", "sd", "q05", "q25", "q75", "q95", "na_pct", "total_cells") %in% names(s)))
  expect_true(s$na_pct[1] >= 0 && s$na_pct[1] <= 100)

  # Multilayer summary
  stack <- geo_indices(img, c("NDVI", "NDWI"))
  s_multi <- index_summary(stack)
  expect_equal(nrow(s_multi), 2)
  expect_equal(s_multi$index, c("NDVI", "NDWI"))

  # Print method runs without error
  expect_output(print(s), "GeoIndexR Spectral Summary")
})

test_that("plot_index executes cleanly for standard and custom indices", {
  img <- get_example_data()
  ndvi <- geo_index(img, "NDVI")
  custom <- geo_index_custom(img, formula = "(nir - red) / (nir + red)", bands = c(nir = "nir", red = "red"), name = "CustomNDVI")

  temp_png <- tempfile(fileext = ".png")
  grDevices::png(temp_png)
  res_plot1 <- plot_index(ndvi)
  res_plot2 <- plot_index(custom, "CustomNDVI")
  grDevices::dev.off()
  unlink(temp_png)

  expect_s4_class(res_plot1, "SpatRaster")
  expect_s4_class(res_plot2, "SpatRaster")
})
