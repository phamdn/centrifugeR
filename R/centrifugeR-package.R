#' centrifugeR: Balancing Centrifuge Rotors
#'
#' Find the numbers of tubes that can be loaded in centrifuge rotors and give
#' the instructions on how to balance these tubes in cases of equal or unequal
#' masses. The methods of the package are constructed based on Sivek (2010)
#' <doi:10.1515/integ.2010.031> and Peil and Hauryliuk (2010) <arXiv:1004.3671>.
#'
#' @author Duy Nghia Pham \email{nghiapham@@yandex.com}
#' @docType package
#' @name centrifugeR-package
#' @section Guidelines: centrifugeR provides you with three functions that help
#'   obtain the perfect centrifuge balance. If you do not know how many tubes
#'   can be loaded into your centrifuge rotor in a single operation, you should
#'   use \code{\link{rotorCheck}}. After you have in mind the number of tubes
#'   that you want to load, you can use \code{\link{rotorEqual}} to balance them
#'   in the rotor given that your tubes have the same mass. If the masses of
#'   your tubes are not the same, you may want to use \code{\link{rotorUnequal}}
#'   to know which tubes must be increased in mass before they can be loaded.
#' @section Copyright: centrifugeR: Balancing Centrifuge Rotors. Copyright (C)
#'   2019  Duy Nghia Pham \cr \cr centrifugeR is free software: you can
#'   redistribute it and/or modify it under the terms of the GNU General Public
#'   License as published by the Free Software Foundation, either version 3 of
#'   the License, or (at your option) any later version. \cr \cr centrifugeR is
#'   distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
#'   without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
#'   PARTICULAR PURPOSE.  See the GNU General Public License for more details.
#'   \cr \cr You should have received a copy of the GNU General Public License
#'   along with centrifugeR.  If not, see \url{https://www.gnu.org/licenses/}.
#'
#' @importFrom grDevices palette rainbow
#' @importFrom graphics pie
#' @importFrom utils capture.output
#' @importFrom pracma factors dot
NULL
