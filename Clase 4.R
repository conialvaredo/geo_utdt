
library(googlesheets)
library(skimr)
library(janitor) 
library(tidyverse)

#cargamos una base de datos muy pesada
datos <- vroom::vroom("https://storage.googleapis.com/properati-data-public/ar_properties.csv.gz")


#para seguir trabajando recortamos las primeras 1000 observaciones

muestra <- datos %>% 
  slice(1:1000) 
#slice_min o slice_max para que se quede con esta determinada condicion

skim(muestra) # Descronor set de datps y variables

muestra %>% 
  rename(provincia = l2) %>% 
  group_by(provincia) %>% 
  summarize(cantidad = n()) %>% #Vemos de esta menera que hay mas cantidad de provincias que las que deberia
  arrange(desc(cantidad)) %>% 
  print(n=Inf) #nos imprime la lista, en donde podemos ver que el error es por como figura de diversas maneras la PBA

muestra %>% 
  rename(provincia = l2) %>% 
  group_by(provincia) %>% 
  summarize(cantidad = n()) %>%
  mutate(provincia2 = case_when( #que detecte casos con case_when 
    str_detect(string = provincia, pattern = "Bs.As") ~ "PBA", #que detecte en la columna Bs.As y escriba PBA 
    str_detect(string = provincia, pattern = "Buenos Aires") ~ "PBA", #que detecte en la columna Buenos Aires y escriba PBA
    TRUE ~ provincia #cuando no lo detecta  deja como estaba
  ))  %>% 
  print(n=Inf)
 

muestra %>% 
  mutate_at(.vars = c("start_date", "end_date"), .funs = ~ as.character(.)) #cambiamos para que nos lea a las fechas como character y no como date. el (.) despues del as.character es para que lo aploque primero es start_date y luego en end_date


muestra %>% 
  mutate(across(.col = everything(), .funs = as.character(.))) #con across reemplazamos el mutate_at
 

library(devtools)	

install_github("politicaargentina/geoAr")	

(codigos <- show_arg_codes(nivel = "departamentos")) # de esta menerame me guarda como dataset una parte especifica del la libreria de GeoAR

(codigos1 <- show_arg_codes())  # de esta menerame me guarda como dataset una parte general del la libreria de GeoAR


library(tidyverse)

get_geo(geo = "TUCUMAN") %>% 
  left_join(codigos, by = c("codprov_censo", "coddepto_censo"))

#strigr, otra funcion de tidyverse

codigos %>% 
  transmute(id,
            codprov,
            codprov2 = str_pad(string = codprov, width =3, side="left", pad=1)) #agrega otra columna codprov2 de la cual toma una parte de codprov y le agrega a la izq. otro 1

