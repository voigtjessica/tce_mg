#TCE MG

library(data.table)
library(dplyr)
library(janitor)

# Junção de todos os contratos, empenhos, etc.
#Origem dos arquivos: https://dadosabertos.tce.mg.gov.br/view/xhtml/paginas/downloadArquivos.xhtml

#Primeiro vendo as pastas da licitação:
setwd("C:/Users/coliv/Documents/tce_relatorio_contratos_licitacoes/MG/viabilizacao_tce_mg/licitacao/licitacao")

#Criando um vetor de pastas para um loop futuro
pastas <- list.dirs()
pastas <- gsub("\\.\\/", "", pastas)

# eu tenho que fazer um loop para cada tipo de arquivo, já que dentro de cada pasta aparentemente só existe 
# um arquivo para cada tipo

######################################### início do loop ######################################
###################################### documentos licitação ###################################

df <- data.frame()

#explora as pastas, por enquanto só tem duas. As pastas foram criadas fora do loop
for(i in 2:length(pastas)){
  
  print(paste0('pasta: ', pastas[i]))
  
  p <- paste0("C:/Users/coliv/Documents/tce_relatorio_contratos_licitacoes/MG/viabilizacao_tce_mg/licitacao/licitacao/",
              pastas[i])
  
  setwd(p)
  
  arq <- list.files(pattern = ".csv")
  
  df_pasta <- data.frame(arq) %>%
    mutate(dir = p,
           tipo_arqs = gsub(".csv", "", arq),  
           tipo_arqs = gsub("[[:digit:]]", "", tipo_arqs),
           tipo_arqs = gsub("\\.\\.", "", tipo_arqs))
  
  df <- rbind(df, df_pasta)
}

#Olhando as presenças dos tipos de arquivos:

df %>%
  group_by(tipo_arqs) %>%
  summarise(total = n())

#Temos 853 arquivos para cada tipo de arquivo.
#Agora vou fazer um segundo loop para juntar os arquivos de um mesmo tipo.

tipo_arq <- unique(df$tipo_arqs)

for(i in 1:length(tipo_arq)){
  
  #Dataframe que vai receber tudo:
  t <- tipo_arq[i]
  a <- data.frame()
  
  #Criando o df que vai conter os arquivos e o diretório deles.
  df_arquivos <- df %>%
    filter(tipo_arqs == tipo_arq[i]) %>%
    mutate(arq = as.character(arq))
  
  print(paste0('trabalhando com arquivos ', t))
  
  #Segundo loop para abrir arquivos:
  for(z in 1:nrow(df_arquivos)){
    
    d <- df_arquivos$dir[z]
    e <- df_arquivos$arq[z]
    
    print(paste0('abrindo ', e))
    
    setwd(d)
    ee <- fread(e, encoding = "UTF-8")
    ee <- ee %>%
      clean_names() %>%
      mutate_all(as.character)
    
    a <- rbind(a, ee)
  }

assign(t, a)

}

#Deu certo.
#Salvando esses #13 negócios

setwd("C:/Users/coliv/Documents/tce_relatorio_contratos_licitacoes/MG/viabilizacao_tce_mg/tce_mg")

save(licitacao.venc_regadesao, file='licitacao.venc_regadesao.Rdata')
save(licitacao.regadesao, file='licitacao.regadesao.Rdata')
save(licitacao.quadro_licitacao, file='licitacao.quadro_licitacao.Rdata')
save(licitacao.licitacao, file='licitacao.licitacao.Rdata')
save(licitacao.item_regadesao, file='licitacao.item_regadesao.Rdata')
save(licitacao.homolog_licitacao, file='licitacao.homolog_licitacao.Rdata')
save(licitacao.hab_licitacao, file='licitacao.hab_licitacao.Rdata')
save(licitacao.forn_dispensa, file='licitacao.forn_dispensa.Rdata')
save(licitacao.dispensa, file='licitacao.dispensa.Rdata')
save(licitacao.cred_licitacao, file='licitacao.cred_licitacao.Rdata')
save(licitacao.cred_dispensa, file='licitacao.cred_dispensa.Rdata')
save(licitacao.cotacao_licitacao, file='licitacao.cotacao_licitacao.Rdata')
save(licitacao.cotacao_dispensa, file='licitacao.cotacao_dispensa.Rdata')
save(licitacao.comissao_licitacao, file='licitacao.comissao_licitacao.Rdata')

#limpando tudo, porque a vida é efêmera.
rm(list = ls())

#Agora vou fazer o mesmo com os arquivos de contratos.

setwd("C:/Users/coliv/Documents/tce_relatorio_contratos_licitacoes/MG/viabilizacao_tce_mg/contrato/contrato")

pastas <- list.dirs()
pastas <- gsub("\\.\\/", "", pastas)

#Fazendo a lista de arquivos e diretórios

df <- data.frame()

for(i in 2:length(pastas)){
  
  print(paste0('pasta: ', pastas[i]))
  
  p <- paste0("C:/Users/coliv/Documents/tce_relatorio_contratos_licitacoes/MG/viabilizacao_tce_mg/contrato/contrato/",
              pastas[i])
  
  setwd(p)
  
  arq <- list.files(pattern = ".csv")
  
  df_pasta <- data.frame(arq) %>%
    mutate(dir = p,
           tipo_arqs = gsub(".csv", "", arq),  
           tipo_arqs = gsub("[[:digit:]]", "", tipo_arqs),
           tipo_arqs = gsub("\\.\\.", "", tipo_arqs))
  
  df <- rbind(df, df_pasta)
}

df %>%
  group_by(tipo_arqs) %>%
  summarise(total = n())

#Temos 853 arquivos para cada tipo de arquivo.
#Agora vou fazer um segundo loop para juntar os arquivos de um mesmo tipo.

tipo_arq <- unique(df$tipo_arqs)

for(i in 1:length(tipo_arq)){
  
  #Dataframe que vai receber tudo:
  t <- tipo_arq[i]
  a <- data.frame()
  
  #Criando o df que vai conter os arquivos e o diretório deles.
  df_arquivos <- df %>%
    filter(tipo_arqs == tipo_arq[i]) %>%
    mutate(arq = as.character(arq))
  
  print(paste0('trabalhando com arquivos ', t))
  
  #Segundo loop para abrir arquivos:
  for(z in 1:nrow(df_arquivos)){
    
    d <- df_arquivos$dir[z]
    e <- df_arquivos$arq[z]
    
    print(paste0('abrindo ', e))
    
    setwd(d)
    ee <- fread(e, encoding = "UTF-8")
    ee <- ee %>%
      clean_names() %>%
      mutate_all(as.character)
    
    a <- rbind(a, ee)
  }
  
  assign(t, a)
  
}

setwd("C:/Users/coliv/Documents/tce_relatorio_contratos_licitacoes/MG/viabilizacao_tce_mg/tce_mg")

save(contrato.apostilamento, file="contrato.apostilamento.Rdata")
save(contrato.contrato, file="contrato.contrato.Rdata")
save(contrato.rescisao, file="contrato.rescisao.Rdata")
save(contrato.termoaditivo, file="contrato.termoaditivo.Rdata")

######################################################################################################3

#Agora eu vou começar os emprenhos
rm(list = ls())

setwd('C:/Users/coliv/Documents/tce_relatorio_contratos_licitacoes/MG/viabilizacao_tce_mg/empenho/empenho')

pastas <- list.dirs()
pastas <- gsub("\\.\\/", "", pastas)


df <- data.frame()

for(i in 2:length(pastas)){
  
  print(paste0('pasta: ', pastas[i]))
  
  p <- paste0('C:/Users/coliv/Documents/tce_relatorio_contratos_licitacoes/MG/viabilizacao_tce_mg/empenho/empenho/',
              pastas[i])
  
  setwd(p)
  
  arq <- list.files(pattern = ".csv")
  
  df_pasta <- data.frame(arq) %>%
    mutate(dir = p,
           tipo_arqs = gsub(".csv", "", arq),  
           tipo_arqs = gsub("[[:digit:]]", "", tipo_arqs),
           tipo_arqs = gsub("\\.\\.", "", tipo_arqs))
  
  df <- rbind(df, df_pasta)
}

## 
tipo_arq <- unique(df$tipo_arqs)

# no loop, o "empenho.rsp" está dando problema. Então foi fazer um loop para os outros
# tipos de arquivos e esse último eu vou fazer separadamente.

#Loop para os tipo_arq == "empenho.credor_empenho", "empenho.credor_rsp", "empenho.empenho"   
for(i in 1:3){
  
  #Dataframe que vai receber tudo:
  t <- tipo_arq[i]
  a <- data.frame()
  
  #Criando o df que vai conter os arquivos e o diretório deles.
  df_arquivos <- df %>%
    filter(tipo_arqs == tipo_arq[i]) %>%
    mutate(arq = as.character(arq))
  
  print(paste0('trabalhando com arquivos ', t))
  
  #Segundo loop para abrir arquivos:
  for(z in 1:nrow(df_arquivos)){
    
    #Construindo as colunas
    d <- df_arquivos$dir[1]
    setwd(d)
    
    ex <- df_arquivos$arq[1]
    
    exemploe <- fread(ex, encoding = "UTF-8", fill=TRUE, sep=";")
    colunas <- names(exemploe)
    
    #Agora pegando o diretório do que eu vou abrir
    d <- df_arquivos$dir[z]
    setwd(d)
    
    e <- df_arquivos$arq[z]
    
    print(paste0(z, ' abrindo ', e))
    
    
    ee <- fread(e, encoding = "UTF-8", fill=TRUE, sep=";")
    names(ee) <- colunas
    
    ee <- ee %>%
      clean_names() %>%
      mutate_all(as.character)
    
    a <- rbind(a, ee)
  }
  
  assign(t, a)
  
}

#Salvando os outros empenhos:

setwd("C:/Users/coliv/Documents/tce_relatorio_contratos_licitacoes/MG/viabilizacao_tce_mg/tce_mg")

save(empenho.credor_empenho, file="empenho.credor_empenho.Rdata")
save(empenho.credor_rsp, file="empenho.credor_rsp.Rdata")
save(empenho.empenho, file="empenho.empenho.Rdata")

#######################################################################################################
rm(list = ls())

#Agora para o último tipo de arquivo: "empenho.rsp"

setwd('C:/Users/coliv/Documents/tce_relatorio_contratos_licitacoes/MG/viabilizacao_tce_mg/empenho/empenho')

pastas <- list.dirs()
pastas <- gsub("\\.\\/", "", pastas)


df <- data.frame()

for(i in 2:length(pastas)){
  
  print(paste0('pasta: ', pastas[i]))
  
  p <- paste0('C:/Users/coliv/Documents/tce_relatorio_contratos_licitacoes/MG/viabilizacao_tce_mg/empenho/empenho/',
              pastas[i])
  
  setwd(p)
  
  arq <- list.files(pattern = ".csv")
  
  df_pasta <- data.frame(arq) %>%
    mutate(dir = p,
           tipo_arqs = gsub(".csv", "", arq),  
           tipo_arqs = gsub("[[:digit:]]", "", tipo_arqs),
           tipo_arqs = gsub("\\.\\.", "", tipo_arqs))
  
  df <- rbind(df, df_pasta)
}

## 
tipo_arq <- unique(df$tipo_arqs)

#Dataframe que vai receber tudo: 
t <- tipo_arq[4]
a <- data.frame()

#Criando o df que vai conter os arquivos e o diretório deles.
df_arquivos <- df %>%
  filter(tipo_arqs == tipo_arq[4]) %>%
  mutate(arq = as.character(arq))

#Construindo as colunas
d <- df_arquivos$dir[1]
setwd(d)

ex <- df_arquivos$arq[1]

exemploe <- fread(ex, encoding = "UTF-8")
colunas <- names(exemploe)

#Segundo loop para abrir arquivos:
for(z in 1:nrow(df_arquivos)){
  

  d <- df_arquivos$dir[z]
  setwd(d)
  
  e <- df_arquivos$arq[z]
  
  print(paste0(z, ' abrindo ', e))
  
  
  ee <- fread(e, encoding = "UTF-8", sep=";")
  names(ee) <- colunas
  
  ee <- ee %>%
    clean_names() %>%
    mutate_all(as.character)
  
  a <- rbind(a, ee)
}

assign(t, a)

#ufa, deu certo!

setwd("C:/Users/coliv/Documents/tce_relatorio_contratos_licitacoes/MG/viabilizacao_tce_mg/tce_mg")
save(empenho.rsp, file="empenho.rsp.Rdata")

#O problema aqui era na hora de importar o primeiro exemplo para as colunas, por alguma razão o 
#fread não estava interpretando o separador. Eu não tive tempo de debugar, só de resolver o problema, 
#por isso esse código tá meio capenga.

