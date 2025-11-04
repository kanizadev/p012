import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/todo_provider.dart';
import '../models/todo.dart';
import '../widgets/glass_card.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF0D120D), const Color(0xFF1A1F1A)]
                : [const Color(0xFFE8F0E8), const Color(0xFFD4E4D4)],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            // Gradient App Bar
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Statistics 📊',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [const Color(0xFF2A332A), const Color(0xFF3A453A)]
                          : [const Color(0xFF87A96B), const Color(0xFF6E8B7B)],
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 30,
                        right: -40,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Content
            SliverToBoxAdapter(
              child: Consumer<TodoProvider>(
                builder: (context, provider, child) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Summary Cards Grid
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1.4,
                          children: [
                            _GradientStatCard(
                              icon: Icons.list_alt_outlined,
                              label: 'Total Tasks',
                              value: provider.totalTodos.toString(),
                              gradient: const LinearGradient(
                                colors: [Color(0xFF87A96B), Color(0xFF6E8B7B)],
                              ),
                            ),
                            _GradientStatCard(
                              icon: Icons.check_circle_outline,
                              label: 'Completed',
                              value: provider.completedTodos.toString(),
                              gradient: const LinearGradient(
                                colors: [Color(0xFF9CB99C), Color(0xFF7FA87D)],
                              ),
                            ),
                            _GradientStatCard(
                              icon: Icons.pending_outlined,
                              label: 'Active',
                              value: provider.activeTodos.toString(),
                              gradient: const LinearGradient(
                                colors: [Color(0xFFB2C9AD), Color(0xFF90A17D)],
                              ),
                            ),
                            _GradientStatCard(
                              icon: Icons.warning_amber_outlined,
                              label: 'Overdue',
                              value: provider.overdueTodos.toString(),
                              gradient: const LinearGradient(
                                colors: [Color(0xFF708B6F), Color(0xFF5A745A)],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Completion Rate Chart
                        if (provider.totalTodos > 0) ...[
                          GlassCard(
                            borderRadius: 24,
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF87A96B),
                                            Color(0xFF6E8B7B),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.pie_chart_outline,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Completion Rate',
                                      style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                SizedBox(
                                  height: 220,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: PieChart(
                                          PieChartData(
                                            sectionsSpace: 3,
                                            centerSpaceRadius: 50,
                                            sections: [
                                              PieChartSectionData(
                                                value: provider.completedTodos
                                                    .toDouble(),
                                                title:
                                                    '${((provider.completedTodos / provider.totalTodos) * 100).toStringAsFixed(0)}%',
                                                color: const Color(0xFF87A96B),
                                                radius: 70,
                                                titleStyle: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                                badgeWidget: Container(
                                                  padding: const EdgeInsets.all(
                                                    8,
                                                  ),
                                                  decoration:
                                                      const BoxDecoration(
                                                        color: Color(
                                                          0xFF87A96B,
                                                        ),
                                                        shape: BoxShape.circle,
                                                      ),
                                                  child: const Icon(
                                                    Icons.check_outlined,
                                                    color: Colors.white,
                                                    size: 16,
                                                  ),
                                                ),
                                                badgePositionPercentageOffset:
                                                    1.3,
                                              ),
                                              PieChartSectionData(
                                                value: provider.activeTodos
                                                    .toDouble(),
                                                title:
                                                    '${((provider.activeTodos / provider.totalTodos) * 100).toStringAsFixed(0)}%',
                                                color: const Color(0xFFB2C9AD),
                                                radius: 70,
                                                titleStyle: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                                badgeWidget: Container(
                                                  padding: const EdgeInsets.all(
                                                    8,
                                                  ),
                                                  decoration:
                                                      const BoxDecoration(
                                                        color: Color(
                                                          0xFFB2C9AD,
                                                        ),
                                                        shape: BoxShape.circle,
                                                      ),
                                                  child: const Icon(
                                                    Icons.pending_outlined,
                                                    color: Colors.white,
                                                    size: 16,
                                                  ),
                                                ),
                                                badgePositionPercentageOffset:
                                                    1.3,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 24),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _ChartLegendItem(
                                            color: const Color(0xFF87A96B),
                                            label: 'Completed',
                                            value: provider.completedTodos,
                                          ),
                                          const SizedBox(height: 12),
                                          _ChartLegendItem(
                                            color: const Color(0xFFB2C9AD),
                                            label: 'Active',
                                            value: provider.activeTodos,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],

                        // Category Distribution
                        GlassCard(
                          borderRadius: 24,
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF87A96B),
                                          Color(0xFF6E8B7B),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.category_outlined,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Tasks by Category',
                                    style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              ...TodoCategory.values.map((category) {
                                final count =
                                    provider.getTodosByCategory()[category] ??
                                    0;
                                final percentage = provider.totalTodos > 0
                                    ? (count / provider.totalTodos)
                                    : 0.0;

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(
                                                  8,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: _getCategoryColor(
                                                    category,
                                                  ).withValues(alpha: 0.2),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Text(
                                                  category.emoji,
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Text(
                                                category.label,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  _getCategoryColor(category),
                                                  _getCategoryColor(
                                                    category,
                                                  ).withValues(alpha: 0.7),
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              count.toString(),
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Stack(
                                          children: [
                                            Container(
                                              height: 12,
                                              decoration: BoxDecoration(
                                                color: _getCategoryColor(
                                                  category,
                                                ).withValues(alpha: 0.1),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            FractionallySizedBox(
                                              widthFactor: percentage,
                                              child: Container(
                                                height: 12,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      _getCategoryColor(
                                                        category,
                                                      ),
                                                      _getCategoryColor(
                                                        category,
                                                      ).withValues(alpha: 0.7),
                                                    ],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(TodoCategory category) {
    switch (category) {
      case TodoCategory.personal:
        return const Color(0xFF87A96B);
      case TodoCategory.work:
        return const Color(0xFF6E8B7B);
      case TodoCategory.shopping:
        return const Color(0xFFA8C5A6);
      case TodoCategory.health:
        return const Color(0xFF9CB99C);
      case TodoCategory.study:
        return const Color(0xFF7FA87D);
      case TodoCategory.other:
        return const Color(0xFF90A17D);
    }
  }
}

class _GradientStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Gradient gradient;

  const _GradientStatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartLegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final int value;

  const _ChartLegendItem({
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withValues(alpha: 0.7)],
            ),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            Text(
              value.toString(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
