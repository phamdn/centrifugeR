#' Convert Hole Positions to Coordinates
#'
#' \code{p2c} returns the coordinates of rotor holes. This is not meant to be
#' called directly.
#'
#' @param x an integer or a vector, the hole position(s).
#' @param y an integer, the number of rotor holes.
#'
#' @return \code{p2c} returns a vector of coordinates.
#'
#' @export
p2c <- function(x, y){
    theta <- (8.5-x) * 2 * pi / y
    c(cos(theta), sin(theta))
}
