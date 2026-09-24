source("scripts/source_functions.R")
# install.packages("sf")
library(sf)
sf_use_s2(FALSE)
# install.packages("terra")
library(terra)

# pol_bind = vect("dataset/spatial/trees_gsat_bel.kml")
# pol_bind
# tree_simple = terra::simplifyGeom(pol_bind,tolerance=0.5,preserveTopology=TRUE, makeValid=TRUE)
# writeVector(tree_simple,"dataset/spatial/simple_trees.shp")
# buffer(tree_simple,10)

# br = rast("dataset/spatial/brazil_coverage-col4_10m_2025.tif")
# PA = vect("dataset/spatial/PA_Municipios_2025/PA_Municipios_2025.shp")
# PA_SEL = PA[PA$NM_MUN=="Belém"|PA$NM_MUN=="Ananindeua",]
# extentz = ext(buffer(PA_SEL,5000))
# br_crop = crop(br,extentz)
# plot(br_crop)
# writeRaster(br_crop,"dataset/spatial/brazil_coverage-col4_10m_2025.tif",overwrite=T)

## What does a point need? To be inside a park or/and a tree
## Interesting predictors:
##    01. Tree density per park / per point (Lucas)
##    02. Distance to the nearest tree (Lucas)
##    03. Area of the nearest tree (Lucas)
##    04. Probability of connectivity (Lucas)
##    05. Integral index of connectivity (Lucas)
##    06. Minimum Cumulative Resistance (Lucas)
##    07. Patch/park density
##    08. Patch/park size
##    09. Land cover proportion
##    10. Patch/park edge density
##    11. Distance from source habitat
##    12. Distance to the nearest patch/park

br_crop = rast("dataset/spatial/brazil_coverage-col4_10m_2025.tif")
plot(br_crop)
tree_simple = vect("dataset/spatial/simple_trees.shp")
plot(tree_simple[1:50000,])
park_bel = read_sf("dataset/spatial/praças_belem.kml")
park_ana = read_sf("dataset/spatial/praças_ananindeua.kml")
plot(park_bel$geometry)
plot(park_ana$geometry,add=T)
park_bel = park_bel[st_geometry_type(park_bel) == "POLYGON",]
park_ana = park_ana[st_geometry_type(park_ana) == "POLYGON",]
parks = rbind(park_bel,park_ana)
par(mar = c(0,0,0,0))
plot(parks$geometry)

# install.packages("landscapemetrics")
library(landscapemetrics)
# install.packages("ggplot2")
library(ggplot2)

# Criar um grid de pontos para calcular as métricas da paisagem -----
tree_simple = st_as_sf(tree_simple)
tree_t = st_transform(tree_simple, crs = 31982)

library(raster)
r.raster <- raster()  
extent(r.raster) <- extent(tree_t) # set extent to match the tree_simple object
res(r.raster) <- 10 # set cell size to 1000 metres
tree_simple$ID = 3
tree_simple.r <- terra::rasterize(tree_simple, r.raster, field = "ID") # rasterize the tree_simple object

tree_c = st_centroid(tree_t)
tree_c

parks_c = st_centroid(parks)
parks_c
parks_c = st_transform(parks_c, crs = 31982)
plot(parks_c$geometry)

bufs = c(100,500,1000,2000,5000)

bufz = st_buffer(parks_c, dist = bufs[1])
plot(bufz$geometry)

##  Probability of connectivity -----
# install.packages("remotes")
#remotes::install_github("connectscape/Makurhini")
library(Makurhini)

save.image(".RData")