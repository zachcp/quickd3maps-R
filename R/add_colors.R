#' add_colors
#'
#' @importFrom  leaflet colorNumeric
#' @importFrom  leaflet colorBin
#' @importFrom  leaflet colorQuantile
#' @importFrom  leaflet colorFactor
#'
#' @export
add_colors <- function(bmap, colorcol, datatype="categorical" ) {
  # "categorical"
  # "continuous"
  # "binned"
  # "quantile"

  #colorFactor <- function(palette, domain, levels = NULL, ordered = FALSE,
  #                        na.color = "#808080", alpha = FALSE, reverse = FALSE) {


  data      <- bmap$x$data
  newcolors <- colorFactor(palette="RdYlBu", domain = data[[colorcol]])
  print(newcolors)
  bmap$x$data$colors <- newcolors(data[[colorcol]])
  print(bmap$x$data$colors)
  bmap
}


