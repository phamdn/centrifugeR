#' centrifugeR: Non-Trivial Balance of Centrifuge Rotors
#'
#' Find the numbers of tubes that can be loaded in centrifuge rotors in a single
#' operation and show how to balance these tubes in cases of equal or unequal
#' masses. Refer to Pham (2020) <doi:10.31224/osf.io/4xs38> for more information
#' on package functionality.
#'
#' @author Duy Nghia Pham \email{nghiapham@@yandex.com}
#'
#' @docType package
#'
#' @name centrifugeR-package
#'
#' @section Guidelines: centrifugeR helps obtain the perfect centrifuge balance.
#'   First, call \code{\link{rotorCheck}} to know how many tubes can be loaded
#'   into the rotor in a single operation. Use \code{\link{rotorEqual}} to
#'   balance these tubes given that they have the same mass. If their masses are
#'   not the same, use \code{\link{rotorUnequal}} to know which tubes must be
#'   increased in mass before they can be loaded. Also, call
#'   \code{\link{rotorSpeed}} if RPM/RCF conversion is needed.
#'
#' @section Copyright: centrifugeR: Non-Trivial Balance of Centrifuge Rotors.
#'   Copyright (C) 2019  Duy Nghia Pham \cr \cr centrifugeR is free software:
#'   you can redistribute it and/or modify it under the terms of the GNU General
#'   Public License as published by the Free Software Foundation, either version
#'   3 of the License, or (at your option) any later version. \cr \cr
#'   centrifugeR is distributed in the hope that it will be useful, but WITHOUT
#'   ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#'   FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
#'   more details. \cr \cr You should have received a copy of the GNU General
#'   Public License along with centrifugeR.  If not, see
#'   \url{https://www.gnu.org/licenses/}.
#'
#' @importFrom grDevices palette rainbow
#' @importFrom graphics pie
#' @importFrom utils capture.output
#' @importFrom pracma factors dot
NULL
