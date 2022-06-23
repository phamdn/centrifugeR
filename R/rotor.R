#' Balance Tubes Using Higher-Order Symmetrical Configurations
#'
#' \code{rotor} returns the numbers of tubes that can and cannot be loaded
#' in a centrifuge rotor and optionally shows various ways to balance a certain
#' number of tubes.
#'
#' @param n an integer, the number of rotor holes.
#' @param k an integer, the number of tubes (optional).
#' @param seed an integer, the seed for random number generation. Setting a seed
#'   ensures the reproducibility of the result. See \code{\link{set.seed}} for
#'   more details.
#' @param elapse an integer, the constrained time in seconds for random sampling.
#'
#' @details The number of rotor holes \code{n} ranges from \code{4} to
#'   \code{48}.
#'
#' @return \code{rotor} returns a list with two components:
#'   \item{\code{check}}{a list with three components:
#'   \describe{\item{\code{n}}{the number of rotor holes.}
#'   \item{\code{valid}}{a vector containing the numbers of tubes that can be
#'   loaded.}
#'   \item{\code{invalid}}{a vector containing the numbers of tubes that cannot be
#'   loaded.}}
#'   } \item{\code{load}}{a list with three components:
#'   \describe{
#'   \item{\code{k}}{the number of tubes.}
#'   \item{\code{decompose}}{a data frame showing different ways to decompose \code{k}.}
#'   \item{\code{hole}}{a data frame showing hole positions to load tubes.}
#'   \item{\code{visual}}{a list of rotor images showing hole positions to load tubes.}
#'   }
#'   }
#'
#' @references Sivek G. On vanishing sums of distinct roots of unity. Integers.
#'   2010;10(3):365-8. \cr \cr Peil O, Hauryliuk V. A new spin on spinning your
#'   samples: balancing rotors in a non-trivial manner. arXiv preprint
#'   arXiv:1004.3671. 2010 Apr 21.
#'
#' @seealso \code{\link{rotorVerify}} for verifying the balance of pre-existing
#'   tube configurations.
#'
#' @examples
#' rotor(30, 7)
#'
#' @export
rotor <- function (n, k = NULL, seed = 1, elapse = 1) {
    set.seed(seed)
    sasha <- #https://sashamaps.net/docs/resources/20-colors/
        c(
            '#e6194B',
            '#3cb44b',
            '#ffe119',
            '#4363d8',
            '#f58231',
            '#911eb4',
            '#42d4f4',
            '#f032e6',
            '#bfef45',
            '#fabed4',
            '#469990',
            '#dcbeff',
            '#9A6324',
            '#fffac8',
            '#800000',
            '#aaffc3',
            '#808000',
            '#ffd8b1',
            '#000075',
            '#a9a9a9',
            '#ffffff',
            '#000000'
        )
    if (n < 4 | n > 48) {
        stop("Only rotors with 4-48 holes are supported\n")
    }
    prime <- unique(factors(n))
    scalar <- mapply(seq, 0, n / prime, SIMPLIFY = FALSE)
    coeff <- do.call(expand.grid, scalar)
    LC <- apply(coeff, 1, function(x) dot(x, prime))

    k.valid <- vector()
    for (i in 1:n) {
        if (i %in% LC & (n - i) %in% LC) {
            k.valid <- c(k.valid, i)
        }
    }

    check <- list(n=n, valid = k.valid, invalid = setdiff(1:n, k.valid))
    rs <- list(check = check)

    if (!missing(k)) { #if users input k
        if (k %in% k.valid) { #if k works
           # resample <- function(x) x[sample.int(length(x), 1)]
            RotSym <- lapply(prime, function(x) asplit(matrix(1:n, n / x, x), 1)) #possible holes for each kind

            decompose <- data.frame()
            hole <- data.frame()
            visual <- list()

            idx <- which(LC == k) #where k appears in the linear combination list

            for (j in seq_along(idx)) { #each time k appears
                cof <- coeff[idx[j], ] #how many sets of each conf. kind
                count <- 0
                # loaded <- vector()
                stime <- Sys.time()
                etime <- Sys.time()
                while (k != count || !1 %in% loaded) { #do until total no. of filled holes reach k
                    if (etime - stime >= elapse) { #give up if taking so much time
                        loaded <- rep(NA, k)
                        break
                    }
                    loaded <- unique(unlist(mapply(sample, RotSym, cof))) #random sampling to fill holes
                    count <- length(loaded)
                    etime <- Sys.time()
                }
                decompose <- rbind(decompose, cof) #how many sets of each kind - summary
                hole <- rbind(hole, loaded) #corresponding holes

                if (any(is.na(loaded))) { #if fail to fill holes, draw nothing
                    visual[[j]] <- NA
                } else {

                    k.str <- rep(prime, cof) #breakdown structure of that k tube
                    col.code <- integer(n)
                    col.code[loaded] <- rep(seq_along(k.str), k.str) #color the filled holes
                    if (length(k.str) > 1) palette(sasha) else palette("default") #just use black for simple structure
                    on.exit(palette("default"), add = TRUE)
                    detail <- character()
                    for (i in seq_along(prime)) { #write caption
                        if (as.integer(cof[i]) > 0) {
                            detail <- paste(detail, paste(as.integer(cof[i]), "\u00D7", prime[i], "tubes +"), sep =" ")
                        }
                    }
                    detail <- substring(detail,1, nchar(detail)-1) #delete the + at right end

                    pie2( #draw the rotor
                        rep(1, n),
                        radius = 1,
                        clockwise = TRUE,
                        init.angle = 90 + 180 / n,
                        col = col.code,
                        border = "black",
                        main = detail
                    )

                    par(new=TRUE)
                    pie2(
                        rep(1, n),
                        labels = NA,
                        radius = 0.05,
                        clockwise = TRUE,
                        init.angle = 90 + 180 / n,
                        col = "white",
                        border = "white"
                    )
                    p <- recordPlot()

                    visual[[j]] <- p

                }



            }

            colnames(decompose) <- prime
            colnames(hole) <- NULL
            rownames(hole) <- idx
            names(visual) <- idx
            load <- list(k = k, decompose = decompose, hole = hole, visual = visual)
            rs <- list(check = check, load = load)

        } else {
            message(paste(
                "CANNOT load", k, "tubes in a rotor with", n, "holes\n"
            ))
        }
    }

    rs
}
