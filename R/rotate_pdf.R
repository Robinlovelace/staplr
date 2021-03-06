#' Rotate entire pdf document
#'
#' @description If the toolkit Pdftk is available in the
#' system, it will be called to rotate the entire PDF document
#'
#' See the reference for detailed usage of \code{pdftk}.
#' @param page_rotation An integer value from the vector c(0, 90, 180, 270).
#' Each option sets the page rotation as follows (in degrees):
#' north: 0, east: 90, south: 180, west: 270
#' @param input_filepath the path of the input PDF file.
#' The default is set to NULL. IF NULL, it  prompt the user to
#' select the folder interactively.
#' @param output_filepath the path of the output output PDF file.
#' The default is set to NULL. IF NULL, it  prompt the user to
#' select the folder interactivelye.
#' @return this function returns a PDF document with the rotated pages
#' @author Priyanga Dilini Talagala
#' @examples
#' \dontrun{
#' # This command prompts the user to select the file interactively.
#' # Rotate the entire PDF document to 90 degrees clockwise
#' rotate_pdf(page_rotation = 90)
#' }
#'
#' \dontrun{
#' dir <- tempdir()
#' require(lattice)
#' for(i in 1:3) {
#' pdf(file.path(dir, paste("plot", i, ".pdf", sep = "")))
#' print(xyplot(iris[,1] ~ iris[,i], data = iris))
#' dev.off()
#' }
#' output_file <- file.path(dir, paste('Full_pdf.pdf',  sep = ""))
#' staple_pdf(input_directory = dir, output_file)
#' input_path <- file.path(dir, paste("Full_pdf.pdf",  sep = ""))
#' output_path <-  file.path(dir, paste("rotated_pdf.pdf",  sep = ""))
#' rotate_pdf( page_rotation = 90,  input_path, output_path)
#' }
#' @export
#' @references \url{https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/}
rotate_pdf <- function(page_rotation = c(0, 90, 180, 270),  input_filepath = NULL, output_filepath = NULL) {

  page_rotation <- match.arg(as.character(page_rotation),c(0, 90, 180, 270))

  if(is.null(input_filepath)){
    #Choose the pdf file interactively
    input_filepath <- file.choose(new = FALSE)
  }


  if(is.null(output_filepath)){
    #Choose output file interactively
    output_filepath <-  tcltk::tclvalue(tcltk::tkgetSaveFile(filetypes = '{Pdf {.pdf}}'))
  }

  rotation <- c("1-endnorth", "1-endeast", "1-endsouth", "1-endwest" )[match(page_rotation,c(0,90,180,270))]

  # Construct a system command to pdftk
  system_command <- paste("pdftk",
                          shQuote(input_filepath),
                          "cat",
                          rotation,
                          "output",
                          shQuote(output_filepath),
                          sep = " ")
  # Invoke the command
  system(command = system_command)

}
