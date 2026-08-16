import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Política de Privacidade'),
        centerTitle: true,
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: SelectableText(
            '''
POLÍTICA DE PRIVACIDADE

Última atualização: 02/08/2026

Esta Política de Privacidade explica como o Alertx Pro coleta, utiliza e protege as informações dos usuários.

1. Informações coletadas

• Dados da conta.
• Preferências do aplicativo.
• Configurações de alertas.

2. Como utilizamos os dados

Os dados são utilizados apenas para fornecer os serviços do aplicativo, como criação de alertas, notificações e autenticação.

3. Compartilhamento

Não vendemos informações pessoais a terceiros.

4. Segurança

Adotamos medidas para proteger as informações armazenadas.

5. Contato

Em caso de dúvidas, entre em contato através dos canais oficiais do aplicativo.
''',
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
            ),
          ),
        ),
      ),
    );
  }
}