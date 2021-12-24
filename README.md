# Trabajo_BigData
 Trabajo final

## A continuación se muestra una breve descripción de los archivos en el repositorio y sus elementos.

- trabajofinalbigdatapropiedades.R: *Códigos de extracción de datos hasta la creación de archivo csv*

- graficosparatrabajofinalpropiedades.R: *Códigos para la creación de gráficos en base a los datos del csv llamado trabajofinalbigdatapropiedades.R*

- Análisis de datos de propiedades.pptx: *Presentación PPT donde se resume la investigación*

- trabajofinalpropiedades.mp4: *Presentación en archivo mp4 del PPT llamado* “*Análisis de datos de propiedades.pptx*” 

- incluidovalorUFm2.csv: *Este archivo csv contiene las variables del archivo propiedades.csv + la variable de valor UF por m2*

*Descripción de las variables:*

Código: Código de las viviendas

Habitaciones: Cantidad de habitaciones de las viviendas 

Banios: Cantidad de baños de la vivienda

Superficie_total: Corresponde a los m2 de la vivienda construida + m2 de estacionamiento.

Superficie_construida: Corresponde a los m2 de la vivienda construida

Estacionamiento: Corresponde a m2 de estacionamiento

Precio: Precio de la vivienda, puede ser en UF o peso chileno

Precio PESO: Precio de la vivienda, exclusivamente en peso chileno

Precio UF: Precio de la vivienda, exclusivamente en UF

fechaPublicacion: Fecha de publicación del anuncio de venta de la vivienda

Categoria: Categoría de la vivienda (si es venta, compra, arriendo, etc.), en este caso se trabajará exclusivamente con ventas usadas.

Subcategoria:  : Subcategoría de la vivienda (si es departamento, casa, casa usada, parcelas, etc.), en este caso se trabajará exclusivamente con casas.

region: Corresponde a la región donde se ubica la vivienda, los elementos extraídos en esta variable no se han modificado de su fuente de origen (chilepropiedades.cl)

Region1: Corresponde a la región donde se ubica la vivienda, los elementos extraídos de esta variable se han modificado, refiriéndonos a la Región Metropolitana como “RM”, región de Valparaíso como “V” y región de Los Lagos como “X”.

ValorUFm2: Corresponde al valor UF por m2, se obtiene dividiendo la superficie total por el Precio UF.
