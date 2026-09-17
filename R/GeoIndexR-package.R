#' @keywords internal
"_PACKAGE"

## usethis namespace: start
#' @import terra
#' @importFrom stats sd
#' @importFrom graphics par
## usethis namespace: end

.onLoad <- function(libname, pkgname) {
  # Ensure terra uses its compatible internal PROJ database if external system env overrides it
  terra_proj <- system.file("proj", package = "terra")
  if (nzchar(terra_proj) && dir.exists(terra_proj)) {
    # Check if PROJ_LIB points outside terra
    cur_proj <- Sys.getenv("PROJ_LIB")
    if (nzchar(cur_proj) && !identical(normalizePath(cur_proj, mustWork = FALSE),
                                      normalizePath(terra_proj, mustWork = FALSE))) {
      Sys.setenv(PROJ_LIB = terra_proj)
      Sys.setenv(PROJ_DATA = terra_proj)
    }
  }
}
NULL
