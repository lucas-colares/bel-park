# LEI/COMBIO Reunião de análise de dados 
# Dia: 24/09/2026
# Autores: Lucas, Edison, Ivan, Vini, Sufyan, Catarina, Aléxia, Amanda, Fábio, Marina

# O library é a função que carrega um pacote no R.
# O pacote sf é usado para manipulação de dados espaciais no R.
library(sf)

# O pacote terra também é usado para manipulação de dados espaciais, mas ele é mais otimizado para grandes datasets 
library(terra)

# O argumento da função rast é o diretório do arquivo raster, o qual precisa estar entre aspas
# Necessário criar um objeto para salvar no repositório
rast_bel = rast("dataset/spatial/brazil_coverage-col4_10m_2025.tif")
plot(rast_bel)

# Para salvar resultados, cria-se objetos/variáveis como simple_tree e rast_bel

# O argumento da função vect é o diretório do arquivo shapefile, o qual precisa estar entre aspas.
simple_tree = vect("dataset/spatial/simple_trees.shp")

#Um arquivo KML (Keyhole Markup Language) é um formato baseado em XML usado para armazenar
# e exibir dados geográficos, como pontos, linhas, polígonos e imagens em softwares de mapas.
bel_park = vect("dataset/spatial/praças_belem.kml")
plot(bel_park)

ana_park = vect("dataset/spatial/praças_ananindeua.kml")
plot(ana_park)

# Transformar o formato do arquivo, pois a função st_centroid faz parte da 
# library sf e não aceita o formato SpatVector gerado pela library terra
bel_t = st_as_sf(bel_park)
bel_park
bel_t

# A função st_centroid calcula o centroide de um objeto espacial, 
# que é o ponto médio de uma geometria. O centroide é útil para 
# representar a localização central de um polígono ou linha.
bel_c = st_centroid(bel_t)
plot(bel_c)

# Função c(concatenar): Une diversos textos/números dentro de uma mesma saída / objeto / variável
bufs = c(100,500,1000)

# O pacote landscapemetrics é utilizado para calcular métricas de paisagem
# install.packages("landscapemetrics") para fazer instalação do pacote
# caso ainda não esteja instalado no ambiente; só é necessário rodar uma vez
library(landscapemetrics)

# função st_transform é utilizada para transformarmos um arquivo contendo coordenadas de um sistema para outro, nesse caso, de 
# WGS 84 para UTM. 
# primeiro argumento é qual arquivo / variável / objeto queremos modificar, o segundo é o sistema de medida
bel_c = st_transform(bel_c, crs = 31982) # CRS é o código EPSG do sistema de coordenadas

# função usada para identificar o sistema de coordenadas (crs) usado naquele objeto / variável
st_crs(bel_c)

# função usada para calcular o buffer para os centroides. Ela calcula apenas um tamanho por vez, então determinamos qual
# queremos em "dist".
buf1 = st_buffer(bel_c, dist = bufs[3]) # Como criamos um objeto com três tamanhos de buffer, ao invés de determinar o número, determinamos qual queremos dentro do objeto

# o elemento "$" serve para selecionar uma ou mais colunas específicas para a plotagem do gráfico, ou criar uma coluna nova
plot(buf1$geometry)
buf1

buf1_t = st_transform(buf1, crs = 4326) # Transformando o sistema de coordenadas de volta para WGS 84

# Função para recortar uma área especifica. 
cropped = crop(rast_bel,buf1_t[1,],mask=TRUE) #"[]" para especificar um valor / posição na lista. "," separa entre linhas e colunas, antes da virgula são linhas, depois da virgula são colunas.
plot(cropped)

# Função que calcula cobertura e uso do solo
land_prop = lsm_c_pland(cropped)
land_prop

# Identificar o número de linhas / buffers
nrow(buf1_t)

# Cria uma lista vazia
lista_vazia = list()
# Loop: vamos repetir a função anterior várias vezes

bufs
for(y in bufs){
  buf1 = st_buffer(bel_c, dist = y) # Como criamos um objeto com três tamanhos de buffer, ao invés de determinar o número, determinamos qual queremos dentro do objeto
  buf1_t = st_transform(buf1, crs = 4326) # Transformando o sistema de coordenadas de volta para WGS 84
  print(paste("Calculando métricas para buffer de",y,"metros")) # Função print() serve para mostrar o que está acontecendo no loop, e a função paste() serve para concatenar textos e variáveis
  for(x in 1:nrow(buf1_t)){ #nrow(buf1_t) faz com que ele repita a função na mesma quantidade de linhas que temos no nosso objeto
    cropped = crop(rast_bel,buf1_t[x,],mask=TRUE) #"[]" para especificar um valor / posição na lista. "," separa entre linhas e colunas, antes da virgula são linhas, depois da virgula são colunas.
    land_prop = lsm_c_pland(cropped)
    land_prop$id_park = x 
    land_prop$escala = y   
    lista_vazia[[x]] = land_prop
  }
}

planilha_final = do.call(rbind, lista_vazia) # Função que junta todas as listas criadas em uma só

planilha_final

# Para salvar em uma planilha; possui dois argumentos, o primeiro é o que queremos  
# salvar como planilha e o segundo é o destino (pasta) em que o arquivo será salvo
write.csv(planilha_final,"dataset/planilha_paisagem.csv")

