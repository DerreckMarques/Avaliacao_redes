#Trabalho Intermediario A2  Avaliacao de Redes WAN Domesticas
#(ADSL/3G/4G/RF)
#Autor: Derreck Marques

import threading
import os
import commands
import csv
from datetime import datetime
import time

class avaRede():
    def __init__(self):

        self.trans = 0
        self.loss = 0
        self.rec = 0
        self.down =  0.000
        self.up = 0.000
        self.mini = 0.000
        self.mean = 0.000
        self.maxi = 0.000
        self.dsP = 0.000
        self.data = ''
        self.tempo = ''
        


#funcao que ira executar o ping e tratar o retorno do comando
def ping(rede):
    cmd = 'ping -c 5 -i 0.2 8.8.8.8 | grep -E "rtt|pack" | cut -d " " -f 1,4,6'

    
    #pegando a saida do comando ping
    saida = commands.getoutput(cmd)
    print(saida)
    if saida != "connect: Network is unreachable":
            
        #tratando a saida dos pacotes
        packet = saida.split('\n')[0]

        packet = packet.split()
        rede.rec = int(packet[0])
        rede.trans = int(packet[1])
        rede.loss = int(packet[2].replace("%", ""))
        

        #print(loss, rec, trans)

        #tratando a saida do rtt
        rtt = saida.split('\n')[1]
        rtt = rtt.split()[1]
        rtt = rtt.split('/')

        rede.mini = float(rtt[0])
        rede.mean = float(rtt[1])
        rede.maxi = float(rtt[2])
        rede.dsP = float(rtt[3])
          
    else:
        print('sem conexao com a internet')

            
#funcao que ira testa a velocidade da rede e tratar o retorno do teste
def speedTest(rede):
            
    speedTest = './speedtest_cli.py --server 5276 | grep -E "Download|Upload"'

       
    saida2 = commands.getoutput(speedTest)
    print(saida2)
    if saida2 != "":
        down = saida2.split('\n')[0]
        up = saida2.split('\n')[1]

        rede.up = float(up.split()[1])
        rede.down = float(down.split()[1])
           
    else:
        print('sem conexao com a internet')



def gravar_dados(rede):

    dados = [rede.rec, rede.trans, rede.loss, rede.mini,
                     rede.mean, rede.maxi, rede.dsP, rede.down, rede.up, rede.data, rede.tempo]
    try:
        with open("Redes_dados.csv", "ab") as fp:
            c = csv.writer(fp, delimiter=',')
            c.writerow(dados)
    except:
        print('erro ao inserir no arquivo')
    finally:
        fp.close
        

def criar_arquivo():
    try:
        with open("Redes_dados.csv", "wb") as fp:
            c = csv.writer(fp, delimiter=',')
            c.writerow(['pacotes recebidos', 'pacotes transmitidos', 'pacotes perdidos em %',
                            'latencia minima', 'latencia media', 'latencia maxima',
                                'desvio padrao da latencia', 'velocidade de download em Mbit/s',
                                'velocidade de upload em Mbit/s', 'data', 'hora'])
    except:
        print('erro ao criar arquivo')

    finally:
        fp.close

        
def pegar_datatime(rede):
    now = datetime.now()
    rede.data = '{}/{}/{}'.format(now.day, now.month, now.year)
    rede.tempo = '{}:{}'.format(now.hour, now.minute)
     


def main():

    print('criando arquivo para guardar os dados...')
    criar_arquivo()
    rede = avaRede()

    
    
    threads = []
    


    try:
        for i in range(100):
            
            th = threading.Thread(target=ping, args = (rede, ))
            th2 = threading.Thread(target=speedTest, args = (rede, ))
            print('executando as threads de ping e teste de velocidade...')
            th.start()
            th2.start()
            
            threads.append(th)
            threads.append(th2)

            for thread in threads:
                thread.join()

            pegar_datatime(rede)
            print('salvando os dados...')

            gravar_dados(rede)
        
            
    except:
        print('Erro: nao foi possivel iniciar as threads')

        

    print('saindo do programa principal')


main()
