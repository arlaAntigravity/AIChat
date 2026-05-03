import 'package:flutter/material.dart';
import '../models.dart';
import '../theme.dart';

class AISuggestionStrip extends StatelessWidget {
  final List<AISuggestion> suggestions;
  final bool isGenerating;
  final ValueChanged<AISuggestion> onSelect;
  final VoidCallback onOpenModal;

  const AISuggestionStrip({
    super.key,
    required this.suggestions,
    required this.isGenerating,
    required this.onSelect,
    required this.onOpenModal,
  });

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty && !isGenerating) return const SizedBox.shrink();

    return Container(
      color: LiquidGlass.bg,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: SizedBox(
        height: 40,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            if (isGenerating) ...[
              _buildLoadingChip(),
            ] else ...[
              ...suggestions.map(
                (s) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _buildChip(s),
                ),
              ),
              _buildMoreButton(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: LiquidGlass.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: LiquidGlass.glassBorder),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: LiquidGlass.accentLight,
            ),
          ),
          SizedBox(width: 8),
          Text(
            'AI думает...',
            style: TextStyle(
              color: LiquidGlass.accentLight,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(AISuggestion s) {
    return GestureDetector(
      onTap: () => onSelect(s),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromRGBO(123, 97, 255, 0.2),
              Color.fromRGBO(167, 139, 250, 0.08),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color.fromRGBO(123, 97, 255, 0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('✨', style: TextStyle(fontSize: 13)),
            const SizedBox(width: 5),
            Text(
              s.short,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: LiquidGlass.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoreButton() {
    return GestureDetector(
      onTap: onOpenModal,
      child: Container(
        width: 38,
        decoration: BoxDecoration(
          color: LiquidGlass.bgCard,
          shape: BoxShape.circle,
          border: Border.all(color: LiquidGlass.glassBorder),
        ),
        child: const Icon(
          Icons.open_in_full_rounded,
          size: 18,
          color: LiquidGlass.accentLight,
        ),
      ),
    );
  }
}
