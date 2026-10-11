# Compute All Eligible Spectral Indices Automatically

Automatically detects which spectral indices can be computed given the
available bands in a
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
image (or raster file path) and calculates all of them.

## Usage

``` r
geo_index_all(
  image,
  bands = NULL,
  scale_factor = NULL,
  sensor = NULL,
  quiet = FALSE,
  ...
)
```

## Arguments

- image:

  A
  [`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  object or raster file path containing multispectral bands.

- bands:

  Optional named vector or list specifying custom band mapping.

- scale_factor:

  Optional numeric scaling divisor (e.g. `10000`).

- sensor:

  Optional character string specifying a sensor preset.

- quiet:

  Logical. If `FALSE` (default), outputs an informative message listing
  which indices were detected and computed.

- ...:

  Additional parameters passed to index calculation functions.

## Value

A multi-layer
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
containing all computable indices as individual layers.

## Examples

``` r
img <- get_example_data()

# Compute all supported indices compatible with img bands
all_idx <- geo_index_all(img)
#> Computing 16 compatible indices: NDVI, SAVI, EVI, MSAVI, OSAVI, ARVI, GNDVI, NDWI, MNDWI, AWEI, NDBI, IBI, NDMI, MSI, BSI, NDSI
names(all_idx)
#>  [1] "NDVI"  "SAVI"  "EVI"   "MSAVI" "OSAVI" "ARVI"  "GNDVI" "NDWI"  "MNDWI"
#> [10] "AWEI"  "NDBI"  "IBI"   "NDMI"  "MSI"   "BSI"   "NDSI" 
```
