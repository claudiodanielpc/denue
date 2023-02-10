#Código para descarga del Directorio Estadístico Nacional de Unidades Económicas (DENUE)

##Paquetería necesaria
if(!require('pacman')) install.packages('pacman')
pacman::p_load(tidyverse)


#Cambiar directorio de trabajo
#Si no existe el directorio D:/, pasar a la siguiente línea
if (dir.exists("D:/")) {
  setwd("D:/")
} else {
  setwd("C:/")
}
#Crear carpeta para guardar los datos
dir.create("denue",showWarnings = FALSE)

#Options timeout
options(timeout = 60000)

##Url general del DENUE

url<-"https://www.inegi.org.mx/contenidos/masiva/denue/denue_00_"

#Listado de sectores
sectores<-c("23_","93_","11_","43_","46111_","46112-46311_","46321-46531_","46591-46911_",
"55_","51_","21_","31-33_","22_","81_1_","81_2_","72_1_", "72_2_","56_","71_","62_","61_","52_",
"53_","54_","48-49_"
)

#Descarga de archivos de DENUE====
  ##Descargar y extrar los datos para las 32 entidades federativas
for (i in seq_along(sectores)) {  
  ##Descargar
  temp<-tempfile()
  download.file(paste0(url,sectores[i],"csv.zip"),
                destfile = temp)

  ##Extraer
  unzip(temp,
        exdir = "denue")
  unlink(temp)
  
  
}

#Hacer una lista de los archivos en el directorio 
files<-list.files("denue/conjunto_de_datos/",pattern="csv",full.names = TRUE)

#Agrupar los archivos en un solo dataframe
denue<-purrr::map(files,
           ~ read_csv(glue::glue("{.x}"), 
                      na = "*",show_col_types = FALSE) %>% 
             #Nombres de las variables en minúsculas
             janitor::clean_names()%>%
             
             ##Se transforma la lista a dataframe
             as.data.frame.data.frame())%>%
             data.table::rbindlist(fill = TRUE,idcol = FALSE)
