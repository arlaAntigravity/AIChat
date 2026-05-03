import 'package:flutter/material.dart';
import '../theme.dart';
import 'ai_settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        backgroundColor: LiquidGlass.bg,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: LiquidGlass.accentLight),
            onPressed: () => _showSnackbar(context, 'Редактировать профиль'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        children: [
          // Header Row
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      LiquidGlass.bubbleMeStart,
                      LiquidGlass.bubbleMeEnd,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(color: LiquidGlass.glassBorder, width: 2),
                ),
                child: const Center(
                  child: Text(
                    'DA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Пользователь',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: LiquidGlass.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '+7 (999) 000-00-00',
                      style: TextStyle(
                        fontSize: 15,
                        color: LiquidGlass.textSecondary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '@username',
                      style: TextStyle(
                        fontSize: 15,
                        color: LiquidGlass.accentLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Sections
          _buildSectionHeader('Основные настройки'),
          _SettingsCard(
            icon: Icons.notifications_active_outlined,
            label: 'Уведомления и звуки',
            onTap: () => _showSnackbar(context, 'Уведомления'),
          ),
          const SizedBox(height: 8),
          _SettingsCard(
            icon: Icons.lock_outline,
            label: 'Конфиденциальность',
            onTap: () => _showSnackbar(context, 'Конфиденциальность'),
          ),
          const SizedBox(height: 8),
          _SettingsCard(
            icon: Icons.data_usage_outlined,
            label: 'Данные и память',
            onTap: () => _showSnackbar(context, 'Данные и память'),
          ),
          const SizedBox(height: 24),

          _buildSectionHeader('AI Настройки'),
          _SettingsCard(
            icon: Icons.auto_awesome_outlined,
            label: 'Настройки помощника',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AiSettingsScreen()),
            ),
          ),
          const SizedBox(height: 8),
          _SettingsCard(
            icon: Icons.chat_bubble_outline,
            label: 'Тон и стиль ответов',
            onTap: () => _showSnackbar(context, 'Тон ответов'),
          ),
          const SizedBox(height: 24),

          _buildSectionHeader('Оформление'),
          _SettingsToggleCard(
            icon: Icons.dark_mode_outlined,
            label: 'Темная тема',
            value: true,
            onChanged: (val) => _showSnackbar(context, 'Переключение темы'),
          ),
          const SizedBox(height: 8),
          _SettingsCard(
            icon: Icons.color_lens_outlined,
            label: 'Цвета чата',
            onTap: () => _showSnackbar(context, 'Цвета чата'),
          ),
          const SizedBox(height: 32),

          // Logout Button
          GestureDetector(
            onTap: () => _showSnackbar(context, 'Выход из аккаунта'),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: LiquidGlass.bgCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: LiquidGlass.glassBorder),
              ),
              child: const Center(
                child: Text(
                  'Выйти',
                  style: TextStyle(
                    color: LiquidGlass.badge,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 48), // Padding for bottom tab bar
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: LiquidGlass.accentLight,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  void _showSnackbar(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(label),
        backgroundColor: LiquidGlass.accent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SettingsCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: LiquidGlass.bgCard,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        splashColor: LiquidGlass.bgElevated,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: LiquidGlass.glassBorder),
          ),
          child: Row(
            children: [
              Icon(icon, size: 24, color: LiquidGlass.textSecondary),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    color: LiquidGlass.textPrimary,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right,
                size: 20,
                color: LiquidGlass.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsToggleCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsToggleCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: LiquidGlass.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: LiquidGlass.glassBorder),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24, color: LiquidGlass.textSecondary),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: LiquidGlass.textPrimary,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: LiquidGlass.accent,
            activeTrackColor: LiquidGlass.accent.withValues(alpha: 0.5),
            inactiveThumbColor: LiquidGlass.textSecondary,
            inactiveTrackColor: LiquidGlass.bgInput,
          ),
        ],
      ),
    );
  }
}
