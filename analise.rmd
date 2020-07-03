#Análise TCE-MG

```{r setup, include=TRUE, message=FALSE, warning=FALSE}
knitr::opts_chunk$set(echo = TRUE, message=FALSE, include = TRUE)
library(dplyr)
library(janitor)
library(kableExtra)
```

Todos os arquivos abertos aqui são o resultado do agrupamento dos arquivos disponíveis para todos os municípios de Minas Gerais. Para saber mais, acesse o scrip ```cria_arquivos.R```

##Licitação

** Arquivos relacionados com licitação**:<br>
```{r}
lic <- list.files(pattern = "licitacao")

for(i in 1:length(lic)){
  load(lic[i]) }

print(paste0(lic))
```
<br><br>
O arquivo ```licitacao.licitacao``` é o mais completo, constando as seguintes informações:

```{r}
head(licitacao.licitacao) %>%
  kable() %>%
  kable_styling() %>%
  scroll_box(width = "900px", height = "200px")
```
<br><br>

###Licitações de merenda em 2020
<br><br>

Primeiro, vou verificar quais são as licitações que permanecem com os critérios do [TDPM](https://github.com/voigtjessica/ta-na-mesa-dados/blob/master/code/licitacoes/processa_licitacoes.R) :
<br>
```{r}

licitacao.licitacao %>%
  mutate(DS_OBJETO_PROCESSED = iconv(dsc_objetoedital, 
                                              from="UTF-8", 
                                              to="ASCII//TRANSLIT"),
         isAlimentacao = grepl("^.*(genero.*aliment|aliment.*esc|genero.*agric.*famil|merenda|pnae).*$",
                                        tolower(DS_OBJETO_PROCESSED))) %>%
  filter(isAlimentacao == TRUE) %>%
  select(dsc_objetoedital) %>%
  kable() %>%
  kable_styling() %>%
  scroll_box(height = "200px")
```
<br><br>
Existe 37 licitações dentro dos critérios da UFCG no TDPM, mas eles ainda captam muitas licitações fora do escopo, vou então apenas adicionar um filtro "merenda" : 
<br>
```{r}
licitacao.licitacao %>%
  filter(grepl("MERENDA", dsc_objetoedital) |
           grepl("ALIMENTALÇÃO ESCOLAR", dsc_objetoedital )) %>%
  select(dsc_objetoedital) %>%
  kable() %>%
  kable_styling() %>%
  scroll_box(height = "200px")
```
<br><br>
## Verificando as informações
<br>
```{r}

licitacao.licitacao %>%

#Filtrando merenda, como é feito com os dados do RS:
  
  filter(grepl("MERENDA", dsc_objetoedital) |
           grepl("ALIMENTALÇÃO ESCOLAR", dsc_objetoedital )) %>%
  select(seq_licitacao, num_proclicitacao, num_anoexercicio, seq_orgao, cod_municipio, dsc_objetoedital,
         dat_pubedital, dat_edital, dat_recebdoc, dat_abertura, dat_pubveiculo1, dat_pubveiculo2) %>%
  left_join(licitacao.item_regadesao) %>%
  select(-c(num_mesexercicio)) %>%
  kable() %>%
  kable_styling() %>%
  scroll_box(height = "200px")
```
<br><br>
A tabela de itens de licitação é a tabela ```licitacao.item_regadesao```. No entanto, não existe nenhum match para as licitações de merenda escolar. Não sei ao certo essa tabela então diz respeito a todos os itens.
<br>
Por fim:
<br>
 * Objeto : ```dsc_objetoedital```<br>
 * Licitante : ```cod_municipio``` (IBGE)<br>
 * Link para edital : não está disponível nos dados abertos<br>
 * Itens licitados : não deu match, acredito que teremos que fazer alguma espécie de parceria para esses itens entrarem<br>
 * Valores itens licitados : não deu match<br>
 * Eventos relacionados à licitação (abertura, homologação) : ```dat_pubedital```, ```dat_edital```, ```dat_recebdoc```, ```dat_abertura```, ```dat_pubveiculo1```, ```dat_pubveiculo2``` .
<br><br><br>
---

## Contratos

** Arquivos relacionados com contrato**: <br>
```{r}
con <- list.files(pattern = "contrato")

for(i in 1:length(con)){
  load(con[i]) }

print(paste0(con))
```
<br>

Olhando o arquivo principal: contrato.contrato:

<br>
```{r}
head(contrato.contrato) %>%
  kable() %>%
  kable_styling() %>%
  scroll_box(height = "200px")
```

<br><br> 
Eu devo conectar o contrato com a licitação pelo ```seq_licitacao```. Assim, vou puxar as licitações de mereda e conectar ao contrato:
<br>
```{r}
con_merenda <- licitacao.licitacao %>%
  filter(grepl("MERENDA", dsc_objetoedital) |
           grepl("ALIMENTALÇÃO ESCOLAR", dsc_objetoedital )) %>%
  distinct(cod_municipio, num_anoexercicio ,seq_licitacao) %>%
  inner_join(contrato.contrato)

con_merenda %>%
  kable() %>%
  kable_styling() %>%
  scroll_box(height = "200px")
```
<br><br>
Agora olhando as informações de contrato relevantes ao projeto:
<br>
```{r}
con_merenda %>%
  select(cod_municipio, num_anoexercicio, seq_licitacao, seq_contrato, vlr_contrato,
         num_doctocontratado, dsc_objetocontrato, dat_iniciovigencia, dat_fimvigencia,
         vlr_empenhado, vlr_liquidado, vlr_pago) %>%
  kable() %>%
  kable_styling() %>%
  scroll_box(height = "200px")
```
         

* contratos vigência: ```dat_iniciovigencia```, ```dat_fimvigencia``` <br>
* fornecedores CNPJ/CPF: ```num_doctocontratado``` <br>
* fornecedores razão social : não tem, temos que cruzar com QSA ou receita federal <br>
* itens contratados : não existe a informação <br>
* valores itens contratados : não existe a informação <br>
* eventos relacionados à contratos (início da vigência, eventual rescisão, empenhos e pagamentos): ```vlr_empenhado```, ```vlr_liquidado```, ```vlr_pago``` <br><br>

Existem também dados de empenhos que estão dentre as tabelas que eu processei com o script ```cria_arquivos``` e os Rdatas estão no repositório, mas não vou trabalhar com elas aqui porque acho que as informações acima já são suficientes.

## Resultados:

Não acredito ser possível integrar o estado de MG no TDPM, pois as informações de itens, que são cruciais, não estão completas, de forma que não existem dados para as licitações de merenda.