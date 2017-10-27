#!/bin/bash
#
# versao 0.1
#
# INFORMAÇÕES
#   copia_email.sh         
#
# DESCRICAO
#    Lista e copia e-mails de maildir
#
# NOTA
#   Testado e desenvolvido em CentOS 7
#   
#  DESENVOLVIDO_POR
#  Valdenir Luíz Mezadri Junior			- valdenirmezadri@live.com
#
#  MODIFICADO_POR		(DD/MM/YYYY)
#  Valdenir Luíz Mezadri Junior	28/09/2017	- Criado script
#  Valdenir Luíz Mezadri Junior 29/09/2017      - Finalizado testes 
#
#########################################################################################################################################
if [ $# -lt 1 ]; then
  echo " "
  echo "Faltam argumentos. -h para ajuda"
  echo " "
  exit 1
fi
if [[ "${1}" != +(-h|-f|-a|-t) ]] ; then
  echo " "
  echo "O primeiro argumento é uma função. -h para ajuda"
  echo " "
  exit 1
fi

while getopts f:t:a:T:p:c: option
do
 case "${option}"
 in
 f) FROM=${OPTARG};;
 t) TO=${OPTARG};;
 a) ALL=${OPTARG};;
 
 T) CAIXA=${OPTARG};;
 p) RAIZ=${OPTARG};; 
 c) COPIA=${OPTARG};;
 esac
done 2> /dev/null
if [ "$RAIZ"A = A ]; then 
  DIRETORIO="/home/vmail/"
  else
  DIRETORIO="$RAIZ"
fi

DOMINIO=`echo $CAIXA |cut -d"@" -f2`
EMAIL=`echo $CAIXA |cut -d"@" -f1`
DIRETORIOD+="$DIRETORIO$DOMINIO"
DIRETORIOU+="$DIRETORIOD/$EMAIL"

if [[ $CAIXA =~ ^.*@.*\.[a-z].. ]]; then
  DIRETORIOX="$DIRETORIOU"
  elif [[ "${CAIXA}" == ^@.*? ]]; then
    DIRETORIOX="$DIRETORIOD"
  else
  DIRETORIOX="$DIRETORIO"
fi

if [ $1 = "-f"  ] && [ "$FROM"x != x  ]; then
echo "----------------------------------------------------------"
echo "Procurando e-mails no diretório $DIRETORIOX"
echo "----------------------------------------------------------"
  if [[ $FROM =~ ^.*@.*\.[a-z].. ]]; then
    echo -e "\nProcurando e-mails do remetente $FROM " 
    find $DIRETORIOX/* -print0  ! -name '*dovecot.index.cache'  | while IFS= read -r -d $'\0' line ; do
    cat "$line" 2> /dev/null | egrep "^From:.*$FROM.*|From:.*\n[^To:].*$FROM.*"
      if [ $? -eq 0 ] && [ "$COPIA"A != A ]; then
        echo "----------------------------------------------------------"  
        echo "E-mail De: $FROM copiado para o diretório $COPIA" 
        cp -p "$line" $COPIA
        echo "----------------------------------------------------------"
      fi
    done
   exit 1
  else
    echo -e "\nDigite um endereço de e-mail válido\n"
  fi
fi

if [ $1 = "-t"  ] && [ "$TO"x != x  ]; then
echo "----------------------------------------------------------"
echo "Procurando e-mails no diretório $DIRETORIOX"
echo "----------------------------------------------------------"
  if [[ $TO =~ ^.*@.*\.[a-z].. ]]; then
    echo -e "\nProcurando e-mails do destinatário $TO\n"
    find $DIRETORIOX/* -print0 ! -name '*dovecot.index.cache' | while IFS= read -r -d $'\0' line ; do
    cat "$line" 2> /dev/null | egrep "^To:.*$TO.*|To:.*\n[^From:].*$TO.*"
      if [ $? -eq 0 ] && [ "$COPIA"A != A ]; then
        echo "----------------------------------------------------------"  
        echo "E-mail para: $TO copiado para o diretório $COPIA" 
        cp -p "$line" $COPIA
        echo "----------------------------------------------------------"
       fi
    done
   exit 1
  else
    echo -e "\nDigite um endereço de e-mail válido\n"
  fi
fi

if [ $1 = "-a"  ] && [ "$ALL"x != x  ]; then
echo "----------------------------------------------------------"
echo "Procurando e-mails no diretório $DIRETORIOX"
echo "----------------------------------------------------------"
  if [[ $ALL =~ ^.*@.*\.[a-z].. ]]; then
    echo -e "\nProcurando e-mails que contenham o e-mail $ALL\n"
    find $DIRETORIOX/* -print0 ! -name '*dovecot.index.cache' | while IFS= read -r -d $'\0' line ; do
    cat "$line" 2> /dev/null | egrep ".*$ALL.*"
      if [ $? -eq 0 ] && [ "$COPIA"A != A ]; then
        echo "----------------------------------------------------------"  
        echo "E-mail onde consta: $ALL copiado para o diretório $COPIA" 
        cp -p "$line" $COPIA
        echo "----------------------------------------------------------"
       fi
    done
   exit 1
  else
    echo -e "\nDigite um endereço de e-mail válido\n"
  fi
fi



if [ $1 = "-h" ]; then
  
  echo -e "\tINFORMAÇÕES:\n\tcopia_email.sh\t\tLista e copia e-mails de maildir"
  echo -e "\n\tMODO DE USAR:\t\tcopia_email.sh + função [-f -t -a -h] + Outras opções: [-p -T -c]"
  echo -e "\n\tFUNÇÃO:\n"
  echo -e "\t-h\t\t\tMostrar ajuda\n\t-f\t\t\tFrom:\n\t-t\t\t\tTo:\n\t-a\t\t\tFromOrTo:"
  echo -e "\n\tOUTRAS OPÇÕES:"
  echo -e "\n\t-T\t\t\tProcurar na caixa usuario@dominio.com.br ou em todos os e-mails @dominio.com.br, se não informado"
  echo -e "\t-p\t\t\tDiretório onde se encontra os e-mails, o padrão é /home/vmail/ "
  echo -e "\t-c\t\t\tCopiar e-mails encontrados para um diretório, o padrão é apenas listar na tela os e-mails"  
  echo -e "\n\tExemplos:"
  echo -e "\t./copia_email.sh -f remetente@hotmail.com -T conta_local@empresa.com.br -c /copia/para/diretorio/"
  echo -e "\t./copia_email.sh -f remetente@hotmail.com -T conta_local@empresa.com.br -c /copia/para/diretorio/"  
  echo -e "\t./copia_email.sh -f remetente@hotmail.com -T @empresa.com.br -p /diretorio/contas/email/ -c /copia/para/diretorio/"


  
exit 1
fi
