# Aplicativo de Gestão de Projetos – Aura Projetos e Construções

Este repositório contém o front-end do sistema desenvolvido em Flutter para gerenciar os processos da empresa Aura Projetos e Construções. O sistema foi desenvolvido como proposta de TCC e busca modernizar e centralizar atividades como cadastro de clientes, orçamentos, cronogramas e contratos de obras.

## 🛠 Tecnologias Utilizadas

- Flutter – Framework para desenvolvimento multiplataforma (Web, Android e iOS)
- Dart – Linguagem de programação
- Provider – Gerenciamento de estado
- Flutter Modular – Modularização de rotas e dependências
- http – Consumo da API REST
- MaskTextInputFormatter – Máscaras de input
- flutter_pdfview / printing – Geração e visualização de PDFs (ex: orçamentos)

## 🎯 Objetivo do Projeto

Desenvolver uma aplicação multiplataforma para:

- Centralizar as informações da obra em um só lugar
- Facilitar o acesso remoto por diferentes perfis de usuário (admin, executor e cliente)
- Registrar e acompanhar orçamentos, contratos e cronogramas

## 📲 Funcionalidades

- Tela de login (com opção de autenticação por Google)
- Cadastro e edição de pessoas (cliente, gerente, mestre de obras etc)
- Tela de listagem com filtros dinâmicos por CPF/CNPJ, nome e tipo
- Geração de orçamentos com itens e cálculo automático
- Emissão de PDFs para envio ao cliente

## 🔌 Integração com Backend

O front-end consome uma API REST desenvolvida em Java Spring Boot. Toda a comunicação é feita via JSON.

## 📁 Estrutura do Projeto

```
/lib
 ├── components/        # Componentes reutilizáveis (inputs, botões, etc)
 ├── features/          # Organização por funcionalidades (usuário, orçamento, etc)
 ├── screens/           # Telas principais da aplicação
 ├── widgets/           # Widgets personalizados
 ├── controllers/       # Controllers com lógica das telas
 └── main.dart          # Ponto de entrada da aplicação
```

## 🚀 Como Executar

1. Clone este repositório

```
git clone https://github.com/Flimau/tcc_frontend_auraprojetoseconstrucoes.git
```

2. Instale as dependências

```
flutter pub get
```

3. Execute a aplicação

```
flutter run -d chrome # ou -d android / ios
```

## 📋 Licença

Este projeto é open-source.
