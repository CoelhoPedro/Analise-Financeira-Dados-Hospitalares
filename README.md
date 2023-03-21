# Analise Financeira de Dados Hospitalares

Análise financeira de dados hospitalares com linguagem R, SQL e Regressão Linear

Fontes de dados:

https://www.cms.gov/Research-Statistics-Data-and-Systems/Statistics-Trends-and-Reports/Medicare-Provider-Cost-Report/HospitalCostPUF

https://healthdata.gov/

Os dados são resultados de uma pesquisa nacional de custos hospitalares realizada pela US Agency for Healthcare que consiste em registros hospitalares de amostras de pacientes internados. Os dados são da cidade de Wisconsin e referem-se a pacientes na faixa etária de 0 a 17 anos.

### Objetivos do projeto

Uma rede de hospitais gostaria de compreender as variáveis relacionadas aos gastos com internações hospitalares de pacientes.

O projeto é composto de duas etapas. Primeiramente vamos explorar os dados usando Linguagem SQL através da linguagem R para responder 10 perguntas de negócio. Depois, vamos realizar análise estatística com Linguagem R através do Teste ANOVA e Regressão Linear, e responder 7 perguntas de negócio.

### Documentação e Resultados

A documentação do projeto e os resultados das análises podem ser acessados através do link:

https://rpubs.com/CoelhoPedro/1018257

### Perguntas de negócio - Análise exploratória

1 - Quantas raças estão representadas no dataset?

2 - Qual a idade média dos pacientes?

3 - Qual a moda da idade dos pacientes?

4 - Qual a variância da coluna idade?

5 - Qual o gasto total com internações hospitalares por idade?

6 - Qual idade gera o maior gasto total com internações hospitalares?

7 - Qual o gasto total com internações hospitalares por gênero?

8 - Qual a média de gasto com internações hospitalares por raça do paciente?

9 - Para  pacientes  acima  de  10  anos,  qual  a  média  de  gasto  total  com  internações hospitalares?

10 - Considerando o item anterior, qual idade tem média de gastos superior a 3000?

### Perguntas de negócio - Análise estatística

1 - Qual a distribuição da idade dos pacientes que frequentam o hospital?

2 - Qual faixa etária tem o maior gasto total no hospital?

3 - Qual grupo baseado em diagnóstico (Aprdrg) tem o maior gasto total no hospital?

4 - A raça do paciente tem relação com o total gasto em internações no hospital?

5 - A combinação de idade e gênero dos pacientes influencia no gasto total em internações no hospital?

6 - Como o tempo de permanência é o fator crucial para pacientes internados, desejamos descobrir se o tempo de permanência pode ser previsto a partir de idade, gênero e raça.

7 - Quais variáveis têm maior impacto nos custos de internação hospitalar?