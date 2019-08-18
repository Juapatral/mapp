### Prueba de mapas y top 10
### juapatral
### 2019-08-18

### ---- paquetes ----

library(shiny, quietly = T)
library(leaflet, quietly = T)
library(markdown, quietly = T)
library(shinythemes, quietly = T)

### ---- ui ----

ui <- navbarPage("MAPp", theme = shinytheme("flatly"),

    ### ---- inicio pesanias ----
    
    #tabsetPanel(
        
        ### ---- pestania de inicio ----
        tabPanel("Inicio", includeMarkdown("opening.md")),
        
        ### ---- pestania de comuna ----
        
        tabPanel("Comuna",
                 
                 # titulo del mapa
                 titlePanel("Mapa por comuna", windowTitle = "MAPp"),
                 
                # mainPanel(
                     
                     # texto
                     selectInput(inputId = "marcadores_cm",
                                 label = "Mostrar marcadores",
                                 choices = c("Si" = T, "No" = F)),
                     
                     # crear mapa
                     leafletOutput("mapa_cm", width = "100%", height = 400)
                     
                #    )
                 ),
        
        ### ---- pestania de barrio ----

        tabPanel("Barrio",

                #mainPanel(

                         # titulo del mapa
                         titlePanel("Mapa por barrio", windowTitle = "MAPp"),

                         # texto
                         selectInput(inputId = "marcadores_br",
                                     label = "Mostrar marcadores",
                                     choices = c("Si" = T, "No" = F)),

                         # crear mapa
                         leafletOutput("mapa_br", width = "100%", height = 400)

                  #       )
                ),

        ### ---- pestania de top 10 ----
        
        tabPanel("Top",
                 
                 titlePanel("Principales", windowTitle = "MAPp"),
                 
                 #mainPanel(
                     
                     fluidRow(
                         
                         # tabla comunas
                         column(width = 6, 
                                h4("Tabla por comunas"),
                                dataTableOutput("tabla_cm")
                                ),
                         
                         # tabla barrios
                         column(width = 6,
                                h4("Tabla por barrios"),
                                dataTableOutput("tabla_br")
                                )
                        )
                     #)
                 )
        )
    #)




### ---- server ----

server <- function(input, output) {

    ### ---- cargar liberias ----
    library(leaflet, quietly = T)
    library(sf, quietly = T)
    library(data.table, quietly = T)
    library(dplyr, quietly = T)
    library(shiny, quietly = T)
    library(lubridate, quietly = T)
    library(plotly, quietly = T)
    library(readxl, quietly = T)
    library(stringr, quietly = T)
    
    ### ---- cargar archivos ----
    
    # datos historicos
    dir <- read_excel("files/DIRECCIONES 12-08-2019.xlsx",
                      col_types = "text")
    
    # datos espaciales
    barrio <- read_sf("files/Limite_Barrio_Vereda_Catastral/Limite_Barrio_Vereda_Catastral.shp")
    comuna <- read_sf("files/Limite_Comunas_Corregimientos/Limite_Comunas_Corregimientos.shp")
    
    ### ---- crear tablas ----
    
    dir$lon <- as.numeric(dir$lon)
    dir$lat <- as.numeric(dir$lat)
    
    # crear archivo para barrio
    dir2 <- dir %>% 
            mutate(comuna_barrio = str_sub(cbml, 1, 4)) %>% 
            filter(!is.na(comuna_barrio)) %>% 
            group_by(comuna_barrio) %>% 
            summarize(total = n())
    
    # crear puntos para coordenadas
    dir3 <- dir %>% 
            filter(lon != 0) %>%
            group_by(dirgoogle...11, lon, lat) %>% 
            summarize(total = n())
    
    # crear archivo de comunas
    dir4 <- dir %>% 
            mutate(comuna = str_sub(cbml, 1, 2)) %>% 
            filter(!is.na(comuna)) %>% 
            group_by(comuna) %>% 
            summarize(total = n())
    
    # crear archivo mapa de barrios
    nuevo_mapa <- inner_join(barrio, 
                             dir2,
                             by = c("CODIGO" = "comuna_barrio"))
    
    # crear archivo mapa de comunas
    nuevo_mapa_cm <- inner_join(comuna, 
                                dir4,
                                by = c("COMUNA" = "comuna"))
    
    ### ---- crear outputs ----
    
    # crear mapa de barrio
    output$mapa_br <- renderLeaflet({
        
    # establecer paleta
        mypal <- colorNumeric(palette = "magma", 
                               domain = nuevo_mapa$total,
                               reverse = TRUE)
        
        # crear mapa
        
        # agregar marcadores
            if(input$marcadores_br){
                
                leaflet() %>%
                    
                addPolygons(data = nuevo_mapa,
                            color = "grey",
                            opacity = 0.9,
                            weight = 1, # grosor de la linea
                            fillColor = ~mypal(total),
                            fillOpacity = 0.6,
                            label = ~NOMBRE_BAR,
                            # ajustar sombreado de seleccion
                            highlightOptions = highlightOptions(color = "black",
                                                                weight = 3, 
                                                                bringToFront = T, 
                                                                opacity = 1),
                            # ajustar descripcion emergente al darle click
                            popup = paste("Barrio: ", 
                                          nuevo_mapa$NOMBRE_BAR, 
                                          "<br>",
                                          "Total: ", 
                                          nuevo_mapa$total, 
                                          "<br>")
                            ) %>%
                
                # agregar marcadores
                addMarkers(~lon, 
                           ~lat, 
                           data = dir3, 
                           popup = ~as.character(total),
                           label = ~as.character(dirgoogle...11)) %>%
                
                #establecer mapa de fondo
                addProviderTiles(providers$Wikimedia) %>%
                
                # agregar leyenda
                addLegend(position = "bottomright", 
                          pal = mypal, 
                          values = nuevo_mapa$total,
                          title = "Total",
                          opacity = 0.3)
            }else{
             
                leaflet() %>%
                    
                addPolygons(data = nuevo_mapa,
                            color = "grey",
                            opacity = 0.9,
                            weight = 1, # grosor de la linea
                            fillColor = ~mypal(total),
                            fillOpacity = 0.6,
                            label = ~NOMBRE_BAR,
                            # ajustar sombreado de seleccion
                            highlightOptions = highlightOptions(color = "black",
                                                                weight = 3, 
                                                                bringToFront = T, 
                                                                opacity = 1),
                            # ajustar descripcion emergente al darle click
                            popup = paste("Barrio: ", 
                                          nuevo_mapa$NOMBRE_BAR, 
                                          "<br>",
                                          "Total: ", 
                                          nuevo_mapa$total, 
                                          "<br>")
                            ) %>%
                
                #establecer mapa de fondo
                addProviderTiles(providers$Wikimedia) %>%
                
                # agregar leyenda
                addLegend(position = "bottomright", 
                          pal = mypal, 
                          values = nuevo_mapa$total,
                          title = "Total",
                          opacity = 0.3)   
            }
    })
    
    # crear mapa de comuna
    output$mapa_cm <- renderLeaflet({
        
    # establecer paleta
        mypal_cm <- colorNumeric(palette = "magma", 
                                 domain = nuevo_mapa_cm$total,
                                 reverse = TRUE)
        
        # crear mapa
        
        # agregar marcadores
            if(input$marcadores_cm){
                
                leaflet() %>%
                    
                addPolygons(data = nuevo_mapa_cm,
                            color = "grey",
                            opacity = 0.9,
                            weight = 1, # grosor de la linea
                            fillColor = ~mypal_cm(total),
                            fillOpacity = 0.6,
                            label = ~NOMBRE,
                            # ajustar sombreado de seleccion
                            highlightOptions = highlightOptions(color = "black",
                                                                weight = 3, 
                                                                bringToFront = T, 
                                                                opacity = 1),
                            # ajustar descripcion emergente al darle click
                            popup = paste("Comuna: ", 
                                          nuevo_mapa_cm$NOMBRE, 
                                          "<br>",
                                          "Total: ", 
                                          nuevo_mapa_cm$total, 
                                          "<br>")
                            ) %>%
                
                # agregar marcadores
                addMarkers(~lon, 
                           ~lat, 
                           data = dir3, 
                           popup = ~as.character(total),
                           label = ~as.character(dirgoogle...11)) %>%
                
                #establecer mapa de fondo
                addProviderTiles(providers$Wikimedia) %>%
                
                # agregar leyenda
                addLegend(position = "bottomright", 
                          pal = mypal_cm, 
                          values = nuevo_mapa_cm$total,
                          title = "Total",
                          opacity = 0.3)
            }else{
             
                leaflet() %>%
                    
                addPolygons(data = nuevo_mapa_cm,
                            color = "grey",
                            opacity = 0.9,
                            weight = 1, # grosor de la linea
                            fillColor = ~mypal_cm(total),
                            fillOpacity = 0.6,
                            label = ~NOMBRE,
                            # ajustar sombreado de seleccion
                            highlightOptions = highlightOptions(color = "black",
                                                                weight = 3, 
                                                                bringToFront = T, 
                                                                opacity = 1),
                            # ajustar descripcion emergente al darle click
                            popup = paste("Comuna: ", 
                                          nuevo_mapa_cm$NOMBRE, 
                                          "<br>",
                                          "Total: ", 
                                          nuevo_mapa_cm$total, 
                                          "<br>")
                            ) %>%
                
                #establecer mapa de fondo
                addProviderTiles(providers$Wikimedia) %>%
                
                # agregar leyenda
                addLegend(position = "bottomright", 
                          pal = mypal_cm, 
                          values = nuevo_mapa_cm$total,
                          title = "Total",
                          opacity = 0.3)   
            }
    })
    
    # crear tabla de comuna
    output$tabla_cm <- renderDataTable(
        
        # elegir los primeros 10
        options = list(pageLength = 10), 
        {
        
        # crear dataframe
        com10 <- select(as.data.frame(comuna), "NOMBRE", "COMUNA") %>%
                 inner_join(dir4, by = c("COMUNA" = "comuna")) %>%
                 select(NOMBRE, total) %>%
                 arrange(desc(total))
        
        # cambiar nombres
        names(com10) <- c("Comuna", "Total de observaciones")
        
        # mostrar dataframe
        as.data.frame(com10) 
        
        
    })
    
    
    
    # crear tabla de barrio
    output$tabla_br <- renderDataTable(
        
        # elegir los primeros 10
        options = list(pageLength = 10),
        {
        
        # crear dataframe
        bar10 <- select(as.data.frame(barrio), 
                        NOMBRE_BAR, NOMBRE_COM, CODIGO) %>%
                 inner_join(dir2, by = c("CODIGO" = "comuna_barrio")) %>%
                 select(NOMBRE_COM, NOMBRE_BAR, total) %>%
                 arrange(desc(total))
        
        # cambiar nombres
        names(bar10) <- c("Comuna", "Barrio", "Total de observaciones")
                    
        # mostrar dataframe
        as.data.frame(bar10)
        
        
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)
