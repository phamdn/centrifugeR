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
    if (sum(pos < 1 | pos > n | pos != floor(pos) | duplicated(pos)) > 0) {
        stop(paste("The positions of tubes must be different integers ranging from 1 to", n, "\n"))
    }
    result <- ifelse(sum(abs(rowSums(sapply(pos, p2c, n))) < 1e-10) == 2, 1, 0)
    result
}
