# Sensor Band Mapping Presets

Provides standard band name mappings for commonly used multispectral
sensors and generic naming conventions.

## Usage

``` r
band_mapping(
  sensor = c("generic", "sentinel2", "s2", "landsat8", "landsat9", "l8", "l9",
    "landsat7", "landsat5", "tm", "etm")
)
```

## Arguments

- sensor:

  Character string specifying the sensor preset. Supported options:

  - `"generic"`: Common names (`blue`, `green`, `red`, `nir`, `swir`,
    `swir1`, `swir2`, `rededge`).

  - `"sentinel2"` or `"s2"`: Sentinel-2 MSI bands (`B02`, `B03`, `B04`,
    `B08`, `B11`, `B12`, etc.).

  - `"landsat8"` / `"landsat9"` or `"l8"` / `"l9"`: Landsat 8/9 OLI
    bands (`B1` to `B7`).

  - `"landsat7"` / `"landsat5"` or `"etm"` / `"tm"`: Landsat 4-7 TM/ETM+
    bands (`B1` to `B7`).

  Defaults to `"generic"`.

## Value

A named character vector where names represent standardized spectral
band roles (e.g., `"nir"`, `"red"`) and values represent corresponding
band or layer names for the selected sensor.

## Examples

``` r
# Generic mapping
band_mapping("generic")
#>       blue      green        red        nir       nir2       swir      swir1 
#>     "blue"    "green"      "red"      "nir"     "nir2"     "swir"    "swir1" 
#>      swir2    rededge   rededge1   rededge2   rededge3    thermal 
#>    "swir2"  "rededge" "rededge1" "rededge2" "rededge3"  "thermal" 

# Sentinel-2 band mapping
band_mapping("sentinel2")
#>    coastal       blue      green        red   rededge1   rededge2   rededge3 
#>      "B01"      "B02"      "B03"      "B04"      "B05"      "B06"      "B07" 
#>        nir       nir2   rededge4 watervapor     cirrus      swir1      swir2 
#>      "B08"      "B8A"      "B8A"      "B09"      "B10"      "B11"      "B12" 
#>       swir 
#>      "B11" 

# Landsat 8/9 band mapping
band_mapping("landsat8")
#>  coastal     blue    green      red      nir    swir1    swir2      pan 
#>     "B1"     "B2"     "B3"     "B4"     "B5"     "B6"     "B7"     "B8" 
#>   cirrus thermal1 thermal2  thermal     swir 
#>     "B9"    "B10"    "B11"    "B10"     "B6" 
```
