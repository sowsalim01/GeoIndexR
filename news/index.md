# Changelog

## GeoIndexR 0.1.0

CRAN release: 2026-10-10

- Initial CRAN-ready release of **GeoIndexR**.
- Core framework for computing spectral indices using
  [`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html).
- Unified high-level functions:
  [`geo_index()`](https://sowsalim01.github.io/GeoIndexR/reference/geo_index.md),
  [`geo_indices()`](https://sowsalim01.github.io/GeoIndexR/reference/geo_indices.md),
  and
  [`geo_index_all()`](https://sowsalim01.github.io/GeoIndexR/reference/geo_index_all.md).
- Direct vectorized band calculation functions:
  [`calc_ndvi()`](https://sowsalim01.github.io/GeoIndexR/reference/calc_ndvi.md),
  [`calc_savi()`](https://sowsalim01.github.io/GeoIndexR/reference/calc_savi.md),
  [`calc_evi()`](https://sowsalim01.github.io/GeoIndexR/reference/calc_evi.md),
  [`calc_gndvi()`](https://sowsalim01.github.io/GeoIndexR/reference/calc_gndvi.md),
  [`calc_ndwi()`](https://sowsalim01.github.io/GeoIndexR/reference/calc_ndwi.md),
  [`calc_mndwi()`](https://sowsalim01.github.io/GeoIndexR/reference/calc_mndwi.md),
  [`calc_ndbi()`](https://sowsalim01.github.io/GeoIndexR/reference/calc_ndbi.md),
  [`calc_ndmi()`](https://sowsalim01.github.io/GeoIndexR/reference/calc_ndmi.md),
  and
  [`calc_bsi()`](https://sowsalim01.github.io/GeoIndexR/reference/calc_bsi.md).
- Generic band calculator
  [`calc_index()`](https://sowsalim01.github.io/GeoIndexR/reference/calc_index.md).
- Centralized metadata catalog via
  [`index_registry()`](https://sowsalim01.github.io/GeoIndexR/reference/index_registry.md)
  and
  [`list_indices()`](https://sowsalim01.github.io/GeoIndexR/reference/list_indices.md).
- Sensor presets for Sentinel-2, Landsat-8/9, and Landsat-5/7 via
  [`band_mapping()`](https://sowsalim01.github.io/GeoIndexR/reference/band_mapping.md).
- Numerical safety: safe division preventing zero-division crashes or
  silent infinite values.
- Summary statistics with
  [`index_summary()`](https://sowsalim01.github.io/GeoIndexR/reference/index_summary.md)
  and thematic visualization with
  [`plot_index()`](https://sowsalim01.github.io/GeoIndexR/reference/plot_index.md).
- Bundled lightweight synthetic dataset `example_multispectral`.
- Complete testthat test suite and 4 vignettes.
