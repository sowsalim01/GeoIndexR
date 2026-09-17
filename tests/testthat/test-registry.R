test_that("index_registry returns valid data.frame with expected columns", {
  reg <- index_registry()
  expect_s3_class(reg, "data.frame")
  expect_true(nrow(reg) >= 15)

  expected_cols <- c("index", "name", "category", "purpose", "description", "interpretation", "limitations", "requires_reflectance", "scale_sensitive", "required_bands", "formula", "reference")
  expect_true(all(expected_cols %in% names(reg)))

  expected_indices <- c("NDVI", "SAVI", "EVI", "MSAVI", "OSAVI", "ARVI", "GNDVI", "NDWI", "MNDWI", "AWEI", "NDBI", "IBI", "NDMI", "MSI", "BSI", "NDSI")
  expect_true(all(expected_indices %in% reg$index))
})

test_that("index_registry filters by category", {
  veg <- index_registry(category = "vegetation")
  expect_true(all(veg$category == "vegetation"))
  expect_true("NDVI" %in% veg$index)
  expect_true("MSAVI" %in% veg$index)
  expect_false("NDWI" %in% veg$index)

  water <- index_registry(category = "water")
  expect_true(all(water$category == "water"))
  expect_true("NDWI" %in% water$index)
  expect_true("MNDWI" %in% water$index)
  expect_true("AWEI" %in% water$index)

  expect_warning(index_registry(category = "nonexistent_category"), "No indices found")
})

test_that("list_indices returns character vector", {
  all_idx <- list_indices()
  expect_type(all_idx, "character")
  expect_true("NDVI" %in% all_idx)

  veg_idx <- list_indices("vegetation")
  expect_true("NDVI" %in% veg_idx)
  expect_false("NDWI" %in% veg_idx)
})

test_that("get_index_meta returns correct metadata and handles unknown index", {
  meta <- get_index_meta("ndvi")
  expect_equal(meta$index, "NDVI")
  expect_equal(meta$required_bands, c("nir", "red"))

  expect_error(get_index_meta("INVALID_INDEX"), "is not in the registry")
})
