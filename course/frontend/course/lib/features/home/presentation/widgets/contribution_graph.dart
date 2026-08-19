import 'package:course/features/home/domain/entities/contribution_entity.dart';
import 'package:flutter/material.dart';

class ContributionGraph extends StatelessWidget {
  final List<ContributionEntity> contributions;

  const ContributionGraph({
    super.key,
    required this.contributions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final text = theme.textTheme;

    // Create a simple mockup of the Github contribution graph
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Đóng góp học tập',
          style: text.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '${_getTotalContributions()} đóng góp trong năm nay',
                    style: text.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: _buildHeatmapGrid(colors),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Ít', style: text.bodySmall),
                  const SizedBox(width: 4),
                  _buildCell(color: colors.surfaceContainerHighest),
                  const SizedBox(width: 4),
                  _buildCell(color: colors.primary.withValues(alpha: 0.3)),
                  const SizedBox(width: 4),
                  _buildCell(color: colors.primary.withValues(alpha: 0.6)),
                  const SizedBox(width: 4),
                  _buildCell(color: colors.primary.withValues(alpha: 0.8)),
                  const SizedBox(width: 4),
                  _buildCell(color: colors.primary),
                  const SizedBox(width: 4),
                  Text('Nhiều', style: text.bodySmall),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  int _getTotalContributions() {
    return contributions.fold(0, (sum, item) => sum + item.count);
  }

  Widget _buildHeatmapGrid(ColorScheme colors) {
    // Generate the last 15 weeks of data for the mockup
    final now = DateTime.now();
    final List<Widget> columns = [];

    for (int week = 15; week >= 0; week--) {
      final List<Widget> cells = [];
      for (int day = 0; day < 7; day++) {
        final currentDate = now.subtract(Duration(days: week * 7 + day));
        
        // Find if we have a contribution for this date
        final contribution = contributions.where((c) => 
          c.date.year == currentDate.year && 
          c.date.month == currentDate.month && 
          c.date.day == currentDate.day
        ).firstOrNull;

        final count = contribution?.count ?? 0;
        
        Color cellColor;
        if (count == 0) {
          cellColor = colors.surfaceContainerHighest;
        } else if (count < 2) {
          cellColor = colors.primary.withValues(alpha: 0.3);
        } else if (count < 5) {
          cellColor = colors.primary.withValues(alpha: 0.6);
        } else if (count < 10) {
          cellColor = colors.primary.withValues(alpha: 0.8);
        } else {
          cellColor = colors.primary;
        }

        cells.add(_buildCell(color: cellColor));
        if (day < 6) cells.add(const SizedBox(height: 4));
      }

      columns.add(
        Column(
          children: cells,
        ),
      );
      if (week > 0) columns.add(const SizedBox(width: 4));
    }

    return Row(children: columns);
  }

  Widget _buildCell({required Color color}) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
