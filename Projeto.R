library(dplyr)
library(sqldf)
library(ggplot2)

dados = read.csv("dataset.csv")
View(dados)

# Renomeando as variáveis
nome_colunas = c("Idade", "Sexo", "TempoInternaçao", "Raça", "CustoInternaçao", "GrupoDiagnosticoRefinado")
names(dados) = nome_colunas

# Checando valores missing
sum(is.na(dados))
dim(dados)

# Excluindo a única linha que contem um valor missing
dados = na.omit(dados)
dim(dados)

# Checando os tipos de dados
str(dados)

# Transformando a variável Sexo para fator
unique(dados$Sexo)
dados$Sexo = as.factor(dados$Sexo)

# Transformando a variável Raça para fator
unique(dados$Raça)
dados$Raça = as.factor(dados$Raça)

# Análise exploratória com linguagem SQL, para responder as perguntas de negócio
# Pergunta 1:
# Quantas raças estão representadas no dataset?

sqldf("select Raça, count(Raça) as NumeroRaças from dados group by Raça")

# Existem 6 raças no dataset
# Pergunta 2:
# Qual a idade média dos pacientes?

sqldf("select avg(Idade) from dados")

# A média de idade é de 5 anos
# Pergunta 3:
# Qual a moda da idade dos pacientes?

sqldf("select Idade, count(*) as Contagem from dados group by Idade order by Contagem desc limit 1")

# A idade que mais aparece é 0, com 306 registros
# Pergunta 4:
# Qual a variância da coluna idade?

sqldf("select variance(Idade) as Variancia from dados")

# A variância da idade é 48,34
# Pergunta 5:
# Qual o gasto total com internações hospitalares por idade?

sqldf("select Idade, sum(CustoInternaçao) as Custo from dados group by Idade")

# Pergunta 6
# Qual idade gera o maior gasto total com internações hospitalares?

sqldf("select Idade, max(Custo) as Custo from (select Idade, sum(CustoInternaçao) as Custo from dados group by Idade)")

# A idade que mais gera gasto total é a idade 0
# Pergunta 7
# Qual o gasto total com internações hospitalares por gênero?

sqldf("select Sexo, sum(CustoInternaçao) as Custo from dados group by Sexo")

# O sexo masculino gera mais gastos do que o feminino
# Pergunta 8
# Qual a média de gasto com internações hospitalares por raça do paciente?

sqldf("select Raça, avg(CustoInternaçao) as MediaCusto from dados group by Raça")

# Pergunta 9
# Para  pacientes  acima  de  10  anos,  qual  a  média  de  gasto  total  com  internações hospitalares?

sqldf("select Idade, avg(CustoInternaçao) as MediaCusto from dados where Idade > 10 group by Idade")

# A média de gasto com internações para pacientes acima de 10 anos é 3.213,66
# Pergunta 10
# Considerando o item anterior, qual idade tem média de gastos superior a 3000?

sqldf("Select Idade, avg(CustoInternaçao) as MediaCusto from dados where Idade > 10 group by Idade having MediaCusto > 3000")

# Análise estatística com regressão linear
# Pergunta 1
# Qual a distribuição da idade dos pacientes que frequentam o hospital?

summary(as.factor(dados$Idade))

ggplot(dados, aes(x = Idade)) +
  geom_histogram() +
  labs(title = "Distribuição da Idade") +
  ylab(label = "")

# Pergunta 2
# Qual faixa etária tem o maior gasto total no hospital?

gasto_total_faixa_etaria = aggregate(data = dados,
                                     CustoInternaçao ~ Idade,
                                     FUN = sum)
gasto_total_faixa_etaria

which.max(tapply(gasto_total_faixa_etaria$CustoInternaçao,
                 gasto_total_faixa_etaria$CustoInternaçao,
                 FUN = sum))

barplot(tapply(gasto_total_faixa_etaria$CustoInternaçao,
               gasto_total_faixa_etaria$Idade,
               FUN = sum))

# A faixa etária que possui o maior gasto total é entre 0 e 1 ano
# Pergunta 3
# Qual grupo baseado em diagnóstico (Aprdrg) tem o maior gasto total no hospital?

gasto_total_grupo = aggregate(data = dados,
                                     CustoInternaçao ~ GrupoDiagnosticoRefinado,
                                     FUN = sum)

gasto_total_grupo[which.max(gasto_total_grupo$CustoInternaçao),]

# O grupo que possui o maior gasto é o 640
# Pergunta 4
# A raça do paciente tem relação com o total gasto em internações no hospital?

# Vamos usar o teste ANOVA
# Variável dependente: CustoInternaçao
# Variável independente: Raça

# Hipóteses:
# H0 - A variável Raça não afeta a variável CustoInternação
# H1 - A variável Raça afeta a variável CustoInternação

teste_anova = aov(CustoInternaçao ~ Raça, data = dados)
summary(teste_anova)

# Conclusão:
# Valor-p > 0.05, logo, falhamos em rejeitar a H0.
# A raça do paciente não influencia no total gasto com internações no hospital

# Pergunta 5
# A combinação de idade e gênero dos pacientes influencia no gasto total em internações no hospital?

# Vamos usar o teste ANOVA mais uma vez
# Variável dependente: CustoInternaçao
# Variáveis independentes: Idade, Sexo

# Hipóteses:
# H0 - As variáveis Idade e Sexo não afetam a variável CustoInternação
# H1 - As variáves Idade e Sexo afetam a variável CustoInternação

teste_anova_2 = aov(CustoInternaçao ~ Idade + Sexo, data = dados)
summary(teste_anova_2)

# Conclusão:
# Valor-p < 0.05 para as duas variáveis independentes, logo, rejeitamos a H0.
# A raça e o sexo do paciente influenciam significativamente no total gasto com internações no hospital

# Pergunta 6
# Como o tempo de permanência é o fator crucial para pacientes internados,
# desejamos descobrir se o tempo de permanência pode ser previsto a partir de idade, gênero e raça.

# Faremos a previsão com um modelo de Regressão Linear
# Variável dependente: TempoInternaçao
# Variáveis independentes: Idade, Sexo, Raça

# H0 - Não há relação linear entre as variáveis dependente e independentes
# H1 - Há relação linear entre as variáveis dependente e independentes

modelo = lm(TempoInternaçao ~ Idade + Sexo + Raça, data = dados)
summary(modelo)

# Conclusão:
# Valor-p > 0.05 para todas as variáveis independentes, logo, falhamos em rejeitar a H0
# O tempo de permanência não pode ser previsto a partir da idade, gênero e raça.

# Pergunta 7
# Quais variáveis têm maior impacto nos custos de internação hospitalar?

# Faremos a previsão com um modelo de Regressão Linear novamente
# Variável dependente: CustoInternaçao
# Variáveis independentes: Idade, Sexo, Raça, TempoInternaçao, GrupoDiagnosticoRefinado

# H0 - Não há relação linear entre as variáveis dependente e independentes
# H1 - Há relação linear entre as variáveis dependente e independentes

modelo_v2 = lm(CustoInternaçao ~ ., data = dados)
summary(modelo_v2)

# As variáveis que possuem o maior impacto no custo de internação hospitalar são as
# variáveis Idade, TempoInternaçao e GrupoDiagnosticoRefinado.
# Vemos também que a variável Raça não é significativa.
# Vamos removê-la e construir um novo modelo

modelo_v3 = lm(CustoInternaçao ~ Idade + Sexo + TempoInternaçao + GrupoDiagnosticoRefinado, data = dados)
summary(modelo_v3)

# A variável Sexo não possui grande significância estatística.
# Vamos removê-la e construir um novo modelo

modelo_v4 = lm(CustoInternaçao ~ Idade + TempoInternaçao + GrupoDiagnosticoRefinado, data = dados)
summary(modelo_v4)

# Agora temos um modelo com todas as variáveis com alta significância
# Porém, a variavel GrupoDiagnosticoRefinado possui valor t negativo
# Vamos removê-la e construir um novo modelo

modelo_v5 = lm(CustoInternaçao ~ Idade + TempoInternaçao, data = dados)
summary(modelo_v5)

# A remoção da variável GrupoDiagnosticoRefinado aumentou o erro padrão do modelo
# Portanto, vamos descartá-lo e utilizar o melho modelo que encontramos, o modelo_v4

summary(modelo_v4)

# As variáveis que possuem o maior impacto no custo de internação hospitalar são as
# variáveis Idade, TempoInternaçao e GrupoDiagnosticoRefinado.