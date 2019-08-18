# ***MAPp***

Georreferenciación de algunas direcciones utilizando *R* y *leaflet*. 
---

## **Mapa del sitio**

* En *`Inicio`*, la pestaña actualmente activa, encontrará el mapa del sitio y una breve explicación.

* En *`Mapa por comuna`* encontrará un mapa interactivo de Medellín con la información por comunas.

* En *`Mapa por barrio`* encontrará un mapa interactivo de Medellín con la información por barrios.

* En *`Top`* encontrará unas tablas con las comunas y barrios donde más hay información y donde hay menos información, donde puede elegir entre mostrar las primeras 10, 25, 50 o 100 y organizar alfabéticamente por nombre de comuna o barrio, u organizar por cantidad de observaciones. 

## **Explicación de los mapas**

Los mapas están compuestos de dos tipos de gráficos, marcadores y mapa de densidad. 

Los *marcadores* consisten en la ubicación de las direcciones en el sistema de coordenadas internaciónal [wgs84](https://en.wikipedia.org/wiki/World_Geodetic_System). Al pasar por encima de los marcadores se muestra la dirección y la ciudad y al darle click se muestra la cantidad de observaciones en el conjunto de datos. La opción de mostrar marcadores se puede habilitar en cada pestaña. 

El *mapa de densidad* por barrios o comunas solo está disponible para Medellín y consiste en generar una paleta de colores de acuerdo con la cantidad de observaciones, donde colores más claros indican menos observaciones y colores más oscuros más observaciones. Al darle click se muestra el nombre de la comuna o el barrio y la cantidad de observaciones. 

## **Metodología**

La georreferenciación se hizo posible a través de *Google Maps* y la [*API*](https://www.medellin.gov.co/geomedellin/index.hyg#openModal) de la Alcaldía de Medellín, trabajo realizado de manera manual. En caso de incrementar el tamaño del conjunto de datos, se evaluará la opción de utilizar la *API Geolocation* de *Google*. 

Los mapas de comunas y barrios de Medellín están disponibles en su [sitio oficial.](https://geomedellin-m-medellin.opendata.arcgis.com/)

***Nota:*** no todas las observaciones que son de Medellín se pudieron asociar a un barrio o comuna, por lo que se requiere un trabajo manual para hacerlo.
---
<font size = "1">

Version *MAPp*: 2019.08.18

Maintained by: juapatral

</font>