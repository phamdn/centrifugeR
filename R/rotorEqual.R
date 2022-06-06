#' Balance Tubes of Equal Mass
#'
#' \code{rotorEqual} returns the positions of rotor buckets that must be loaded
#' or empty to balance tubes of equal mass.
#'
#' @param n an integer, the number of rotor buckets.
#' @param k an integer, the number of tubes.
#' @param seed an integer, the seed for random number generation. Setting a seed
#'   ensures the reproducibility of the result. See \code{\link{set.seed}} for
#'   more details.
#'
#' @details The number of rotor buckets \code{n} ranges from \code{4} to
#'   \code{48}. The number of tubes \code{k} must be greater than \code{0} and
#'   smaller than the number of rotor buckets \code{n}.
#'
#' @return \code{rotorEqual} returns a list with two components:
#'   \item{\code{loaded}}{a vector containing the positions of rotor buckets
#'   that must be loaded.} \item{\code{empty}}{a vector containing the positions
#'   of rotor buckets that must be empty.} \code{rotorEqual} also plots a
#'   schematic diagram of the centrifuge rotor.
#'
#' @references Sivek G. On vanishing sums of distinct roots of unity. Integers.
#'   2010;10(3):365-8. \cr \cr Peil O, Hauryliuk V. A new spin on spinning your
#'   samples: balancing rotors in a non-trivial manner. arXiv preprint
#'   arXiv:1004.3671. 2010 Apr 21.
#'
#' @seealso \code{\link{rotorCheck}} for checking centrifuge rotors and
#'   \code{\link{rotorUnequal}} for balancing tubes of unequal mass.
#'
#' @export
rotorEqual <- function (n, k, seed = 2019) {
    .Deprecated("rotor")
    set.seed(seed)
    if (n < 4 | n > 48) {
        stop("Only rotors with 4-48 buckets are supported. \n")
    }
    if (k <= 0 | k >= n) {
        stop("The number of tubes must be greater than 0 and smaller than the number of rotor buckets. \n")
    }
    prime <- unique(factors(n))
    coeff <- mapply(seq, 0, n / prime, SIMPLIFY = FALSE)
    coeff.com <- do.call(expand.grid, coeff)
    linear <- apply(coeff.com, 1, function(x) dot(x, prime))
    if (!k %in% linear | !(n - k) %in% linear) {
        stop(paste(
            "CANNOT load", k, "tubes in a rotor with", n, "buckets. \n"
        ))
    }
    k.star <- ifelse(k > n / 2, n - k, k)
    resample <- function(x) x[sample.int(length(x), 1)]
    prime.pos <- lapply(prime, function(x) asplit(matrix(1:n, n / x, x), 1))
    count <- 0
    while (k.star != count) {
        coeff.def <- coeff.com[resample(which(linear == k.star)), ]
        k.pos <- unique(unlist(mapply(sample, prime.pos, coeff.def)))
        count <- length(k.pos)
    }
    loaded <- vector()
    if (k > n / 2) {
        col.code <- rep("skyblue", n)
        col.code[k.pos] <- "white"
        loaded <- setdiff(1:n, k.pos)
    } else {
        col.code <- rep("white", n)
        col.code[k.pos] <- "skyblue"
        loaded <- sort(k.pos)
    }
    pie(
        rep(1, n),
        radius = 1,
        clockwise = TRUE,
        init.angle = 90 + 180 / n,
        col = col.code,
        border = "black",
        main = paste("Rotor with", n, "buckets"),
        sub = paste(k, "loaded buckets in blue")
    )
    list(loaded = loaded, empty = setdiff(1:n, loaded))
}
