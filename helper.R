show_hr <- function(height='1px', width='60%', center=F){
  hr <- paste0('<hr style="height:',height,'; width:',width,';"></hr>') %>% 
    htmltools::HTML()
  hr
}


show_tabs <- function(part){
  if (part %in% c('def','start')){
    str <- '::: {.tab}
<button class="tablinks" onclick="unrolltab(event, "R")">R</button>
<button class="tablinks" onclick="unrolltab(event, "Python")">Python</button>'
  }
  else if (part=='end'){
#     str <- ":::
# <script> unrolltab(event, 'R') </script>"
    str <- ":::
<script> document.getElementsByClassName('tablinks')[0].click() </script>"
  }
  else{
    str <- paste0("::: {#",part," .tabcontent}")
  }
  return(htmltools::HTML(str))
}
