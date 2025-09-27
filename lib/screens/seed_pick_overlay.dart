import 'package:flutter/material.dart';
import 'package:plant_game/game_state_manager.dart';

/// A simple, stylized dialog that shows up to three plant options for the
/// player to pick from. Each option is a Map<String, dynamic> with keys:
/// - name: String
/// - image: String (asset path)
/// - stats: Map<String, dynamic>
///
/// Call `showSeedPickOverlay` to display it. The caller is responsible for
/// providing the generated options and handling the chosen plant in
/// `onSelected`.

Future<void> showSeedPickOverlay(
  BuildContext context, {
  required List<Map<String, dynamic>> options,
  required void Function(Map<String, dynamic> chosen) onSelected,
}) {
  // Ensure we have exactly 3 visual slots (fill with placeholders if needed)
  final filled = List<Map<String, dynamic>>.from(options);
  while (filled.length < 3) {
    filled.add({
      'name': 'Unknown Seed',
      'image': 'assets/images/flower-seed.png',
      'stats': {'growth': 0, 'yield': 0}
    });
  }

  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (ctx) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: SeedPickDialog(options: filled.take(3).toList(), onSelected: onSelected),
    ),
  );
}

class SeedPickDialog extends StatefulWidget {
  final List<Map<String, dynamic>> options;
  final void Function(Map<String, dynamic>) onSelected;

  const SeedPickDialog({super.key, required this.options, required this.onSelected});

  @override
  State<SeedPickDialog> createState() => _SeedPickDialogState();
}

class _SeedPickDialogState extends State<SeedPickDialog> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final dialogWidth = width > 800 ? 700.0 : width * 0.92;

    return Center(
      child: Container(
        width: dialogWidth,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.98),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 16, offset: Offset(0, 8))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text('Choose a plant', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ),
            const SizedBox(height: 8),
            Text('Pick one of the three plants below to grow in your garden.', style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 14),

            // Options row
            Row(
              children: List.generate(3, (i) {
                final item = widget.options[i];
                final isSelected = i == _selected;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: i == 0 ? 0 : 8, right: i == 2 ? 0 : 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _selected = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.green.shade50 : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isSelected ? Colors.green : Colors.black12, width: isSelected ? 2 : 1),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                image: DecorationImage(image: AssetImage(item['image']), fit: BoxFit.contain),
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(item['name'], textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            // stats
                            _StatsList(stats: item['stats'] as Map<String, dynamic>),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final chosen = widget.options[_selected];
                    widget.onSelected(chosen);
                    GameStateManager().randomShopSeed();
                    GameStateManager().addToInventory(chosen);
                    Navigator.of(context).pop();

                  },
                  child: const Text('Choose'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _StatsList extends StatelessWidget {
  final Map<String, dynamic> stats;
  const _StatsList({required this.stats});

  @override
  Widget build(BuildContext context) {
    final entries = stats.entries.toList();
    return Column(
      children: entries.map((e) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${e.key}: ', style: const TextStyle(fontSize: 12, color: Colors.black54)),
              Text('${e.value}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),
        );
      }).toList(),
    );
  }
}
