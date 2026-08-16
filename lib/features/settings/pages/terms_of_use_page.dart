import 'package:flutter/material.dart';

class TermsOfUsePage extends StatelessWidget {
  const TermsOfUsePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Termos de Uso'),
        centerTitle: true,
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: SelectableText(
            '''
TERMOS DE USO

Última atualização: 02/08/2026

Bem-vindo ao Alertx Pro.

Ao utilizar este aplicativo, você concorda com os seguintes termos:

1. Objetivo

O Alertx Pro fornece ferramentas para criação de alertas de preços de ativos financeiros.

2. Responsabilidade

O aplicativo não fornece recomendações de investimento e não garante lucros ou resultados financeiros.

Todas as decisões de investimento são de responsabilidade exclusiva do usuário.

3. Disponibilidade

Nos esforçamos para manter o serviço disponível, porém podem ocorrer interrupções temporárias.

4. Uso adequado

É proibido utilizar o aplicativo para atividades ilegais ou que prejudiquem o funcionamento da plataforma.

5. Alterações

Os Termos de Uso poderão ser atualizados a qualquer momento. A versão mais recente estará sempre disponível no aplicativo.
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