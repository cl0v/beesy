# Beesy
Minimal Flutter App para Questionário Técnico com ACL e Envio de Mensagens Push


## Instalação
$ dart run build_runner build --delete-conflicting-outputs


## Considerações

**Criptografia de Senhas**: As senhas devem ser armazenadas de forma criptografada usando bcrypt ou uma função de hash segura.

- bcrypt utilizado do lado do servidor, já que senhas jamais devem ser salvas no front-end, mesmo com bibliotecas que prometem uma segurança mais refinada como **flutter_secure_storage**

## Escolha das bibliotecas:
- Http Client: dio.
- State Management: provider.
- Navigation and routing: go_router.
- Service Locator: get_it. // If needed
- Persistent storage for secure risk data: flutter_secure_storage.
- Persistent storage for no critical data: shared_preferences.
- Persistent storage for critical data: DO NOT APPLY
FOR THE SCOPE OF THIS APP.

