#' Balance Tubes of Equal Mass
#'
#' \code{rotorEqual} returns the positions of rotor buckets that must be loaded
#' or empty to balance tubes of equal mass.
#'
#' @param n an integer, the number of rotor buckets.
#' @param k an integer, the number of tubes.
#'
#' @details The number of rotor buckets \code{n} ranges from \code{4} to
#'   \code{48}. The number of tubes \code{k} must be greater than \code{0} and
#'   smaller than the number of rotor buckets \code{n}.
#' @return \code{rotorEqual} returns a list with two components:
#'   \item{\code{loaded}}{a vector containing the positions of rotor buckets
#'   that must be loaded.} \item{\code{empty}}{a vector containing the positions
#'   of rotor buckets that must be empty.} \code{rotorEqual} also plots a
#'   schematic diagram of the centrifuge rotor.
#' @references Sivek G. On vanishing sums of distinct roots of unity. Integers.
#'   2010;10(3):365-8. \cr \cr Peil O, Hauryliuk V. A new spin on spinning your
#'   samples: balancing rotors in a non-trivial manner. arXiv preprint
#'   arXiv:1004.3671. 2010 Apr 21.
#' @seealso \code{\link{rotorCheck}} for checking centrifuge rotors and
#'   \code{\link{rotorUnequal}} for balancing tubes of unequal mass.
#' @examples
#' rotorEqual(30, 11)
#' rotorEqual(30, 19)
#' @export
rotorEqual <- function (n, k) {
    if (n < 4 | n > 48) {
        stop("The centrifuge rotor must have at least 4 buckets and no more than 48 buckets \n")
    }
    if (k <= 0 | k >= n) {
        stop("The number of tubes must be greater than 0 and smaller than the number of rotor buckets \n")
    }
    prime <- unique(factors(n))
    coeff <- mapply(seq, 0, n / prime, SIMPLIFY = FALSE)
    coeff.com <- do.call(expand.grid, coeff)
    linear <- apply(coeff.com, 1, function(x) dot(x, prime))
    if (!k %in% linear | !(n - k) %in% linear) {
        stop(paste("CANNOT load", k, "tubes in a centrifuge rotor with", n, "buckets \n"))
    }
    if (k > n / 2) k.star <- n - k else k.star <- k
    resample <- function(x) x[sample.int(length(x), 1)]
    prime.pos <- lapply(prime, function(x) asplit(matrix(1:n, n / x, x), 1))
    count <- 0
    while (k.star != count) {
        coeff.def <- coeff.com[resample(which(linear == k.star)), ]
        k.pos <- unique(unlist(mapply(sample, prime.pos, coeff.def)))
        count <- length(k.pos)
    }
    loaded <- vector(); empty <- vector()
    if (k > n / 2) {
        col.code <- rep("green", n)
        col.code[k.pos] <- "red3"
        empty <- sort(k.pos)
        loaded <- setdiff(1:n, k.pos)
    } else {
        col.code <- rep("red3", n)
        col.code[k.pos] <- "green"
        loaded <- sort(k.pos)
        empty <- setdiff(1:n, k.pos)
    }
    pie(rep(1, n), radius = 1, clockwise = TRUE, init.angle = 90 + 180 / n,
        col = col.code, border = "white",
        main = paste("Centrifuge rotor with", n, "buckets"),
        sub = paste(k, "loaded buckets (in green) and", n - k, "empty buckets (in red)"))
    list(loaded = loaded, empty = empty)
}
