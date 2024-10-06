# Beesy

Minimal Flutter App para Questionário Técnico com ACL e Envio de Mensagens Push

## Instalação

1. Se você ainda não tiver a CLI do Firebase, acesse o [Guia de instalação](https://firebase.google.com/docs/cli#setup_update_cli)

2. Faça login na sua conta do Firebase:

   ```
       $ firebase login
   ```

3. Instale a CLI do FlutterFire

   ```
       $ dart pub global activate flutterfire_cli
   ```

4. Configure seu projeto para utilizar o Firebase

   ```
       $ flutterfire configure
   ```

5. Siga as instruções para configurar o [certificado APNS do Firebase Cloud Messaging (FCM)](https://firebase.google.com/docs/cloud-messaging/flutter/client#upload_your_apns_authentication_keyrements) para iOS.

6. Acesse o arquivo .env e altere a url para conectar ao servidor:

   ```
       BASE_URL=SEU_ENDPOINT_AQUI #https://api.example.com/v1
   ```

7. Gere os arquivos auxiliares de mapeamento (.g.dart) com o comando:

   ```
       $ dart run build_runner build --delete-conflicting-outputs
   ```

8. Execute o aplicativo:
   ```
       $ flutter run
   ```

<sub>\* Para evitar problemas de versionamento do Flutter instale o [Flutter Version Management (FVM)](https://fvm.app)</sub>

<sub>\* Caso opte por utilizar o servidor que criei para auxiliar no desenvolvimento, acesse "server/" e execute o aplicativo NextJs com "pnpm dev" [saiba mais](https://nextjs.org/docs)</sub>

## Considerações

**Criptografia de Senhas**: **bcrypt** utilizado do lado do servidor, já que senhas jamais devem ser salvas no front-end, mesmo com bibliotecas que prometem uma segurança mais refinada como **flutter_secure_storage**

**Validação de Token JWT**: Alguns endpoins necessitam o envio de Authorization pelo header, para que o back-end possa validar. Apesar de que o front-end pode verificar se o JWT está expirado, não foi feito essa validação nesse aplicativo por questões de praticidade.

**Controle de Acesso**: Algumas rotas estão protegidas por Route Guard para garantir que apenas usuários autorizados tenham acesso a algumas partes do aplicativo.

**Notas**: Algumas funcionalidades que não foram implementadas para esse exemplo:

- Validação do JWT pelo lado do cliente;
- Redirecionamento para tela de login em caso de statusCode 401;
- Tratamento de permissões não concedidas;

**State Management**: Sei que é um assunto sensível para algumas fases do recrutamento, porém optei por usar a gerência de estado padrão do Flutter (setState) pois em nenhum momento me pareceu necessário uma abordagem mais sofisticada para tal. Mas vale ressaltar que tenho domínio nas principais bibliotecas (BLoC, Provider, Riverpod, GetX, MobX, etc).


## Funcionalidades
- **Autenticação via Email/Senha**: Permite que os usuários façam login e cadastro usando email e senha.
- **ACL (Controle de Acesso por Nível de Usuário)**: O aplicativo implementa um sistema de controle de acesso que define permissões de acordo com o papel do usuário (usuário padrão ou administrador). Apenas administradores podem acessar funções avançadas, como o envio de notificações.
- **Envio de Notificações Push**: Utilizando Firebase Cloud Messaging (FCM), os administradores podem enviar notificações personalizadas aos usuários.
- **Recebimento de Notificações em Background**: As notificações são recebidas mesmo quando o aplicativo está em segundo plano ou fechado.
- **Mudar Senha**: Os usuários podem atualizar sua senha de forma segura.
- **Logout Seguro**: Possibilidade de logout, invalidando o token JWT do usuário.
- **Segurança e Criptografia**: O back-end implementa criptografia de senhas com **bcrypt** e autenticação baseada em **JWT**.
- **Gerenciamento de Estado Simples**: Implementado com o setState do Flutter para manter o aplicativo leve e simples.

## Escolha das bibliotecas

- Http Client: dio.
- State Management: default.
- Navigation and routing: go_router.
- Service Locator: get_it.
- Persistent storage for secure risk data: flutter_secure_storage.
- Persistent storage for no critical data: shared_preferences.
- Persistent storage for critical data: DO NOT APPLY FOR THE SCOPE OF THIS APP.
- Push Notification: firebase_messaging.
- Mocks de Testes Unitários: mockito.

## Estrutura de Pastas

```md
lib/
├── main.dart # Arquivo principal do app
├── core/
│ ├── services/
│ │ └── firebase_service.dart # Configuração do Firebase
│ └── utils/
│ └── constants.dart # Constantes do app
├── modules/
│ ├── auth/
│ │ ├── data/
│ │ │ ├── datasource.dart # Data source para autenticação
│ │ │ └── model.dart # Modelos de autenticação (User, etc.)
│ │ ├── ui/
│ │ │ ├── login_page.dart # Página de Login
│ │ │ └── register_page.dart # Página de Registro
│ │ └── auth_controller.dart # Lógica de autenticação e controle de estado
│ ├── home/
│ │ └── home_page.dart # Página inicial (após login)
└── routes/
└── app_router.dart # Configuração de rotas com go_router
```

#### Explicação:

    •	lib/main.dart: O arquivo principal que inicia o aplicativo.
    •	core/services: Serviços essenciais, como a configuração do Firebase.
    •	core/utils: Contém utilitários e constantes globais do aplicativo.
    •	modules/auth: Pasta responsável por tudo relacionado à autenticação, incluindo a camada de dados (datasource, models) e a UI (páginas de login e registro).
    •	modules/home: Página inicial após o login.
    •	modules/notification: Inclui lógica de envio de notificações e interface de usuário para essa funcionalidade.
    •	routes/app_router.dart: Gerenciamento de rotas usando go_router.

## Referências

- [Firebase](https://firebase.google.com/docs/cli#setup_update_cli)
- [Firebase Cloud Messaging](https://firebase.google.com/docs/cloud-messaging)
- [Serialização JSON](https://pub.dev/packages/json_serializable)
- [Flutter Version Management (FVM)](https://fvm.app)
- [Flutter](https://flutter.dev)
- [Bibliotecas e Plugins](https://pub.dev)

### Versões utilizadas
JDK 17 | Flutter 3.24.3 | Dart 3.5.3
