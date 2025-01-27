#!/bin/zsh

# Atualizar pacotes
echo "Atualizando pacotes..."
sudo apt update && sudo apt upgrade -y

# Instalar dependências básicas
echo "Instalando dependências básicas..."
sudo apt install -y curl wget git unzip zip build-essential software-properties-common

# Adicionar repositório para Java
echo "Adicionando repositório para Java..."
sudo add-apt-repository -y ppa:openjdk-r/ppa
sudo apt update

# Instalar OpenJDK (versão 17 é recomendada para o Expo)
echo "Instalando OpenJDK..."
sudo apt install -y openjdk-17-jdk

# Configurar variáveis de ambiente para Java
echo "Configurando variáveis de ambiente para Java..."
JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"
if ! grep -q "JAVA_HOME" ~/.zshrc; then
    echo "export JAVA_HOME=${JAVA_HOME}" >> ~/.zshrc
    echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.zshrc
fi

# Atualizar o shell para aplicar as mudanças
echo "Atualizando o shell..."
source ~/.zshrc

# Verificar instalação do Java
echo "Verificando a instalação do Java..."
java -version
if [[ $? -ne 0 ]]; then
    echo "Erro ao instalar o Java. Verifique os logs acima."
    exit 1
fi

# Instalar Node.js e npm (requisitos do Expo)
echo "Instalando Node.js e npm..."
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

# Instalar o Expo CLI globalmente
echo "Instalando Expo CLI..."
npm install -g expo-cli

# Instalar Gradle (para builds nativos no Android)
echo "Instalando Gradle..."
sudo apt install -y gradle

# Verificar configuração do Gradle
echo "Verificando a instalação do Gradle..."
gradle --version

# Instalar Android Studio e dependências
echo "Baixando e instalando Android Studio..."
wget https://r3---sn-p5qs7nly.gvt1.com/edgedl/android/studio/ide-zips/2022.2.1.20/android-studio-2022.2.1.20-linux.tar.gz -O android-studio.tar.gz
sudo tar -xvf android-studio.tar.gz -C /opt
rm android-studio.tar.gz
echo 'export PATH=/opt/android-studio/bin:$PATH' >> ~/.zshrc
source ~/.zshrc

# Configurar o SDK do Android
echo "Instalando dependências do Android SDK..."
yes | /opt/android-studio/bin/studio.sh --install-components

# Finalizar
echo "Instalação concluída. Certifique-se de reiniciar o terminal."
echo "Use 'java -version', 'gradle --version', e 'expo --version' para verificar."
