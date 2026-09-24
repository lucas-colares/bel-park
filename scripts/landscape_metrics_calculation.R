library(sf)
library(terra)
source("source")

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
