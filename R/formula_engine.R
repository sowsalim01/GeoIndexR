#' Formula Engine for Custom Spectral Indices
#'
#' Provides secure parsing, syntax tree validation, and vectorized evaluation of
#' mathematical expressions on multispectral raster layers and numeric values.
#'
#' @keywords internal

ALLOWED_OPERATORS <- c("+", "-", "*", "/", "^", "(")
ALLOWED_MATH_FUNS <- c("sqrt", "log", "log10", "exp", "abs", "min", "max", "round")

#' Extract Symbols and Validate Formula AST
#'
#' Recursively traverses the parsed formula AST to verify that only permitted
#' mathematical operators, whitelisted mathematical functions, known spectral bands,
#' and user-supplied parameters are present.
#'
#' @param formula_str Character string containing the mathematical formula.
#' @param available_bands Character vector of valid spectral band identifiers.
#' @param param_names Character vector of valid parameter names.
#'
#' @return A list containing:
#'   \item{parsed_expr}{The parsed R expression object.}
#'   \item{used_bands}{Character vector of band names referenced in the formula.}
#'   \item{used_params}{Character vector of parameter names referenced in the formula.}
#'
#' @keywords internal
parse_and_validate_formula <- function(formula_str, available_bands = character(0), param_names = character(0)) {
  if (missing(formula_str) || !is.character(formula_str) || length(formula_str) != 1 || !nzchar(trimws(formula_str))) {
    stop("Argument 'formula' must be a single non-empty character string.", call. = FALSE)
  }

  formula_str <- trimws(formula_str)

  # 1. Parse expression
  parsed <- tryCatch(
    base::parse(text = formula_str),
    error = function(e) {
      stop(sprintf("Formula syntax error in '%s': %s", formula_str, e$message), call. = FALSE)
    }
  )

  if (length(parsed) == 0) {
    stop("Formula expression is empty.", call. = FALSE)
  }

  expr <- parsed[[1]]

  # Standardize valid names to lowercase
  available_bands_lower <- tolower(available_bands)
  param_names_lower <- tolower(param_names)

  used_symbols <- character(0)

  # 2. Recursive AST Walker
  walk_ast <- function(node) {
    if (is.symbol(node)) {
      sym_str <- as.character(node)
      used_symbols <<- c(used_symbols, sym_str)
      return(invisible(TRUE))
    }

    if (is.numeric(node) || is.integer(node) || is.logical(node)) {
      return(invisible(TRUE))
    }

    if (is.call(node)) {
      fn_node <- node[[1]]

      if (!is.symbol(fn_node)) {
        stop(sprintf("Invalid function call structure in formula '%s'.", formula_str), call. = FALSE)
      }

      fn_name <- as.character(fn_node)

      # Check if operator / function is allowed
      if (!fn_name %in% c(ALLOWED_OPERATORS, ALLOWED_MATH_FUNS)) {
        stop(
          sprintf(
            "Forbidden or unknown function/operator '%s' in formula '%s'.\nAllowed operators: %s\nAllowed functions: %s",
            fn_name, formula_str,
            paste(ALLOWED_OPERATORS, collapse = ", "),
            paste(ALLOWED_MATH_FUNS, collapse = ", ")
          ),
          call. = FALSE
        )
      }

      # Recursively inspect arguments
      if (length(node) > 1) {
        for (i in 2:length(node)) {
          walk_ast(node[[i]])
        }
      }
      return(invisible(TRUE))
    }

    # If node is of unexpected type (e.g. character literal inside formula)
    stop(sprintf("Unsupported syntax element '%s' in formula '%s'.", deparse(node), formula_str),
         call. = FALSE)
  }

  walk_ast(expr)

  used_symbols <- unique(used_symbols)
  used_symbols_lower <- tolower(used_symbols)

  # Check symbols against available bands and params
  used_bands <- used_symbols[used_symbols_lower %in% available_bands_lower]
  used_params <- used_symbols[used_symbols_lower %in% param_names_lower]

  unresolved <- used_symbols[!used_symbols_lower %in% c(available_bands_lower, param_names_lower)]

  if (length(unresolved) > 0) {
    stop(
      sprintf(
        "Formula error: Unknown variable(s) %s in formula '%s'.\nAvailable bands: %s\nAvailable parameters: %s",
        paste0("'", unresolved, "'", collapse = ", "),
        formula_str,
        if (length(available_bands) > 0) paste(available_bands, collapse = ", ") else "none",
        if (length(param_names) > 0) paste(param_names, collapse = ", ") else "none"
      ),
      call. = FALSE
    )
  }

  list(
    parsed_expr = expr,
    used_bands = used_bands,
    used_params = used_params
  )
}

#' Safely Evaluate Formula on Bands and Parameters
#'
#' Evaluates a validated AST expression in a controlled, isolated environment containing
#' only the raster/numeric bands, supplied parameters, and safe mathematical operators.
#'
#' @param parsed_expr Parsed language expression.
#' @param band_layers Named list of \code{SpatRaster} or numeric band values.
#' @param params Named list of numeric parameter constants.
#' @param denominator_tolerance Tolerance for near-zero denominators. Defaults to \code{1e-6}.
#'
#' @return A \code{SpatRaster} or numeric result.
#'
#' @keywords internal
evaluate_custom_formula <- function(parsed_expr, band_layers, params = list(), denominator_tolerance = 1e-6) {
  eval_env <- new.env(parent = emptyenv())

  # 1. Inject bands (both exact name and lowercase aliases)
  for (b_name in names(band_layers)) {
    eval_env[[b_name]] <- band_layers[[b_name]]
    eval_env[[tolower(b_name)]] <- band_layers[[b_name]]
  }

  # 2. Inject parameters (both exact name and lowercase aliases)
  for (p_name in names(params)) {
    eval_env[[p_name]] <- params[[p_name]]
    eval_env[[tolower(p_name)]] <- params[[p_name]]
  }

  # 3. Inject safe division operator
  eval_env[["/"]] <- function(e1, e2) {
    safe_divide(e1, e2, tol = denominator_tolerance)
  }

  # 4. Inject standard allowed math functions
  eval_env[["+"]] <- `+`
  eval_env[["-"]] <- `-`
  eval_env[["*"]] <- `*`
  eval_env[["^"]] <- `^`
  eval_env[["("]] <- `(`
  eval_env[["sqrt"]] <- sqrt
  eval_env[["log"]] <- log
  eval_env[["log10"]] <- log10
  eval_env[["exp"]] <- exp
  eval_env[["abs"]] <- abs
  eval_env[["min"]] <- min
  eval_env[["max"]] <- max
  eval_env[["round"]] <- round

  # Evaluate expression
  res <- tryCatch(
    eval(parsed_expr, envir = eval_env),
    error = function(e) {
      stop(sprintf("Failed to evaluate formula: %s", e$message), call. = FALSE)
    }
  )

  # Clean non-finite values if any remain
  if (inherits(res, "SpatRaster")) {
    res <- terra::ifel(is.infinite(res) | is.nan(res), NA, res)
  } else if (is.numeric(res)) {
    res[is.infinite(res) | is.nan(res)] <- NA
  }

  res
}
