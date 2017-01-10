#'Concatena Capítulos De Um Power Up
#'
#'Concatena os capítulos de um power up em um único arquivo index.html.
#'
#'@importFrom magrittr %>%
#'@par dir diretório em que encontram-se os capítulos
#'@par titulo título do arquivo resposta
#'@par output_file nome do arquivo de saída
#'@par output_dir nome do diretório saída
#'
#'@export
Rmd_bind <- function(dir = ".", titulo, output_file = NULL){

  book_header = sprintf("---\ntitle: '%s'\n") %>%

    readLines(
    textConnection("---\ntitle: 'Title'\nalways_allow_html: yes\n---"))


  if(length(grep("index.Rmd", list.files(dir, full.names = T))) > 0){
    warning("index.Rmd already exists")
  }
  f <- sprintf("%s/index.Rmd",dir)
  write(book_header, file = f)
  cfiles <- list.files(dir, pattern = "*.Rmd", full.names = T)
  ttext <- NULL
  for(i in 1:length(cfiles)){
    text <- readLines(cfiles[i])
    titulo <- gsub('title: |"', "",grep("title", text, value = T))
    hspan <- grep("---", text)
    text <- c(sprintf("#%s",noquote(titulo)),text[-c(hspan[1]:hspan[2])])
    write(text, sep = "", file = f, append = T)
  }
  rmarkdown::render(f, blogdown::html_page())
}