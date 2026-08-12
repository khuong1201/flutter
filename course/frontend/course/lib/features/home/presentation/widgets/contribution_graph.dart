import 'package:course/core/utils/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ContributionGraph extends StatefulWidget {
  final Map<DateTime, int> contributions;
  final int crossAxisCount;

  const ContributionGraph({
    super.key,
    required this.contributions,
    this.crossAxisCount = 7,
  });

  @override
  State<ContributionGraph> createState() => _ContributionGraphState();
}

class _ContributionGraphState extends State<ContributionGraph> {
  late int _selectedYear;
  final ScrollController _scrollController = ScrollController();
  late Map<DateTime, int> _normalizedContributions;

  @override
  void initState() {
    super.initState();
    _selectedYear = DateTime.now().year;
    _normalizeContributions();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrent();
    });
  }

  @override
  void didUpdateWidget(ContributionGraph oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.contributions != widget.contributions) {
      _normalizeContributions();
    }
  }

  void _normalizeContributions() {
    _normalizedContributions = {};
    widget.contributions.forEach((date, count) {
      final normalizedDate = DateTime(date.year, date.month, date.day);
      _normalizedContributions[normalizedDate] = 
          (_normalizedContributions[normalizedDate] ?? 0) + count;
    });
  }

  void _scrollToCurrent() {
    if (!_scrollController.hasClients) return;
    
    final firstDayOfYear = DateTime(_selectedYear, 1, 1);
    final daysToSubtract = firstDayOfYear.weekday - 1;
    final startDate = firstDayOfYear.subtract(Duration(days: daysToSubtract));

    final targetDate = _selectedYear == DateTime.now().year 
        ? DateTime.now() 
        : DateTime(_selectedYear, 12, 31);
        
    final int colIndex = targetDate.difference(startDate).inDays ~/ 7;
    
    const double itemSize = 14.0; 
    const double spacing = 3.0; 
    
    // Attempt to scroll so that the target column is visible
    final double offset = colIndex * (itemSize + spacing);
    final maxScroll = _scrollController.position.maxScrollExtent;
    
    _scrollController.jumpTo(offset > maxScroll ? maxScroll : offset);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Color _getColor(BuildContext context, int count) {
    final colors = Theme.of(context).colorScheme;
    if (count == 0) return colors.surfaceContainerHighest.withValues(alpha: 0.5);
    if (count <= 2) return colors.primary.withValues(alpha: 0.3);
    if (count <= 4) return colors.primary.withValues(alpha: 0.6);
    if (count <= 6) return colors.primary.withValues(alpha: 0.8);
    return colors.primary;
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).languageCode;
    final monthFormat = DateFormat.MMM(locale);
    
    final firstDayOfYear = DateTime(_selectedYear, 1, 1);
    final daysToSubtract = firstDayOfYear.weekday - 1; 
    final startDate = firstDayOfYear.subtract(Duration(days: daysToSubtract));
    
    final lastDayOfYear = DateTime(_selectedYear, 12, 31);
    final totalDays = lastDayOfYear.difference(startDate).inDays + 1;
    final totalColumns = (totalDays / 7).ceil();

    int totalYearContributions = 0;
    _normalizedContributions.forEach((date, count) {
      if (date.year == _selectedYear) {
        totalYearContributions += count;
      }
    });

    final currentYear = DateTime.now().year;
    final years = [currentYear - 4, currentYear - 3, currentYear - 2, currentYear - 1, currentYear];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.l10n.learningActivity,
              style: text.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Text(
                  context.l10n.lessonsCount(totalYearContributions),
                  style: text.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 16),
                DropdownButton<int>(
                  value: _selectedYear,
                  underline: const SizedBox(),
                  icon: const Icon(Icons.arrow_drop_down, size: 20),
                  style: text.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  items: years.map((year) {
                    return DropdownMenuItem<int>(
                      value: year,
                      child: Text(year.toString()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedYear = value;
                      });
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _scrollToCurrent();
                      });
                    }
                  },
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 136,
          child: LayoutBuilder(
            builder: (context, constraints) {
              const double itemSize = 14.0; 
              const double spacing = 3.0;
              
              return Row(
                children: [
                  // Day Labels
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(height: 20), 
                      ...List.generate(7, (index) {
                        final showLabel = index == 1 || index == 3 || index == 5; 
                        final dayDate = startDate.add(Duration(days: index));
                        final dayLabel = DateFormat.E(locale).format(dayDate);
                        
                        return Container(
                          height: itemSize + (index < 6 ? spacing : 0),
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 8, bottom: spacing),
                          child: Text(
                            showLabel ? dayLabel : '',
                            style: text.labelSmall?.copyWith(fontSize: 10),
                          ),
                        );
                      }),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(totalColumns, (colIndex) {
                          final colStartDate = startDate.add(Duration(days: colIndex * 7));
                          bool isNewMonth = false;
                          final prevColStartDate = startDate.add(Duration(days: (colIndex - 1) * 7));
                          if (colStartDate.month != prevColStartDate.month) {
                            // Prevent label clipping at the end by not showing if within the last 2 columns
                            if (colIndex < totalColumns - 2) {
                              isNewMonth = true;
                            }
                          }
                          
                          return Padding(
                            padding: EdgeInsets.only(right: spacing),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20,
                                  width: itemSize,
                                  child: isNewMonth 
                                      ? OverflowBox(
                                          maxWidth: 60,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            monthFormat.format(colStartDate),
                                            style: text.labelSmall?.copyWith(fontSize: 10),
                                            maxLines: 1,
                                          ),
                                        )
                                      : null,
                                ),
                                // Days in this column
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: List.generate(widget.crossAxisCount, (rowIndex) {
                                    final dayOffset = (colIndex * widget.crossAxisCount) + rowIndex;
                                    final date = startDate.add(Duration(days: dayOffset));
                                    
                        
                                    if (date.year != _selectedYear) {
                                      return SizedBox(
                                        width: itemSize,
                                        height: itemSize + (rowIndex < 6 ? spacing : 0),
                                      );
                                    }

                                    final normalizedDate = DateTime(date.year, date.month, date.day);
                                    final int count = _normalizedContributions[normalizedDate] ?? 0;

                                    return Padding(
                                      padding: EdgeInsets.only(bottom: rowIndex < 6 ? spacing : 0),
                                      child: Tooltip(
                                        message: '${DateFormat.yMMMd(locale).format(date)}: ${context.l10n.lessonsCount(count)}',
                                        child: Container(
                                          width: itemSize,
                                          height: itemSize,
                                          decoration: BoxDecoration(
                                            color: _getColor(context, count),
                                            borderRadius: BorderRadius.circular(2),
                                            border: Border.all(
                                              color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.2),
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              context.l10n.less,
              style: text.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 8),
            ...List.generate(5, (index) {
              final val = index * 2;
              return Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  color: _getColor(context, val),
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
              );
            }),
            const SizedBox(width: 4),
            Text(
              context.l10n.more,
              style: text.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
