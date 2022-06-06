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
        stop("Only rotors with 4-48 buckets are supported\n")
    }
    prime <- unique(factors(n)) #balanced set of ? tubes (a kind)
    scalar <- mapply(seq, 0, n / prime, SIMPLIFY = FALSE) #how many sets can be created
    coeff <- do.call(expand.grid, scalar) #how many sets of each kind
    LC <- apply(coeff, 1, function(x) dot(x, prime)) #linear combination - total no. of tubes

    k.valid <- vector()
    for (i in 1:n) {
        if (i %in% LC & (n - i) %in% LC) { #check if both k and n-k appear
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
            bucket <- data.frame()
            visual <- list()

            idx <- which(LC == k) #where k appears in the linear combination list

            for (j in seq_along(idx)) { #each time k appears
                cof <- coeff[idx[j], ] #how many sets of each kind
                count <- 0
                stime <- Sys.time()
                etime <- Sys.time()
                while (k != count) { #do until total no. of filled holes reach k
                    if (etime - stime >= elapse) { #give up if taking so much time
                        loaded <- rep(NA, k)
                        break
                    }
                    loaded <- unique(unlist(mapply(sample, RotSym, cof))) #random sampling to fill holes
                    count <- length(loaded)
                    etime <- Sys.time()
                }
                decompose <- rbind(decompose, cof) #how many sets of each kind - summary
                bucket <- rbind(bucket, loaded) #corresponding holes

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
                        # main = paste("Rotor with", n, "buckets"),
                        main = detail,
                        cex.main=1.5
                    )
                    # par(new=TRUE)
                    # pie(
                    #     rep(1, n),
                    #     labels = NA,
                    #     radius = 0.75,
                    #     clockwise = TRUE,
                    #     init.angle = 90 + 180 / n,
                    #     col = 0,
                    #     border = "black"
                    # )
                    p <- recordPlot()
                    visual[[j]] <- p
                }



            }

            colnames(decompose) <- prime
            colnames(bucket) <- NULL
            rownames(bucket) <- idx
            names(visual) <- idx
            load <- list(k = k, decompose = decompose, bucket = bucket, visual = visual)
            rs <- list(check = check, load = load)

        } else {
            message(paste(
                "CANNOT load", k, "tubes in a rotor with", n, "buckets\n"
            ))
        }
    }

    rs
}

