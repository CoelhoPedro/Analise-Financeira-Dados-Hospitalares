library(dplyr)
library(sqldf)

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

sqldf("select distinct Raça from dados")

# Existem 6 raças no dataset
# Pergunta 2:
# Qual a idade média dos pacientes?

sqldf("select avg(Idade) from dados")

# A média de idade é de 5 anos
# Pergunta 3:
# Qual a moda da idade dos pacientes?

sqldf("select Idade, count(*) from dados group by Idade")

# A idade que mais aparece é 0, com 306 registros
# Pergunta 4:
# Qual a variância da coluna idade?

sqldf("select variance(Idade) from dados")

# A variância da idade é 48,34
# Pergunta 5:
# Qual o gasto total com internações hospitalares por idade?

sqldf("select Idade, sum(CustoInternaçao) as Custo from dados group by Idade")

# Pergunta 6
# Qual idade gera o maior gasto total com internações hospitalares?

sqldf("select Idade, max(Custo) from (select Idade, sum(CustoInternaçao) as Custo from dados group by Idade)")

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
sqldf("select avg(CustoInternaçao) as MediaCusto from dados where Idade > 10")

# A média de gasto com internações para pacientes acima de 10 anos é 3.213,66
# Pergunta 10
# Considerando o item anterior, qual idade tem média de gastos superior a 3000?

sqldf("Select Idade, MediaCusto from (select Idade, avg(CustoInternaçao) as MediaCusto from dados where Idade>10 group by Idade) where MediaCusto > 3000")