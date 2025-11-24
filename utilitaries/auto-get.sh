#!/bin/bash

PROJECT_DIR="./musehn-iserj"
PROJECT_URL="https://github.com/renatolois/museuhn-iserj"

if [ -e "$PROJECT_DIR" ]; then
  ALREADY_EXISTS=true
else
  ALREADY_EXISTS=false
fi

PACKAGES="php nano unzip python openssl git"

run_project() {
  echo "Iniciando o projeto..."

  cd "$PROJECT_DIR"

  echo "+---------------------------+"
  echo "|  1 - Rodar em http        |"
  echo "|  2 - Rodar em https       |"
  echo "+---------------------------+"
  echo "Atenção: HTTP funciona para debug local, mas navegadores bloqueiam o uso da câmera por outros dispositivos que acessarem, por questões de segurança."
  read -p "escolha a opção (http é o recomendado para uso local): " server_type
  
  if [ "$server_type" -eq 1 ]; then
    protocol="http"
    port=8000
  elif [ "$server_type" -eq 2 ]; then
    port=8443
    protocol="https"
  else 
    echo "valor inválido. saindo do script..."
    exit 1
  fi

  read -p "Digite a porta para o servidor, deixe em branco para usar a porta padrão [padrão: $port]: " input_port
  if [ -z "$input_port" ]; then
    echo "usando porta padrão"
  else
    if ! [[ "$input_port" =~ ^[0-9]+$ ]]; then
      echo "Erro: digite um número válido."
      exit 1
    fi
    if [ "$input_port" -le 1000 ] || [ "$input_port" -gt 65535 ]; then
      echo "Erro: escolha uma porta acima de 1000 (para usar sem permissão root) e abaixo de 65536."
      exit 1
    fi

    port=$input_port
  fi


  if [ "$server_type" -eq 1 ]; then
    php -S 0.0.0.0:$port
  else
    echo "$port" | python3 ./utilitaries/https_server.py
  fi

  echo ""
  echo "============================================="
  echo " Acesse no navegador: $protocol://127.0.0.1:$port"
  echo "============================================="
  echo ""
}

get_project() {
  echo "Baixando o código do projeto..."

  rm -rf "$PROJECT_DIR"
  git clone "$PROJECT_URL".git

  echo "Projeto baixado em ./museuhn-iserj"
}

remove_project() {
  if [ ! -e "$PROJECT_DIR" ]; then
    echo "O projeto não existe. Nada para remover."
    return
  fi

  echo "Tem certeza que deseja remover o projeto? (y/n)"
  read confirm

  if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
    rm -rf "$PROJECT_DIR"
    echo "Projeto removido."
  else
    echo "Operação cancelada."
  fi
}

check_and_install_dependencies() {
  echo "verifying dependencies"
  for pkg in $PACKAGES; do
    if dpkg -s "$pkg" >/dev/null 2>&1; then
      echo "[OK] $pkg is already installed. Skipping"
    else
      echo "[..] Installing $pkg..."
      pkg install -y "$pkg"
    fi
  done
}

check_and_install_dependencies
clear

echo "----------------------------------------------"
echo "|                                            | "
echo "|                1 1              1    1     |"
echo "|     1    1     0 1       0      0    1     |"
echo "|     1    0     1 0       0      1          |"
echo "|   1 1    1     0 1       1    0 0  1       |"
echo "|   0      1   ____________1    1 1  1   0   |"
echo "|   1 1    1  /\           \    0 0  1   1   |"
echo "|   1 0    1 /  \      O    \   0    0   1   |"
echo "|   1 0     / O  \           \  1    1   1   |"
echo "|     0    /      \___________\ 1    1   0   |"
echo "|     1    \      /  O     O /  1    1   0   |"
echo "|     0     \ O  /          /   0    1   1   |"
echo "|  1  0      \  /  O    O  /    0    1   0   |"
echo "|  1         1\/__________/1   11    0   1   |"
echo "|  0         0     0       0   01    0   0   |"
echo "|  0         1     0  1    0    0    0       |"
echo "|            1        1              0       |"
echo "|                                            |"
echo "----------------------------------------------"

echo "+---------------------------+"
echo "|                           |"
echo "|       O que fazer?        |"
echo "|                           |"
echo "|  1 - Rodar a aplicação    |"
echo "|  2 - Baixar o projeto     |"
echo "|  3 - Remover o projeto    |"
echo "|                           |"
echo "+---------------------------+"

read -p "Escolha uma opção (1/2/3): " option

if [ "$option" -eq 1 ]; then
  if [ "$ALREADY_EXISTS" = false ]; then
    echo "O projeto não está baixado."
    read -p "Deseja baixar agora? (y/n): " choose
    if [ "$choose" = "y" ] || [ "$choose" = "Y" ]; then
      get_project
      run_project
    else
      echo "Operação cancelada."
    fi
  else
    run_project
  fi
elif [ "$option" -eq 2 ]; then
  get_project

elif [ "$option" -eq 3 ]; then
  remove_project

else
  echo "Opção inválida."
fi

