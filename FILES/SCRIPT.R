# Instalando pacotes ------------------------------------------------------
install.packages("dplyr")
install.packages("jsonlite")
install.packages("tidyverse")

# Carregando pacotes ------------------------------------------------------
library(dplyr)
library(jsonlite)
library(tidyverse)

# Importando arquivo ------------------------------------------------------
bechdel <- fromJSON("http://bechdeltest.com/api/v1/getAllMovies")

glimpse(bechdel)

# Manipulando os dados ----------------------------------------------------
bechdel <- bechdel %>%
  mutate(
    indice_bechdel = case_when(
      rating == 0 ~ "Menos de duas mulheres",
      rating == 1 ~ "Pelo menos duas mulheres",
      rating == 2 ~ "... que conversam entre si",
      rating == 3 ~ "... sobre algo que não seja homem"
    ),
    indice_bechdel = fct_reorder(indice_bechdel, rating),
    decada = (year %/% 10)*10
  )

# Bechdel por década ------------------------------------------------------
bechdel_por_decada <- bechdel %>%
  count(decada, indice_bechdel, .drop = FALSE)

bechdel_por_decada %>%
  ggplot(aes(x = decada, fill = indice_bechdel, y = n)) +
  geom_col(position = "fill", colour = "black", width = 10) +
  geom_text(aes(label = indice_bechdel), position = "fill", data = filter(bechdel_por_decada, decada == 1950), vjust = 2.5, colour = "white", fontface = "bold") +
  scale_fill_brewer(palette = "RdBu", guide = "none") +
  labs(x = "Década", y = "Proporção", title = "Evolução dos Ratings Bechdel pelas Décadas") +
  scale_y_continuous(labels = scales::percent) +
  theme(
    panel.grid = element_blank()
  ) 

# API Key -----------------------------------------------------------------
Sys.getenv('OMDB_APIKEY')

# Chamando API ------------------------------------------------------------
library(glue)
pega_info_imdb <- function(imdbid) {
  glue("http://www.omdbapi.com/?apikey={Sys.getenv('OMDB_APIKEY')}&i=tt{imdbid}") %>%
    fromJSON() %>%
    as_tibble()
}

pega_info_imdb_safe <- safely(pega_info_imdb)

bechdel_com_imdb <- bechdel %>%
  as_tibble() %>%
  mutate(
    infos_imdb = map(imdbid, pega_info_imdb_safe)
  )

# Manipulando os dados da API ---------------------------------------------
arruma_infos_imdb <- function(infos_imdb) {
  if(!is.null(infos_imdb$Ratings)) {
    infos_imdb %>% 
      nest(Ratings = c(Ratings)) %>%
      mutate(Ratings = map(Ratings, ~.x$Ratings %>% filter(Source %in% "Internet Movie Database"))) %>%
      unnest(Ratings)
  } else {
    infos_imdb
  }
}

bechdel_com_imdb <- bechdel_com_imdb %>%
  mutate(
    deu_errado = map_lgl(infos_imdb, ~ !is.null(.x$error)),
    infos_imdb = infos_imdb %>% map("result") %>% map(arruma_infos_imdb)
  ) %>%
  unnest(infos_imdb) %>%
  mutate(
    imdbRating_num = imdbRating %>% parse_number()
  )

glimpse(bechdel_com_imdb)

# Filmes brasileiros ------------------------------------------------------
bechdel_com_imdb %>%
  filter(str_detect(Country, "Brazil")) %>%
  select(year, Title, rating) %>%
  arrange(rating) %>%
  knitr::kable()

# Filmes premiados --------------------------------------------------------
bechdel_por_decada_e_premiacao <- bechdel_com_imdb %>%
  mutate(
    premiacao = case_when(
      str_detect(Awards, "N/A") | is.na(Awards) ~ "Sem Premiação",
      str_detect(Awards, "Won.*Oscar") ~ "Vencedor de Oscar",
      str_detect(Awards, "Won.*(BAFTA|Golden Globe)") ~ "Vencedor de BAFTA/Golden Globe",
      str_detect(Awards, "Nominated") ~ "Nomeado ao Oscar/BAFTA/Golden Globe",
      str_detect(Awards, "win") ~ "Vencedor de outros prêmios",
      str_detect(Awards, "nomination") ~ "Nomeado a outros prêmios",
      TRUE ~ "Outro"
    )
  ) %>%
  count(premiacao, decada, indice_bechdel, .drop = FALSE)

# Evolução Bechdel por década ---------------------------------------------
bechdel_por_decada_e_premiacao %>%
  filter(decada >= 1940) %>%
  ggplot(aes(x = decada, fill = indice_bechdel, y = n)) +
  geom_col(position = "fill", colour = "black", width = 10) +
  scale_fill_brewer(palette = "RdBu", guide = "none") +
  labs(x = "Década", y = "Proporção", title = "Evolução dos Ratings Bechdel pelas Décadas") +
  scale_y_continuous(labels = scales::percent) +
  theme(
    panel.grid = element_blank()
  ) +
  facet_wrap(vars(premiacao), ncol = 3)

# Nota IMDB ---------------------------------------------------------------
bechdel_por_decada_e_pais <- bechdel_por_decada_e_pais %>%
  mutate(
    imdbVotes = parse_number(imdbVotes),
    passou_no_teste = case_when(
      rating %in% 3 ~ "Sim",
      TRUE ~ "Não"
    )
  )

bechdel_nota_por_decada <- bechdel_por_decada_e_pais %>%
  group_by(pais) %>%
  filter(n() > 10) %>%
  group_by(pais, decada, passou_no_teste) %>%
  summarise(
    imdb_media = mean(imdbRating_num, na.rm = TRUE),
    imdb_dp = sd(imdbRating_num, na.rm = TRUE),
    imdb_inf = imdb_media - 2*imdb_dp,
    imdb_sup = imdb_media + 2*imdb_dp
  )

bechdel_nota_por_decada %>% 
  filter(decada >= 1940) %>%
  ggplot(aes(x = decada, y = imdb_media, colour = passou_no_teste)) +
  geom_line() +
  geom_point() +
  geom_jitter(data = bechdel_por_decada_e_pais %>% filter(decada >= 1940), aes(y = imdbRating_num), alpha = 0.05) +
  geom_ribbon(aes(ymin = imdb_inf, ymax = imdb_sup, fill = passou_no_teste), alpha = 0.1) +
  facet_wrap(vars(pais)) +
  labs(x = "Década", y = "Nota IMDB", colour = "Passou no Teste", fill = "Passou no Teste", title = "Notas do IMDB vs Teste de Bechdel") +
  scale_x_continuous(breaks = c(1950, 2020)) +
  theme(legend.position = "top")