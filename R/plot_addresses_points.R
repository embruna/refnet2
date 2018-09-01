########################################
########################################
## 	BEGIN: plot_addresses_points():

#' Plot address point locations on world map
#'
#' \code{plot_addresses_points} This function plots an addresses data.frame object by point overlaid on the countries of the world.
#'
#' @param data the `address` element from the list outputted from the `authors_georef()`` function, containing geocoded address latitude and longitude locations.
#' @param mapRegion what portion of the world map to show. possible values include ["world","North America","South America","Australia","Africa","Antarctica","Eurasia"]

plot_addresses_points <- function(data,
                                  mapRegion = "world") {

  ## 	Remove any addresses that have NA values:
  points <- data.frame(
    lat = data$lat,
    lon = data$lon
  )

  points <- points[!is.na(points$lat), ]

  points <- points[!is.na(points$lon), ]



  ## 	Get the world map from rworldmap package:
  world <- ggplot2::map_data("world")
  world <- world[world$region != "Antarctica", ]


  if (mapRegion != "world") {
    world <- world[which(world$continent == mapRegion), ]
  }


  ggplot() +
    geom_point(data = points, aes_string(x = "lat", y = "lon")) +
    geom_map(
      data = world, map = world,
      aes_string(map_id = "region"),
      color = "gray", fill = "#7f7f7f", size = 0.05, alpha = 1 / 4
    ) +
    ylim(-80, 80) +
    xlim(-180, 180) +
    ylab("longitude") +
    xlab("latitude") +
    theme_bw() +
    theme(
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank()
    )
}

## 	END: plot_addresses_points():
########################################
########################################