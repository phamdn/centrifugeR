#' Verify Centrifuge Balance
#'
#' \code{rotorVerify} checks whether the rotor is balanced given the positions
#' of tubes of equal mass.
#'
#' @param n an integer, the number of rotor buckets.
#' @param pos an integer vector, the positions of tubes.
#'
#' @details The number of rotor buckets \code{n} ranges from \code{4} to
#'   \code{48}. The positions of tubes \code{pos} ranges from 1 to \code{n}.
#'
#' @return \code{rotorVerify} returns \code{1} if the rotor is balanced and
#'   \code{0} if the rotor is unbalanced.
#'
#' @references Johnsson M. Balancing a centrifuge. R-bloggers. 2016. Available
#'   from: \url{https://www.r-bloggers.com/2016/06/balancing-a-centrifuge/}.
#'
#' @seealso \code{\link{rotorCheck}} for checking centrifuge rotors.
#'
#' @examples
#' rotorVerify(30, c(10, 20, 30))
#' rotorVerify(30, c(1, 11, 21, 4, 28))
#'
#' @export
rotorVerify <- function (n, pos) {
    if (n < 4 | n > 48) {
        stop("The rotor must have at least 4 buckets and no more than 48 buckets. \n")
    }
    k <- length(pos)
    if (k == 0 | k > n) {
        stop("The number of tubes must neither be 0 nor greater than the number of rotor buckets. \n")
    }
    if (sum(pos < 1 | pos > n | pos != floor(pos) | duplicated(pos)) > 0) {
        stop("The positions of tubes must be different integers ranging from 1 to n. \n")
    }
    prime <- unique(factors(n))
    coeff <- mapply(seq, 0, n / prime, SIMPLIFY = FALSE)
    coeff.com <- do.call(expand.grid, coeff)
    linear <- apply(coeff.com, 1, function(x) dot(x, prime))
    if (!k %in% linear | !(n - k) %in% linear) {
        stop(paste("CANNOT load", k, "tubes in a rotor with", n, "buckets. \n"))
    }
    p2c <- function(x){
        theta <- (x - 1) * 2 * pi / n
        c(cos(theta), sin(theta))
    }
    if (sum(abs(rowSums(sapply(pos, p2c))) < 10^-10) == 2) {
        message("The rotor is balanced")
        result <- 1
    } else {
        message("The rotor is unbalanced")
        result <- 0
    }
    result
}
