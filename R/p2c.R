#' @export
p2c <- function(x, y){
    theta <- (8.5-x) * 2 * pi / y
    c(cos(theta), sin(theta))
}
