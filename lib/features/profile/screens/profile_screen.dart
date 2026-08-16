import 'package:flutter/material.dart';
// Import ajustado de acordo com a sua estrutura de pastas do projeto
import '../../../routes/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Perfil',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Ação Obter Premium
                },
                icon: const Icon(Icons.auto_awesome, size: 16, color: Colors.blueAccent),
                label: const Text(
                  'Obter Premium',
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1F293D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- SEÇÃO GERAL ---
            const Padding(
              padding: EdgeInsets.only(left: 4.0, bottom: 8.0),
              child: Text(
                'Geral',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
            _buildSectionCard([
              _buildMenuItem(
                icon: Icons.person_outline,
                title: 'Dados pessoais',
                onTap: () {},
              ),
              _buildDivider(),
              _buildMenuItem(
                icon: Icons.language,
                title: 'Idiomas',
                trailingText: 'English',
                onTap: () {},
              ),
              _buildDivider(),
              _buildMenuItem(
                icon: Icons.star_border,
                title: 'Assinaturas',
                onTap: () {},
              ),
              _buildDivider(),
              _buildMenuItem(
                icon: Icons.verified_user_outlined,
                title: 'Política de privacidade',
                onTap: () {},
              ),
              _buildDivider(),
              _buildMenuItem(
                icon: Icons.description_outlined,
                title: 'Termos de uso',
                onTap: () {},
              ),
            ]),

            const SizedBox(height: 20),

            // --- BANNER PREMIUM ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Obter Premium',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Aproveite todos os benefícios do aplicativo',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 36,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // --- SEÇÃO CONTA ---
            const Padding(
              padding: EdgeInsets.only(left: 4.0, bottom: 8.0),
              child: Text(
                'Conta',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
            _buildSectionCard([
              _buildMenuItem(
                icon: Icons.delete_outline,
                title: 'Excluir conta',
                onTap: () {},
              ),
              _buildDivider(),
              _buildMenuItem(
                icon: Icons.logout,
                title: 'Sair',
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.login,
                    (route) => false,
                  );
                },
              ),
            ]),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      color: Color(0xFF2C2C2C),
      height: 1,
      indent: 52,
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? trailingText,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: Colors.white70, size: 22),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(
              trailingText,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        ],
      ),
    );
  }
}