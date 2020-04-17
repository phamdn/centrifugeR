#' Balance Tubes of Unequal Mass
#'
#' \code{rotorUnequal} returns the required masses and the positions of tubes of
#' unequal initial mass.
#'
#' @param n an integer, the number of rotor buckets.
#' @param mass a numeric vector with optional \code{names} attribute, the masses
#'   (and optional names) of tubes.
#'
#' @details The number of rotor buckets \code{n} ranges from \code{4} to
#'   \code{48}. The number of tubes (i.e. \code{length(mass)}) should not be
#'   greater than the number of rotor buckets \code{n}. \cr \cr If \code{mass}
#'   is not specified, the names and the masses of tubes must then be taken from
#'   the keyboard. In case \code{mass} has no \code{names} attribute, tubes will
#'   be named automatically (i.e. \code{S1, S2, S3, } etc.).
#'
#' @return \code{rotorUnequal} returns a data frame with three columns:
#'   \item{\code{initial}}{a vector containing the initial masses of tubes.}
#'   \item{\code{required}}{a vector containing the required masses of tubes.}
#'   \item{\code{position}}{a vector containing the bucket positions of tubes.}
#'   \code{rotorUnequal} also plots a schematic diagram of the centrifuge rotor.
#'
#' @references Sivek G. On vanishing sums of distinct roots of unity. Integers.
#'   2010;10(3):365-8. \cr \cr Peil O, Hauryliuk V. A new spin on spinning your
#'   samples: balancing rotors in a non-trivial manner. arXiv preprint
#'   arXiv:1004.3671. 2010 Apr 21.
#'
#' @seealso \code{\link{rotorCheck}} for checking centrifuge rotors and
#'   \code{\link{rotorEqual}} for balancing tubes of equal mass.
#'
#' @examples
#' # Call the function then input the names and the masses of tubes
#' rotorUnequal(30)
#' liver
#' 10.05
#' gill
#' 9.68
#' muscle
#' 9.88
#'
#' # Prepare the masses of tubes then call the function
#' samples <- round(rnorm(19, mean = 10, sd = 0.5), 2)
#' rotorUnequal(30, samples)
#'
#' # Prepare the masses and the names of tubes then call the function
#' small.samples <- c(10.05, 9.68, 9.88)
#' names(small.samples) <- c("liver", "gill", "muscle")
#' rotorUnequal(30, small.samples)
#'
#' @export
rotorUnequal <- function (n, mass = NULL) {
    if (n < 4 | n > 48) {
        stop("The rotor must have at least 4 buckets and no more than 48 buckets. \n")
    }
    if (missing(mass)) {
        message("For each line, input the one-word name and the mass of one tube separated by a whitespace (e.g. lizard 9.81). Press ENTER to start a new line or press ENTER two times to finish. \n")
        input <- scan("", list(character(), numeric()))
        mass <- "names<-"(input[[2]], input[[1]])
    }
    if (sum(mass <= 0) > 0) {
        warning("Mass values should be positive. \n")
    }
    if (is.null(names(mass))) {
        nm <- vector()
        for (i in seq(length(mass))) {
            nm = c(nm, paste("S", i, sep = ""))
        }
        names(mass) <- nm
    }
    k <- length(mass)
    if (k == 0 | k > n) {
        stop("The number of tubes must not be 0 or greater than the number of rotor buckets. \n")
    }
    prime <- unique(factors(n))
    coeff <- mapply(seq, 0, n / prime, SIMPLIFY = FALSE)
    coeff.com <- do.call(expand.grid, coeff)
    linear <- apply(coeff.com, 1, function(x) dot(x, prime))
    if (!k %in% linear | !(n - k) %in% linear) {
        stop(paste("CANNOT load", k, "tubes in a rotor with", n, "buckets. \n"))
    }
    resample <- function(x) x[sample.int(length(x), 1)]
    prime.pos <- lapply(prime, function(x) asplit(matrix(1:n, n / x, x), 1))
    count <- 0
    while (k != count) {
        coeff.def <- coeff.com[resample(which(linear == k)), ]
        k.pos <- unique(unlist(mapply(sample, prime.pos, coeff.def)))
        count <- length(k.pos)
    }
    k.str <- rep(prime, coeff.def)
    col.code <- integer(n)
    col.code[k.pos] <- rep(seq_along(k.str), k.str)
    detail <- character()
    for (i in seq_along(prime)) {
        if (as.integer(coeff.def[i]) > 0) {
            detail <- paste(detail, paste("[", as.integer(coeff.def[i]), "sets of", prime[i], "tubes ]"), sep = "")
        }
    }
    if (length(k.str) > 1) palette(rainbow(length(k.str))) else palette("default")
    on.exit(palette("default"), add = TRUE)
    pie(
        rep(1, n),
        radius = 1,
        clockwise = TRUE,
        init.angle = 90 + 180 / n,
        col = col.code,
        border = "black",
        main = paste("Rotor with", n, "buckets"),
        sub = detail
    )
    mass.order <- sort(mass)
    mass.split <- split(mass.order, rep(seq_along(k.str), k.str))
    names(mass.split) <- NULL
    mass.desire <- rep(sapply(mass.split, max), k.str)
    result <- cbind(as.data.frame(unlist(mass.split)), mass.desire, k.pos)
    names(result) <- c("initial", "required", "position")
    result
}
