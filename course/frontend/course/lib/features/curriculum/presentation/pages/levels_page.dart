import 'package:course/features/curriculum/domain/entities/level_entity.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LevelsPage extends StatelessWidget {
  final String language;
  final List<LevelEntity>? levels;

  const LevelsPage({
    super.key,
    required this.language,
    this.levels,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Chọn Cấp Độ (${language.toUpperCase()})'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: levels == null || levels!.isEmpty
          ? const Center(child: Text('Chưa có cấp độ nào hoặc có lỗi xảy ra.'))
          : GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              itemCount: levels!.length,
              itemBuilder: (context, index) {
                final level = levels![index];
                return InkWell(
                  onTap: () {
                    context.push('/levels/$language/lessons/${level.id}', extra: level);
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [colors.primaryContainer, colors.primaryContainer.withValues(alpha: 0.5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: colors.shadow.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            level.code,
                            style: text.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
