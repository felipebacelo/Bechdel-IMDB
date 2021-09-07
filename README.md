 <p align="center">
<a href= "https://img.shields.io/github/repo-size/felipebacelo/Bechdel-IMDB?style=for-the-badge"><img src="https://img.shields.io/github/repo-size/felipebacelo/Bechdel-IMDB?style=for-the-badge"/></a>
<a href= "https://img.shields.io/github/languages/count/felipebacelo/Bechdel-IMDB?style=for-the-badge"><img src="https://img.shields.io/github/languages/count/felipebacelo/Bechdel-IMDB?style=for-the-badge"/></a>
<a href= "https://img.shields.io/github/forks/felipebacelo/Bechdel-IMDB?style=for-the-badge"><img src="https://img.shields.io/github/forks/felipebacelo/Bechdel-IMDB?style=for-the-badge"/></a>
<a href= "https://img.shields.io/bitbucket/pr-raw/felipebacelo/Bechdel-IMDB?style=for-the-badge"><img src="https://img.shields.io/bitbucket/pr-raw/felipebacelo/Bechdel-IMDB?style=for-the-badge"/></a>
<a href= "https://img.shields.io/bitbucket/issues/felipebacelo/Bechdel-IMDB?style=for-the-badge"><img src="https://img.shields.io/bitbucket/issues/felipebacelo/Bechdel-IMDB?style=for-the-badge"/></a>
</p>

# Análise de Teste Bechdel com Notas do IMDB

## Objetivo ##

<p>Contribuir com um trabalho analítico extraindo informações e storytelling baseados em dados para insights bem como, uma forma de desenvolver e consolidar meus conhecimentos no campo da análise de dados desenvolvendo uma análise descritiva com o uso da linguagem de programação R através da IDE RStudio.</p>

## Origem dos Dados ##

<p>Os dados necessários para realizar está análise estão disponíveis em: https://bechdeltest.com.</p>
<p>O site disponibiliza uma API para acessar os dados. Então para trazer para o R é bem simples.</p>

## Instalação das Ferramentas ##
  
  - [R - 4.1.0](https://www.r-project.org/)
  - [RSudio - 1.4.1725](https://rstudio.com/)

## Desenvolvimento ##

### Leitura da Base ###

<p>Através da API conseguimos obter os dados para a análise.</p>

* A coluna <strong>imdbid</strong> permite coletar informações do IMDB para maiores análises.
* A coluna <strong>rating</strong> vai de 0 a 3, e representa quantas regras são atendidas no filme.

### Manipulação dos Dados ###

<p>À princípio, rotulamos as informações de <strong>rating</strong> para seguirmos com as visualizações.</p>

### Visualizações ###

<p>Inicialmente, fiz um gráfico para visualizar a evolução dos ratings Bechdel ao longo das décadas.</p>
<p align="center">
<img src="https://github.com/felipebacelo/Bechdel-IMDB/blob/main/IMAGES/PLOT-1.png"/></p>
<p>Aqui realizamos a chamada da API do OMDB usando tanto minha API KEY quanto o <strong>imdbid</strong>. A chamada irá retornar um arquivo json que pode ser facilmente formatado. Com isso, conseguimos visualizar a evolução dos ratings Bechdel ao longo das décadas por país.</p>
<p align="center">
<img src="https://github.com/felipebacelo/Bechdel-IMDB/blob/main/IMAGES/PLOT-2.png"/></p>
<p>A base traz informação de premiações. Filmes sem premiação não destoam dos filmes premiados em termos de avaliação de Bechdel, o que indica que o machismo não está relacionado com o sucesso de um filme.</p>
<p align="center">
<img src="https://github.com/felipebacelo/Bechdel-IMDB/blob/main/IMAGES/PLOT-3.png"/></p>
<p>Analisando agora as notas do IMDB, podemos perceber que também não diferem entre filmes que passaram no teste e filmes que não passaram no teste de Bechdel.</p>
<p align="center">
<img src="https://github.com/felipebacelo/Bechdel-IMDB/blob/main/IMAGES/PLOT-4.png"/></p>

## Referências ##
  
* [Curso-R](https://curso-r.com/)
* [R para Data Science](https://r4ds.had.co.nz/)

## Licenças ##

_MIT License_
_Copyright   ©   2021 Felipe Bacelo Rodrigues_
