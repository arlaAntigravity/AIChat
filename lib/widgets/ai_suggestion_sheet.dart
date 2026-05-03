import 'package:flutter/material.dart';
import '../models.dart';
import '../theme.dart';

void showAISuggestionSheet({
  required BuildContext context,
  required List<AISuggestion> suggestions,
  required bool isGenerating,
  required ValueChanged<AISuggestion> onSelect,
  required VoidCallback onRegenerate,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _AISuggestionSheet(
      suggestions: suggestions,
      isGenerating: isGenerating,
      onSelect: (s) {
        onSelect(s);
        Navigator.pop(ctx);
      },
      onRegenerate: onRegenerate,
    ),
  );
}

class _AISuggestionSheet extends StatelessWidget {
  final List<AISuggestion> suggestions;
  final bool isGenerating;
  final ValueChanged<AISuggestion> onSelect;
  final VoidCallback onRegenerate;

  const _AISuggestionSheet({
    required this.suggestions,
    required this.isGenerating,
    required this.onSelect,
    required this.onRegenerate,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      maxChildSize: 0.9,
      minChildSize: 0.3,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: LiquidGlass.glassBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          border: Border(
            top: BorderSide(color: LiquidGlass.glassBorder),
            left: BorderSide(color: LiquidGlass.glassBorder),
            right: BorderSide(color: LiquidGlass.glassBorder),
          ),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: LiquidGlass.textMuted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [LiquidGlass.accent, LiquidGlass.accentLight],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Предложения AI',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: LiquidGlass.textPrimary,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: LiquidGlass.bgCard,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 18,
                        color: LiquidGlass.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),
            Divider(height: 1, color: LiquidGlass.separator),

            // Content
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  if (isGenerating)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Column(
                        children: [
                          CircularProgressIndicator(color: LiquidGlass.accent),
                          SizedBox(height: 16),
                          Text(
                            'Генерирую варианты...',
                            style: TextStyle(
                              color: LiquidGlass.textSecondary,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ...suggestions.asMap().entries.map(
                      (entry) => _buildCard(entry.key, entry.value),
                    ),

                  const SizedBox(height: 8),

                  // Regenerate button
                  GestureDetector(
                    onTap: isGenerating ? null : onRegenerate,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isGenerating
                              ? [Colors.grey.shade800, Colors.grey.shade700]
                              : const [
                                  LiquidGlass.accent,
                                  LiquidGlass.accentLight,
                                ],
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.refresh, color: Colors.white, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Сгенерировать еще',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(int index, AISuggestion s) {
    return GestureDetector(
      onTap: () => onSelect(s),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: LiquidGlass.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: LiquidGlass.glassBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ВАРИАНТ ${index + 1}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: LiquidGlass.accentLight,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              s.full,
              style: const TextStyle(
                color: LiquidGlass.textPrimary,
                fontSize: 16,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.arrow_circle_right,
                  size: 20,
                  color: LiquidGlass.accent,
                ),
                const SizedBox(width: 6),
                Text(
                  'Использовать',
                  style: TextStyle(
                    fontSize: 14,
                    color: LiquidGlass.accent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
