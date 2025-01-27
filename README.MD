# Script de Instalação para Ambiente de Desenvolvimento Expo

## O que o Script Faz

- Atualiza os pacotes do sistema.
- Instala dependências básicas como `curl`, `wget`, `git` e outros.
- Adiciona o repositório e instala o OpenJDK 17.
- Configura as variáveis de ambiente para o Java.
- Instala o NVM (Node Version Manager) e o Node.js versão 18.
- Instala o Expo CLI globalmente.
- Instala o Gradle para builds nativos.
- Baixa, instala e configura o Android Studio e seu SDK.

## Pré-Requisitos

- Sistema operacional baseado em Linux.
- Permissões de superusuário para instalar pacotes.

## Verificações Pós-Instalação

Após a execução do script, utilize os comandos abaixo para verificar se as ferramentas foram instaladas corretamente:

## Como Usar

Clone este repositório ou copie o script para um arquivo local:

```bash
git clone git@github.com:Chyper00/setup-java-expo-init.git
cd setup-java-expo-init
```

## Torne o script executável:

```bash
chmod +x setup_java_expo.sh
```

## Execute

```bash
./setup_java_expo.sh
```

## Verificações Pós-Instalação

Após a execução do script, você pode verificar se as ferramentas foram instaladas corretamente:

**Verificar a versão do Java**:

```bash
java -version
```

## Verificar a versão do Gradle

```bash
gradle --version
```
