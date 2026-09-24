# LEI/COMBIO Reunião de análise de dados 
# Dia: 24/09/2026
# Autores: Lucas, Edison, Ivan, Vini, Sufyan, Catarina, Aléxia, Amanda, Fábio, Marina

# O library é a função que carrega um pacote no R.
# O pacote sf é usado para manipulação de dados espaciais no R.
library(sf)

# O pacote terra também é usado para manipulação de dados espaciais, mas ele é mais otimizado para grandes datasets 
library(terra)

# O argumento da função rast é o diretório do arquivo raster, o qual precisa estar entre aspas
# Necessário criar um objeto/variável para salvar o resultado da função rast() e poder manipulá-lo de modo mais eficiente
rast_bel = rast("dataset/spatial/brazil_coverage-col4_10m_2025.tif")
plot(rast_bel)

# A função vect carrega um arquivo vetorial (shapefile) no R. O argumento da função vect é o diretório do arquivo shapefile, o qual precisa estar entre aspas
tree_simple = vect("dataset/spatial/simple_trees.shp")

