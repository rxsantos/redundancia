#!/bin/bash



#Variaveis
operadora[0]="AVA"
operadora[1]="DIRECTCALL"
operadora[2]="IDT_BRASIL"
ava=`asterisk -rx "sip show registry" | grep phonexxx | awk '{print $3}'`
direct=`asterisk -rx "sip show registry" | grep xxx.xxx.xxx.xxx | awk '{print $1}' | cut -d: -f 1`
idt=`asterisk -rx "sip show registry" | grep net2phone | awk '{print $1}' | cut -d. -f 2`
data=`date '+%a, %d %b %Y %H:%M:%S'`
remetente="Asterisk<asterisk@xxx.com.br>"
dest1="rodolpho@xxx.com.br"
dest2="xxx@proxytelecom.com.br"
desc_ava="HOUVE FALHA NO TRONCO SIP AVA "
desc_direct="HOUVE FALHA NO TRONCO SIP DIRECTCALL "
desc_idt="HOUVE FALHA NO TRONCO SIP IDT_BRASIL "
log_ava="/var/log/links/link_ava.log"
log_direct="/var/log/links/link_direct.log"
log_idt="/var/log/links/link_idt.log"
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
                echo "" >> /var/log/links/link_$oper\.log
                echo "" >> /var/log/links/link_$oper\.log
                echo "======================================================" >> /var/log/links/link_$oper\.log
                echo "" >> /var/log/links/link_$oper\.log
                echo "" >> /var/log/links/link_$oper\.log
                echo "TRONCO SIP $op \"NOK\" $data" >> /var/log/links/link_$oper\.log
                echo "" >> /var/log/links/link_$oper\.log
                echo "" >> /var/log/links/link_$oper\.log
                echo "======================================================" >> /var/log/links/link_$oper\.log
                echo "" >> /var/log/links/link_$oper\.log
                echo "" >> /var/log/links/link_$oper\.log
}


#ver_idt ()
#{
        if [[ $idt == "net2phone" ]]; then
                echo "TRONCO SIP IDT_BRASIL \"OK\" $data" >> $log_idt
                status_idt=0
                else
                log idt
                echo "$desc_idt $data" | mail -s "Alerta de Falha - Tronco SIP ${operadora[2]}" -r "$remetente" $dest1,$dest2
                while :; do
                        idt=`asterisk -rx "sip show registry" | grep net2phone | awk '{print $1}' | cut -d. -f 2`
                        if [[ $idt == "net2phone" ]]; then
#                               sleep 10
                                status_idt=1
                                break
                        fi
                        sleep 5
#                       pid_idt=$!
#                       echo "$pid_idt" 
               done
        fi
                if [[ $status_idt == 1 ]]; then
                        echo "TRONCO SIP IDT_BRASIL RESTABELECIDO $data" | mail -s "Tronco Restabelecido - ${operadora[2]}" -r "$remetente" $dest1,$dest2
                        status_idt=0
                fi
#        return $pid_idt
#}



exit
       