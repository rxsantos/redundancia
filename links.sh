#!/bin/bash
# chkconfig: 2345 91 60
# description: Notificacao de Status de Troncos SIP
#
# processname: notify
# config: /etc/init.d/notify


### BEGIN INIT INFO
# Provides:        notify
# Required-Start:  $local_fs $remote_fs
# Required-Stop:   $local_fs $remote_fs
# Should-Start:    $network $syslog
# Should-Stop:     $network $syslog
# Default-Start:   2 3 4 5
# Default-Stop:    0 1 6
# Short-Description: Status Troncos SIP
# Description:     notify - Status Troncos SIP
### END INIT INFO


#################################
# Script para Notificacao de    #
# Status dos Troncos SIP        #
# Criado em  23.04.18           #
# Por Roberto Xavier            #
# Release 01                    #
# Proxy Telecom Ltda            #
# Fone: 041 3082-7457           #
# www.proxytelecom.com.br       #
#################################


#Variaveis
operadora[0]="AVA\""
operadora[1]="DIRECTCALL\""
operadora[2]="IDT_BRASIL\""
ava=`asterisk -rx "sip show registry" | grep phonexxx | awk '{print $3}'`
direct=`asterisk -rx "sip show registry" |grep xxx.xxx.xxx.xxx | awk '{print $1}' | cut -d: -f 1`
idt=`asterisk -rx "sip show registry" |grep net2phone | awk '{print $1}' | cut -d. -f 2`
data=`date '+%a, %d %b %Y %H:%M:%S'`
remetente="Asterisk<asterisk@xxx.com.br>"
dest1="rodolpho@xxx.com.br"
dest2="xxx@proxytelecom.com.br"
desc_ava="HOUVE FALHA NO TRONCO SIP AVA "
desc_direct="HOUVE FALHA NO TRONCO SIP DIRECTCALL "
desc_idt="HOUVE FALHA NO TRONCO SIP IDT_BRASIL "
log_ava="/var/log/link_ava.log"
log_direct="/var/log/link_direct.log"
log_idt="/var/log/link_idt.log"
#envia="mail -s \"Alerta de Falha Tronco SIP"
#op=("$ava" "$direct" "$idt")


#Funcao para armazenar os logs de status dos Troncos
log() 
{
local oper=$1
        if [[ $oper == "ava" ]];then
                local op=${operadora[0]}
        elif [[ $oper == "direct" ]];then
                local op=${operadora[1]}
        else
                local op=${operadora[2]}
        fi
                echo "" >> /var/log/link_$oper\.log
                echo "" >> /var/log/link_$oper\.log
                echo "======================================================" >> /var/log/link_$oper\.log
                echo "" >> /var/log/link_$oper\.log
                echo "" >> /var/log/link_$oper\.log
                echo "TRONCO SIP $op \"NOK\" $data" >> /var/log/link_$oper\.log
                echo "" >> /var/log/link_$oper\.log
                echo "" >> /var/log/link_$oper\.log
                echo "======================================================" >> /var/log/link_$oper\.log
                echo "" >> /var/log/link_$oper\.log
                echo "" >> /var/log/link_$oper\.log
}


#Funcao para verificar Tronco SIP AVA
ver_ava ()
{
while :; do
        if [[ $ava == "phonexxx" ]];then
                echo "TRONCO SIP AVA \"OK\" $data" >> $log_ava
                sleep=1
                status_ava=0
                else
                log ava
                echo "$desc_ava $data" | mail -s "Alerta de Falha Tronco SIP ${operadora[0]}" -r "$remetente" $dest1,$dest2
                while [[ $ava == "phonexxx" ]]; do
                        sleep=1
                        status_ava=1
                done

                if [[ $status_ava == 1 ]]; then
                        echo "Tronco SIP AVA reestabelecido" | mail -s "Tronco SIP ${operadora[0]} reestabelecido" -r "$remetente" $dest1,$dest2
                        status_ava=0                        
                fi

        fi
done
}

#Funcao para verificar Tronco SIP DIRECTCALL
ver_direct ()
{
while :; do
        if [[ $direct == "xxx.xxx.xxx.xxx" ]];then
                echo "TRONCO SIP DIRECTCALL \"OK\" $data" >> $log_direct
                sleep=1
                status_direct=0
                else
                log direct
                echo "$desc_direct $data" | mail -s "Alerta de Falha Tronco SIP ${operadora[1]}" -r "$remetente" $dest1,$dest2
                while [[ $direct == "xxx.xxx.xxx.xxx" ]]; do
                        sleep=1
                        status_direct=1
                done
                
                if [[ $status_direct == 1 ]]; then     
                        echo "Tronco SIP DIRECTCALL reestabelecido" | mail -s "Tronco SIP ${operadora[1]} reestabelecido" -r "$remetente" $dest1,$dest2
                        status_direct=0
                fi
        fi
done
}

#Funcao para verificar Tronco SIP IDT_BRASIL
ver_idt ()
{
while :; do
        if [[ $idt == "net2phone" ]];then
                echo "TRONCO SIP IDT_BRASIL \"OK\" $data" >> $log_idt
                sleep=1
                status_idt=0
                else
                log idt
                echo "$desc_idt $data" | mail -s "Alerta de Falha Tronco SIP ${operadora[2]}" -r "$remetente" $dest1,$dest2
                while [[ $idt == "net2phone" ]]; do
                        sleep=1
                        status_idt=1
                done

                if [[ $status_idt == 1 ]]; then
                        echo "Tronco SIP IDT_BRASIL reestabelecido" | mail -s "Tronco SIP ${operadora[2]} reestabelecido" -r "$remetente" $dest1,$dest2   
                        status_idt=0                     
                fi


        fi

done
}

#Funcao para envio dos Alertas
alerta() 
{

status_ava=0
status_direct=0
status_idt=0
ver_ava &
ver_direct &
ver_idt &

}

alerta

exit
