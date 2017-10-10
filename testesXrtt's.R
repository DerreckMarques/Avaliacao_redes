library(ggplot2)
library(gridExtra)
library(reshape2)


testes <- c(1:100)

#Gráficos RTT (em ms) x Testes (curvas separadas p/ Min, Media, Max)
ggplot(redes, aes(x=testes, y=rttMin,colour='latência Mínima')) + geom_line()+ 
  geom_line(data=redes, aes(, y=rttMed, colour='latência Média'))+
  geom_line(data=redes, aes(, y=rttMax, colour='latência Máxima')) + 
  ylab("Latência em ms") + 
  xlab("Quantidade de testes")+
  scale_color_manual("Latências",values = c('red', 'blue', 'black'))+
  theme(legend.position="top")

#Gráfico RTT Médio (em ms) x Testes
ggplot(redes, aes(x=testes, y=rttMed)) + geom_line(color='red')+
  ylab("Latência Média") + 
  xlab("Quantidade de testes")

#Gráfico Perda de Pacotes (%) x Testes;
ggplot(redes, aes(x=testes, y=pacotesPer)) + geom_line(color='red')+
  ylab("Pacotes perdidos em %") + 
  xlab("Quantidade de testes")

#Gráfico Perda de Pacotes (%) x RTT Médio (ms);
ggplot(redes, aes(x=pacotesPer, y=rttMed)) + geom_line(color='red')+
  xlab("Pacotes perdidos em %") + 
  ylab("Latência Média")

#Gráfico Velocidade de Download (Mbps) x Testes;
ggplot(redes, aes(x=testes ,y=velDown))+
  geom_line(size=1, color='#B23B3B')+
  xlab("Quantidade de Testes") + 
  ylab("Velocidade de Download")


#Gráfico de Velocidade de Upload (Mbps) x Testes
ggplot(redes, aes(x=testes ,y=velUp))+
  geom_line(size=1, color='#1AF24C')+
  xlab("Quantidade de Testes") + 
  ylab("Velocidade de Upload")


#Gráfico de Velocidade (Up e Down) x Perda de Pacotes (%);
ggplot(redes, aes(x=pacotesPer ,y=velUp, colour='Velocidade Upload'))+
  geom_line(size=1)+
  geom_line(data=redes, aes(, y=velDown, colour='Velocidade Download'), size=1) +
  xlab("Pacotes Perdidos em %") + 
  ylab("Velocidade(Mbps)")+
  scale_color_manual("Velocidade",values = c('red', 'blue'))+
  theme(legend.position="top")


ggplot(redes, aes(x=rttMed ,y=velUp, colour='Velocidade Upload'))+
  geom_line(size=1)+
  geom_line(data=redes, aes(, y=velDown, colour='Velocidade Download'), size=1) +
  xlab("Latência Média") + 
  ylab("Velocidade(Mbps)")+
  scale_color_manual("Velocidade",values = c('red', 'blue'))+
  theme(legend.position="top")


#Gráfico/Tabela contendo as estátisticas globais do conjunto de testes para todas as variáveis
#avaliadas: Média, Mediana, Desvio Padrão, Mínimo, Máximo, Intervalo de confiança e
#Variância;

ic <- t.test(redes$pacotesPer, level=0.95)

ic <- c(ic$conf.int[1], ic$conf.int[2])


pacPer <- c(mean(redes$pacotesPer), median(redes$pacotesPer),sd(redes$pacotesPer),
            min(redes$pacotesPer), max(redes$pacotesPer), ic,var(redes$pacotesPer))

ic <- t.test(redes$rttMin, level=0.95)

ic <- c(ic$conf.int[1], ic$conf.int[2])


rttMin <- c(mean(redes$rttMin), median(redes$rttMin), sd(redes$rttMin), 
            min(redes$rttMin), max(redes$rttMin), ic, var(redes$rttMin))

ic <- t.test(redes$rttMed, level=0.95)

ic <- c(ic$conf.int[1], ic$conf.int[2])

rttMed <- c(mean(redes$rttMed), median(redes$rttMed), sd(redes$rttMed), 
            min(redes$rttMed), max(redes$rttMed), ic, var(redes$rttMed))

ic <- t.test(redes$rttMax, level=0.95)

ic <- c(ic$conf.int[1], ic$conf.int[2])

rttMax <- c(mean(redes$rttMax), median(redes$rttMax), sd(redes$rttMax), 
            min(redes$rttMax), max(redes$rttMax), ic,  var(redes$rttMax))

ic <- t.test(redes$velDown, level=0.95)

ic <- c(ic$conf.int[1], ic$conf.int[2])

velDown <- c(mean(redes$velDown), median(redes$velDown), sd(redes$velDown), 
             min(redes$velDown), max(redes$velDown), ic, var(redes$velDown))

ic <- t.test(redes$velUp, level=0.95)

ic <- c(ic$conf.int[1], ic$conf.int[2])

velUp<- c(mean(redes$velUp), median(redes$velUp), sd(redes$velUp), 
             min(redes$velUp), max(redes$velUp),ic,  var(redes$velUp))

rede <- matrix(c(pacPer, rttMin, rttMed, rttMax, velDown, velUp), ncol = 6)


colnames(rede) <- c("pacotes Perdidos","Latência Mínima","Latência Média","Latência Máxima",
                    "velocidade Download","velocidade de upload")

rownames(rede) <- c('Média', 'Mediana', 'Desvio Padrão', 'Mínimo', 'Máximo',
                    'Intervalo de confiança inf','intervalo de confiaça sup', 'Variância')

View(rede)

write.table(rede, "ScoobyDoo.")

#Média
mean(variável) 
#Variância
var(variável)
#Desvio Padrão
sd(variável)
#Mediana 
median(variável) 


#Gráfico do Valor Contratado x Valor Medido por teste
velConDow <- replace(c(1:100), c(1:100), 5)

velConUp <- replace(c(1:100), c(1:100), 0.5)

ggplot(redes, aes(x=testes ,y=velDown, colour='Velocidade Download nos testes'))+
  geom_line(size=1)+
  geom_line(data=redes, aes(, y=velConDow, colour='Velocidade Download contratado'), size=1) +
  geom_line(data=redes, aes(, y=velUp, colour='Velocidade Upload nos testes'), size=1) +
  geom_line(data=redes, aes(, y=velConUp, colour='Velocidade Upload contratado'), size=1) +
  xlab("Quantidade de Testes") + 
  ylab("Velocidade(Mbps)")+
  scale_color_manual("Velocidade",values = c('red', 'blue', 'green', '#C62ADE'))

  

