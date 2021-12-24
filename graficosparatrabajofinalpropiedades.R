library(tidyverse)
library(ggplot2)


dataPropiedaddes1 <- dataPropiedaddes %>% mutate( Region1 = case_when( region == "region-metropolitana-de-santiago-rm" ~ "RM", region == "v-region-de-valparaiso" ~  "V Region", region == "x-region-de-los-lagos" ~ "X Region" ) )

#datos habitaciones para region metropolitana
grafico_habitaciones_RM <- dataPropiedaddes1 %>% filter(Region1 == "RM") %>% group_by(habitaciones) %>% summarise(cantidad = n())

#datos habitaciones para V region
grafico_habitaciones_V <- dataPropiedaddes1 %>% filter(Region1 == "V Region") %>% group_by(habitaciones) %>% summarise(cantidad = n())

#datos habitaciones para X region
grafico_habitaciones_X <- dataPropiedaddes1 %>% filter(Region1 == "X Region") %>% group_by(habitaciones) %>% summarise(cantidad = n())

#grafico de barra de la RM
ggplot(data=grafico_habitaciones_RM, aes(x=habitaciones, y=cantidad, fill=habitaciones)) + geom_bar(stat="identity")

#grafico de barra de la V region
ggplot(data=grafico_habitaciones_V, aes(x=habitaciones, y=cantidad, fill=habitaciones)) + geom_bar(stat="identity")

#grafico de barra de la X region
ggplot(data=grafico_habitaciones_X, aes(x=habitaciones, y=cantidad, fill=habitaciones)) + geom_bar(stat="identity")


#datos para estacionamientos en la RM
grafico_estacionamientos_RM <- dataPropiedaddes1 %>% filter(Region1 == "RM") %>% group_by(estacionamiento) %>% summarise(cantidad = n())

#datos para estacionamientos en la RM
grafico_estacionamientos_V <- dataPropiedaddes1 %>% filter(Region1 == "V Region") %>% group_by(estacionamiento) %>% summarise(cantidad = n())

#datos para estacionamientos en la RM
grafico_estacionamientos_X <- dataPropiedaddes1 %>% filter(Region1 == "X Region") %>% group_by(estacionamiento) %>% summarise(cantidad = n())


#grafico de barra de la RM
ggplot(data=grafico_estacionamientos_RM, aes(x=estacionamiento, y=cantidad, fill=estacionamiento)) + geom_bar(stat="identity")

#grafico de barra de la V region
ggplot(data=grafico_estacionamientos_V, aes(x=estacionamiento, y=cantidad, fill=estacionamiento)) + geom_bar(stat="identity")

#grafico de barra de la X region
ggplot(data=grafico_estacionamientos_X, aes(x=estacionamiento, y=cantidad, fill=estacionamiento)) + geom_bar(stat="identity")



#boxplot de los valores de la propiedad en UF en la RM
box_uf_rm <- dataPropiedaddes1 %>% filter(Region1 == "RM") %>% filter( !is.na(precioUF) ) %>% select(9)
boxplot(  as.numeric( as.character(box_uf_rm$precioUF) ) )

#boxplot de los valores de la propiedad en la V Region
box_uf_V <- dataPropiedaddes1 %>% filter(Region1 == "V Region") %>% filter( !is.na(precioUF) ) %>% select(9)
boxplot(  as.numeric( as.character(box_uf_V$precioUF) ) )

#boxplot de los valores de la propiedad en la X Region
box_uf_X <- dataPropiedaddes1 %>% filter(codigo != "5628366" ) %>% filter(Region1 == "X Region") %>% filter( !is.na(precioUF) ) %>% select(9)
boxplot(  as.numeric( as.character(box_uf_X$precioUF) ) )



as.numeric(preciouf)

dataPropiedades1 <- mutate(dataPropiedaddes1, valorUFm2 = as.numeric(preciouf)/as.numeric(sup_total) )


#boxplot de precioUFm2
box_uf_rm <- dataPropiedades1 %>% filter(Region1 == "RM") %>% filter( !is.na(valorUFm2) ) %>% select(15)
boxplot((box_uf_rm$valorUFm2), horizontal=TRUE )



box_plot <- ggplot(dataPropiedades1 %>% filter(codigo != "5628366" ) , aes(x=Region1, y=valorUFm2))
box_plot + geom_boxplot()


write.csv(dataPropiedades1, "incluidovalorUFm2.csv")
