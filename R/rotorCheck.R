#' Check Centrifuge Rotors
#'
#' \code{rotorCheck} returns the numbers of tubes that can and cannot be loaded
#' in a single operation.
#'
#' @param n an integer, the number of rotor buckets.
#' @param k an integer, the number of tubes.
#'
#' @details The number of rotor buckets \code{n} ranges from \code{4} to
#'   \code{48}. \cr\cr If \code{k} is specified, \code{rotorCheck} will check
#'   whether the input number of tubes can be loaded or not.
#'
#' @return \code{rotorCheck} returns a list with two components:
#'   \item{\code{valid}}{a vector containing the numbers of tubes that can be
#'   loaded.} \item{\code{invalid}}{a vector containing the numbers of tubes
#'   that cannot be loaded.}
#'
#' @references Sivek G. On vanishing sums of distinct roots of unity. Integers.
#'   2010;10(3):365-8.
#'
#' @seealso \code{\link{rotorEqual}} for balancing tubes of equal mass and
#'   \code{\link{rotorUnequal}} for balancing tubes of unequal mass.
#'
#' @export
rotorCheck <- function (n, k = NULL) {
    .Deprecated("rotor")
    if (n < 4 | n > 48) {
        stop("Only rotors with 4-48 buckets are supported. \n")
    }
    prime <- unique(factors(n))
    coeff <- mapply(seq, 0, n / prime, SIMPLIFY = FALSE)
    coeff.com <- do.call(expand.grid, coeff)
    linear <- apply(coeff.com, 1, function(x) dot(x, prime))
    k.valid <- vector()
    for (i in 0:n) {
        if (i %in% linear & (n - i) %in% linear) {
            k.valid <- c(k.valid, i)
        }
    }
    if (!missing(k)) {
        if (k %in% k.valid) {
            message(paste(
                "CAN load", k, "tubes in a rotor with", n, "buckets. \n"
            ))
        } else {
            message(paste(
                "CANNOT load", k, "tubes in a rotor with", n, "buckets. \n"
            ))
        }
    }
    list(valid = k.valid, invalid = setdiff(0:n, k.valid))
}
