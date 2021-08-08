# para cargar una base de datos con el paquete de R se usa read.csv

base <- read.csv("sesiones/data/arg_presi_gral2003.csv")

# Puedo cargar la misma base de datos con tidyverse, para eso cargo una de las librerias que trae *readr*

library(readr)

tidy <- read_csv("sesiones/data/arg_presi_gral2003.csv")


#con r veo que el archivo me lo lee como data.frame
class(base)

#con tidy me lo lee como tada-frame pero tambien como tbl que es tibble, como lo lee tidyverse
class(tidy)

#con tidy tambien puedo usar real_delim en donde le tengo que decir cual es el delimitador del archivo, si es , ; o que
# con tidyverse se puede levantar tambien datos de un excel con readxl::read_xlsx

readxl::read_xlsx(path = "sesiones/data/arg_presi_gral2003.xlsx")

#hay distintos codigos para leer distintos formatos, ejemplo
library(haven)

read_dta("sesiones/data/argentina_ecological_data.dta")


library(googlesheets4) #no me lo instala y no puedo correr este hulo de codigos 
gs4_deauth() # Eliminar auth interactivo (link publico)
read_sheet("https://docs.google.com/spreadsheets/d/1J84PviVxVMsCDzupOcD0_s_yc92vm4sCB6uoJQtl2mU/edit?usp=sharing")

#datapasta  es un paquete que sirve para copiiar y pegar una tabla y que lo tome como dato

library(datapasta)
 poblacion <- tribble_paste()
tibble::tribble(
                                                ~Provincia, ~`Población.en.201012?`,
                               "Provincia de Buenos Aires",            "15.594.428",
                                                 "Córdoba",             "3.304.825",
                                                "Santa Fe",             "3.300.736",
                         "Ciudad Autónoma de Buenos Aires",             "2.891.082",
                                                 "Mendoza",             "1.741.610",
                                                 "Tucumán",             "1.592.878",
                                              "Entre Ríos",             "1.236.300",
                                                   "Salta",             "1.215.207",
                                                "Misiones",             "1.097.829",
                                                   "Chaco",             "1.053.466",
                                              "Corrientes",               "993.338",
                                     "Santiago del Estero",               "896.461",
                                                "San Juan",               "680.427",
                                                   "Jujuy",               "672.260",
                                               "Río Negro",               "633.374",
                                                 "Neuquén",               "550.344",
                                                 "Formosa",               "527.895",
                                                  "Chubut",               "506.668",
                                                "San Luis",               "461.588",
                                               "Catamarca",               "367.820",
                                                "La Rioja",               "331.847",
                                                "La Pampa",               "316.940",
                                              "Santa Cruz",               "272.524",
   "Tierra del Fuego, Antártida e Islas del Atlántico Sur",               "126.190"
   )

#con el paquete janitor limpiamos los nombres de las variables
library(janitor)
library(tidyverse)

poblacion %>% 
  janitor::clean_names()
 
# con el paquete devtools nos permite bajar librerias desde github, una vez instalado nos vamos a bajar el paq electorAr y lo vamos a llamar para poder ordenar un poco esos datos

devtools::install_github("politicaargentina/electorAr")

#una vez descargado lo llamamos

library(electorAr)

show_available_elections(source = "results")

#creamos una base con los gobernadores de tucuman, para eso vamos a relizar un filtro 

(gobernadores_tucuman <- show_available_elections(source = "results") %>% 
    dplyr::filter(NOMBRE == "TUCUMAN", 
                  category == "gober"))

#ahora del paquete armamos una base de datos de la provincia con los diputados de las elecciones generals del 2009 a nivel de departamento
eleccion <- get_election_data(district = "pba", 
                              category = "dip", 
                              round = "gral", 
                              year = 2009, 
                              long = FALSE,
                              level= "departamento")

# Pivotear (funcion de tidyr) sirve para invertir filas por columnas, puede ser util a la hora de graficar

library(tidyr)
eleccionlong <- eleccion %>% 
  pivot_longer(cols = c(blancos:'0585'),
               names_to ="listas",
               values_to="votos")

#pivot_longer reduce cant de columnas y aumenta la cant de filas. hay que establecer tres parametros, columnas que queremos pivotear, los nombres de las variables que se van a generar con el pivoteo y los nombres pivot_wider lo hace al revez

eleccionlong %>% 
  pivot_wider(names_from = "listas",
              values_from = "votos",
              names_prefix = "lista-")


library(stringr)
library(tidyverse)

# del paq string esta la funcion str_detect que sirve para detectar patrones, entonces si no sabemos como esta escrito algo y solo concemos los primeros caracteres lo podemos usar
eleccionesmdq <- eleccionlong %>%
  filter(str_detect(string = depto, pattern = "General Puey")) %>% 
  select(-c(category:codprov)) %>% 
  mutate(leyenda="Piazolla")

#con str_to_upper puedo convertir minusculas en mayusculas
eleccionesmdq %>% 
  mutate(depto=str_to_upper(depto)) %>% 
  arrange(desc(votos))
