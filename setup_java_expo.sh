#!/bin/zsh

# Definir variáveis de ambiente
JAVA_VERSION="17"
NODE_VERSION="18.x"
ANDROID_STUDIO_URL="https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2024.2.2.13/android-studio-2024.2.2.13-linux.tar.gz"
ANDROID_STUDIO_DIR="/opt/android-studio"

# Função para verificar se um pacote está instalado
is_installed() {
    dpkg -l | grep -q "$1"
}

# Função para verificar se uma variável de ambiente está configurada
is_env_var_set() {
    grep -q "$1" ~/.zshrc
}

# Função para verificar conexão com a internet
check_connection() {
    ping -c 1 google.com > /dev/null 2>&1
    return $?
}

# Atualizar pacotes
echo "Atualizando pacotes..."
sudo apt update && sudo apt upgrade -y

# Instalar dependências básicas se não estiverem instaladas
echo "Verificando dependências básicas..."
if ! is_installed "curl"; then
    echo "Instalando curl..."
    sudo apt install -y curl
fi
if ! is_installed "wget"; then
    echo "Instalando wget..."
    sudo apt install -y wget
fi
if ! is_installed "git"; then
    echo "Instalando git..."
    sudo apt install -y git
fi
if ! is_installed "unzip"; then
    echo "Instalando unzip..."
    sudo apt install -y unzip
fi
if ! is_installed "zip"; then
    echo "Instalando zip..."
    sudo apt install -y zip
fi
if ! is_installed "build-essential"; then
    echo "Instalando build-essential..."
    sudo apt install -y build-essential
fi
if ! is_installed "software-properties-common"; then
    echo "Instalando software-properties-common..."
    sudo apt install -y software-properties-common
fi

# Adicionar repositório para Java se não estiver configurado
echo "Verificando repositório para Java..."
if ! is_env_var_set "JAVA_HOME"; then
    echo "Adicionando repositório para Java..."
    sudo add-apt-repository -y ppa:openjdk-r/ppa
    sudo apt update
    echo "Configurando variáveis de ambiente para Java..."
    JAVA_HOME="/usr/lib/jvm/java-${JAVA_VERSION}-openjdk-amd64"
    echo "export JAVA_HOME=${JAVA_HOME}" >> ~/.zshrc
    echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.zshrc
    source ~/.zshrc
fi

# Instalar OpenJDK 17 se não estiver instalado
echo "Verificando instalação do OpenJDK..."
if ! is_installed "openjdk-${JAVA_VERSION}-jdk"; then
    echo "Instalando OpenJDK..."
    sudo apt install -y openjdk-${JAVA_VERSION}-jdk
fi

# Verificar instalação do Java
echo "Verificando a instalação do Java..."
java -version
if [[ $? -ne 0 ]]; then
    echo "Erro ao instalar o Java. Verifique os logs acima."
    exit 1
fi

# Instalar Node.js e npm se não estiverem instalados
echo "Verificando Node.js e npm..."
if ! is_installed "nodejs"; then
    echo "Instalando Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION} | sudo -E bash -
    sudo apt install -y nodejs
fi

# Verificar Node.js e npm
echo "Verificando a instalação do Node.js..."
node -v
npm -v

# Instalar Expo CLI se não estiver instalado
echo "Verificando instalação do Expo CLI..."
if ! npm list -g expo-cli > /dev/null 2>&1; then
    echo "Instalando Expo CLI..."
    npm install -g expo-cli
fi

# Verificar instalação do Expo CLI
echo "Verificando a instalação do Expo CLI..."
expo --version

# Instalar Gradle se não estiver instalado
echo "Verificando Gradle..."
if ! is_installed "gradle"; then
    echo "Instalando Gradle..."
    sudo apt install -y gradle
fi

# Verificar configuração do Gradle
echo "Verificando a instalação do Gradle..."
gradle --version

# Baixar e instalar o Android Studio se não estiver instalado
echo "Verificando Android Studio..."
if [ ! -d "$ANDROID_STUDIO_DIR" ]; then
    echo "Verificando conexão com a internet..."
    if check_connection; then
        echo "Conexão ok. Baixando e instalando Android Studio..."
        wget "$ANDROID_STUDIO_URL" -O android-studio.tar.gz

        # Verificar se o download foi bem-sucedido
        if [[ $? -ne 0 ]]; then
            echo "Erro ao baixar o Android Studio. Verifique sua conexão ou tente novamente."
            exit 1
        fi

        # Extrair Android Studio
        echo "Extraindo o Android Studio..."
        sudo tar -xvf android-studio.tar.gz -C /opt
        rm android-studio.tar.gz

        # Verificar se a extração foi bem-sucedida
        if [[ ! -d "$ANDROID_STUDIO_DIR" ]]; then
            echo "Erro na extração do Android Studio. Verifique o diretório /opt."
            exit 1
        fi

        # Adicionar Android Studio ao PATH
        echo 'export PATH=/opt/android-studio/bin:$PATH' >> ~/.zshrc
        source ~/.zshrc

        # Configurar o SDK do Android
        echo "Instalando dependências do Android SDK..."
        yes | /opt/android-studio/bin/studio.sh --install-components
    else
        echo "Erro de conexão com a internet. Não foi possível baixar o Android Studio."
        exit 1
    fi
fi

# Finalizar
echo "Instalação concluída. Certifique-se de reiniciar o terminal."
echo "Use 'java -version', 'gradle --version', e 'expo --version' para verificar."
