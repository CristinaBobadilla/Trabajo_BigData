library(rvest)
library(xml2)
descripcion <- c()
precios <- c()
moneda <- c()
preciouf <- c()
preciopeso <- c()
direccion <- c()
habitaciones <- c()
banios <- c()
construccion_anio <- c()
fecha_publicacion <- c()
sup_construida <- c()
sup_total <- c()
estacionamiento <- c()
codigo <- c()
categoria <- c()
subcategoria <- c()
urlpropiedad <- c()
region <- c()


detallePropiedad <- function(indice, urlP)
{
  
  superficie_total <- ""
  superficie_construida <- ""
  valor <- ""
  fecha <- ""
  tipopubl <- ""
  tipoprop <- ""
  
  error404 <<- FALSE
  urlP <- paste("https://chilepropiedades.cl", urlP, sep = "")
  print(urlP)
  result = tryCatch( 
    {paginaPropiedad <- read_html(urlP)},
    error = function(err){
      print( paste("No se pudo generar pagina", indice))
      error404 <<- TRUE
    },
    finally = {
      
      if( error404 == FALSE)
      {
        print("Procesando detalle")
        detalles <- paginaPropiedad %>% html_nodes( css = ".clp-details-table") %>% html_elements("div")
        
        for( indice in  1:length(detalles) )
        {
          dato <- detalles[indice]
          atributo <- dato %>% html_text()
          #print(atributo)
          if( atributo == "Superficie Total:" )
          {
            superficie_total <- detalles[indice + 1] %>% html_text()
          }
          if( atributo == "Superficie Construida:")
          {
            superficie_construida <- detalles[indice + 1] %>% html_text()
          }
          if( atributo == "Valor:")
          {
            valor <- detalles[indice + 1] %>% html_text()
          }
          if( atributo == "Fecha Publicación:")
          {
            fecha <- detalles[indice + 1] %>% html_text()
          }
          if( atributo == "Tipo de publicación:")
          {
            tipopubl <- detalles[indice + 1] %>% html_text()
          }
          if( atributo == "Tipo de propiedad:")
          {
            tipoprop <- detalles[indice + 1] %>% html_text()
          }
        }
        
        if( length(superficie_total) > 0)
        {
          superficie_total <- gsub(" ", "", superficie_total)
          superficie_total <- gsub("[.]", "", superficie_total)
          superficie_total <- gsub("[,]", ".", superficie_total)
          superficie_total <- gsub("\n", "", superficie_total)
          superficie_total <- gsub("m²", "", superficie_total)
          print(superficie_total)
          sup_total <<- c(sup_total, as.numeric( superficie_total))
        }
        else
        {
          sup_total <<- c(sup_total, NA)
        }
        
        if( length(superficie_construida) > 0)
        {
          superficie_construida <- gsub(" ", "", superficie_construida)
          superficie_construida <- gsub("[.]", "", superficie_construida)
          superficie_construida <- gsub("[,]", ".", superficie_construida)
          superficie_construida <- gsub("\n", "", superficie_construida)
          superficie_construida <- gsub("m²", "", superficie_construida)
          print(superficie_construida)
          sup_construida <<- c(sup_construida, as.numeric(superficie_construida) )
        }
        else
        {
          sup_construida <<- c(sup_construida, NA)
        }
        
        if( length(valor) > 0)
        {
          precios <<- c(precios, valor)
          if( substr(valor, 1, 2) == "UF")
          {
            precio_en_uf <- gsub("UF ", "", valor)
            precio_en_uf <- gsub("[.]", "", precio_en_uf)
            precio_en_uf <- gsub("[,]", ".", precio_en_uf)
            #print( paste("valor en uf limpio:[", precio_en_uf, "]", sep=""))
            preciouf <<- c(preciouf, precio_en_uf)
            precio_en_pesos <- as.numeric(precio_en_uf) * valorUF
            preciopeso <<- c(preciopeso, precio_en_pesos)
          }
          else
          {
            precio_en_pesos <- gsub("[$]", "", valor)
            precio_en_pesos <- gsub("[.]", "", precio_en_pesos)
            precio_en_pesos <- gsub("[,]", ".", precio_en_pesos)
            #print( paste("valor en pesos limpio:[", precio_en_pesos, "]", sep="") )
            #se asume peso
            preciopeso <<- c(preciopeso, precio_en_pesos)
            precio_en_uf <- as.numeric(precio_en_pesos) / valorUF
            preciouf <<- c(preciouf, precio_en_uf)
          }
        }
        else
        {
          precios <<- c(precios, NA)
          preciouf <<- c(preciouf, NA)
          preciopeso <<- c(preciopeso, NA)
        }
        
        if( length(fecha) > 0 )
        {
          obfecha <- as.Date(fecha, "%d/%m/%Y")
          fecha_publicacion <<- c(fecha_publicacion, paste("", obfecha, sep="") )
        }
        else
        {
          fecha_publicacion <<- c(fecha_publicacion, NA)
        }
        
        if( length(tipopubl) > 0)
        {
          categoria <<- c(categoria, tipopubl)
        }
        else
        {
          categoria <<- c(categoria, NA)
        }
        
        if( length(tipoprop) > 0 )
        {
          subcategoria <<- c(subcategoria, tipoprop)
        }
        else
        {
          subcategoria <<- c(subcategoria, NA)
        }
        
      }
    }
  )
}



#define el valor de la UF
valorUF = 30936.95

zonas <- c("region-metropolitana-de-santiago-rm", "v-region-de-valparaiso", "x-region-de-los-lagos")
for(zona in zonas)
{
  for(pagina in 0:10)
  {
    link <- paste("https://chilepropiedades.cl/propiedades/venta/casa/",zona,"/", pagina ,sep = "")
    
    print( paste("Pagina Num:", pagina, "\nLink:", link))
    chilepropiedadesPage <- read_html(link)
    
    #cada propiedad esta dentro de la clase clp-publication-element
    listaPropiedades <- chilepropiedadesPage %>% html_nodes( css = ".clp-publication-element")
    
    
    for(indice in 1:length(listaPropiedades))
    {
      print(paste("Propiedad:", indice, sep=""))
      #obtiene la url del propiedad
      urlp <- listaPropiedades[indice] %>% html_nodes( css = ".clp-listing-image-link") %>% html_attr("href")
      print(urlp)
      
      if( length(urlp) > 0)
      {
        urlpropiedad <- c(urlpropiedad, urlp)
        region <- c(region, zona)      
        
        #extrae el codigo de la propiedad
        textcodigo <- listaPropiedades[indice] %>% html_nodes( css = ".clp-search-image-container") %>% html_attr("data-publication-id")
        codigo <- c(codigo, textcodigo)
        
        #se usa .//span para buscar en el nodo actual, ya que //span busca en todo el documento
        
        #extrae numero de habitaciones
        numhabitaciones <- listaPropiedades[indice] %>% html_nodes( xpath = ".//span[@title='Habitaciones']") %>% html_nodes( css=".clp-feature-value") %>% html_text()
        if( length(numhabitaciones) > 0 )
        {
          habitaciones <- c(habitaciones, numhabitaciones)
        }
        else
        {
          habitaciones <- c(habitaciones, NA)
        }
        
        
        #extra numero de baños
        numbanios <- listaPropiedades[indice] %>% html_nodes( xpath = ".//span[@title='Baños']") %>% html_nodes( css=".clp-feature-value") %>% html_text()
        if( length(numbanios)  > 0 )
        {
          banios <- c(banios, numbanios)
        }
        else
        {
          banios <- c(banios, NA)
        }
        
        #estacionamientos
        numestacionamientos <- listaPropiedades[indice] %>% html_nodes( xpath = ".//span[@title='Estacionamientos']") %>% html_nodes( css=".clp-feature-value") %>% html_text()
        if( length(numestacionamientos) > 0 )
        {
          estacionamiento <- c(estacionamiento, numestacionamientos)
        }
        else
        {
          estacionamiento <- c(estacionamiento, NA)
        }
        
      }
      
    }
    
  }
}

#obtiene el detalle del producto
for(urlp in 1:length(urlpropiedad)  )
{
  print( paste("Detalle Producto Num:", urlp) )
  detallePropiedad(urlp, urlpropiedad[urlp])
}

dataPropiedaddes <- data.frame( codigo = codigo, habitaciones = habitaciones, banios = banios, superficie_total = sup_total, superficie_construida = sup_construida, estacionamiento = estacionamiento, precio = precios, precioPESO = preciopeso, precioUF = preciouf, fechaPublicacion = fecha_publicacion, categoria = categoria, subcategoria = subcategoria, region = region )

write.csv( dataPropiedaddes, "propiedades.csv")