import 'package:flutter/material.dart';

class LanguagesPage extends StatefulWidget {
  const LanguagesPage({super.key});

  @override
  State<LanguagesPage> createState() => _LanguagesPageState();
}

class _LanguagesPageState extends State<LanguagesPage> {
  // Idioma selecionado por padrão (código 'pt' para Português, conforme a imagem)
  String _selectedLanguage = 'pt';

  final List<Map<String, String>> _languages = [
    {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
    {'code': 'es', 'name': 'Español', 'flag': '🇪🇸'},
    {'code': 'pt', 'name': 'Português', 'flag': '🇧🇷'},
    {'code': 'hi', 'name': 'हिन्दी (Indiano)', 'flag': '🇮🇳'},
    {'code': 'ha', 'name': 'Hausa (Nigeria)', 'flag': '🇳🇬'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Idiomas',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subtítulo
            const Padding(
              padding: EdgeInsets.only(left: 4.0, bottom: 16.0),
              child: Text(
                'Selecione seu idioma preferido',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),

            // Card Principal
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.antiAlias, // Mantém as bordas arredondadas no item selecionado
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: _languages.asMap().entries.map((entry) {
                  int index = entry.key;
                  var lang = entry.value;
                  bool isSelected = _selectedLanguage == lang['code'];

                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            _selectedLanguage = lang['code']!;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                          decoration: BoxDecoration(
                            gradient: isSelected
                                ? const LinearGradient(
                                    colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  )
                                : null,
                          ),
                          child: Row(
                            children: [
                              // Bandeira
                              Text(
                                lang['flag']!,
                                style: const TextStyle(fontSize: 22),
                              ),
                              const SizedBox(width: 14),

                              // Nome do Idioma
                              Expanded(
                                child: Text(
                                  lang['name']!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),

                              // Ícone de Seleção ou Seta
                              Icon(
                                isSelected ? Icons.check : Icons.chevron_right,
                                color: isSelected ? Colors.white : Colors.grey,
                                size: 22,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Linha divisória entre itens (se não for o último)
                      if (index < _languages.length - 1)
                        const Divider(
                          color: Color(0xFF2C2C2C),
                          height: 1,
                          indent: 16,
                          endIndent: 16,
                        ),
                    ],
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 24),

            // Botão Cancelar
            Center(
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}