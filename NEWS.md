# GeoIndexR 0.1.0

* Initial CRAN-ready release of **GeoIndexR**.
* Core framework for computing spectral indices using `terra::SpatRaster`.
* Unified high-level functions: `geo_index()`, `geo_indices()`, and `geo_index_all()`.
* Direct vectorized band calculation functions: `calc_ndvi()`, `calc_savi()`, `calc_evi()`, `calc_gndvi()`, `calc_ndwi()`, `calc_mndwi()`, `calc_ndbi()`, `calc_ndmi()`, and `calc_bsi()`.
* Generic band calculator `calc_index()`.
* Centralized metadata catalog via `index_registry()` and `list_indices()`.
* Sensor presets for Sentinel-2, Landsat-8/9, and Landsat-5/7 via `band_mapping()`.
* Numerical safety: safe division preventing zero-division crashes or silent infinite values.
* Summary statistics with `index_summary()` and thematic visualization with `plot_index()`.
* Bundled lightweight synthetic dataset `example_multispectral`.
* Complete testthat test suite and 4 vignettes.
