#' This is an internal function to split names into their respective parts. It can not be called directly by the user
#'
#' \code{split_names} This is an internal function to split names into their respective parts. It is used internally only
#'
#' @param x simply a vector containing a character of a name in the form 'last, first, middle'. Can parse out names with no middle names.
#' 
#' Currently it does not reliably distinguish between a second last names and middle names. In most cases it will call the first last name an additional middle name. Also jrs, srs, etc are considered middle names for the sake of ease.
#' @noRd

split_names <- function(x) {
  first <- NA
  middle <- NA
  last <- NA
  # split first by commas, as we assume this is atleast seperating the
  # last name from the rest of the information
  first.split <- strsplit(x, ",")

  # If they split them by spaces instead of commas we need to adjust

  if (length(first.split[[1]]) == 1) {
    first.split <- strsplit(x, " ")
  }
  # we are going to assume the very first split before the comma is
  # the last name
  last <- first.split[[1]][1]

  # Since we've already split by commas, the next most comma split
  # is by spaces. This can be dangerous if someone has a space in
  # their first name, for now we'll assume it doesnt
  second.split <- strsplit(first.split[[1]][-1], " ")
  # delete trailing spaces (maybe a better way to do that)
  second.split <- unlist(second.split)
  second.split <- second.split[nchar(second.split) > 0]

  # Now we need to duble check there isnt a period seperator
  if (length(second.split) == 1) {
    second.split <- strsplit(second.split[[1]], "\\.")
    second.split <- unlist(second.split)
    second.split <- second.split[nchar(second.split) > 0]
  }
  # now we assume that the first name after the first comma is
  # the first name, this is pretty standard so it should be safe
  # enough of an assumption.
  # However because we often have First initials and middle intials
  # shoved together with no space we have to specify lower case
  first <- regmatches(second.split, regexpr("[A-Z][a-z]*", second.split))[1]

  # Middle names are messy because they have multiple parts, spaces, names
  # we'll just shove names together, even though this might not be 'correct'
  # We're taking out jrs and seniors for the sake of analysis
  if (length(second.split) > 1) {
    third.split <- second.split[-1]
    third.split <- third.split[
      !grepl("^jr\\b|^sr\\b|^ii$|^iii|^iv\\b|^v\\b",
        tolower(unlist(third.split)))
      ]
    middle <- gsub("[\\./,]", "", paste0(third.split, collapse = ""))
  }
  # Check if first and middle names are just initials
  # and not seperated by period

  if (length(second.split) > 0 && any(grepl("[A-Z][A-Z]", second.split))) {
    middle <- substr(second.split, 2, nchar(second.split))[1]
  }
  return(c(first = first, middle = middle, last = last))
}
