import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/todo.dart';
import '../providers/todo_provider.dart';
import '../widgets/glass_card.dart';
import 'add_edit_todo_screen.dart';
import 'statistics_screen.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    );
    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _showAddTodoScreen() async {
    final result = await Navigator.push<Todo>(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AddEditTodoScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );

    if (result != null && mounted) {
      context.read<TodoProvider>().addTodo(result);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF87A96B).withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: Color(0xFF87A96B),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text('Todo added successfully'),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showEditTodoScreen(Todo todo) async {
    final result = await Navigator.push<Todo>(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            AddEditTodoScreen(todo: todo),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );

    if (result != null && mounted) {
      context.read<TodoProvider>().updateTodo(todo.id, result);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF87A96B).withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.edit_outlined,
                  color: Color(0xFF87A96B),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text('Todo updated successfully'),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.tune_outlined, color: Colors.white),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Filter & Sort',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Filter by Status',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Consumer<TodoProvider>(
              builder: (context, provider, child) {
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: FilterOption.values.map((option) {
                    return ChoiceChip(
                      label: Text(option.label),
                      selected: provider.filterOption == option,
                      onSelected: (selected) {
                        provider.setFilterOption(option);
                      },
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Sort by',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Consumer<TodoProvider>(
              builder: (context, provider, child) {
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: SortOption.values.map((option) {
                    return ChoiceChip(
                      label: Text(option.label),
                      selected: provider.sortOption == option,
                      onSelected: (selected) {
                        provider.setSortOption(option);
                      },
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Filter by Category',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Consumer<TodoProvider>(
              builder: (context, provider, child) {
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('All'),
                      selected: provider.selectedCategory == null,
                      onSelected: (selected) {
                        provider.setCategoryFilter(null);
                      },
                    ),
                    ...TodoCategory.values.map((category) {
                      return ChoiceChip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(category.emoji),
                            const SizedBox(width: 4),
                            Text(category.label),
                          ],
                        ),
                        selected: provider.selectedCategory == category,
                        onSelected: (selected) {
                          provider.setCategoryFilter(category);
                        },
                      );
                    }),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

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
            // App Bar with Gradient
            SliverAppBar(
              expandedHeight: 200,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'My Todos ✨',
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
                        top: 50,
                        right: -30,
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -20,
                        left: -20,
                        child: Container(
                          width: 100,
                          height: 100,
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
              actions: [
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.pie_chart_outline),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const StatisticsScreen(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.tune_outlined),
                  ),
                  onPressed: _showFilterOptions,
                ),
                const SizedBox(width: 8),
              ],
            ),

            // Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: GlassCard(
                  borderRadius: 16,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 4,
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search todos...',
                      hintStyle: GoogleFonts.poppins(),
                      prefixIcon: const Icon(Icons.search_outlined),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_outlined),
                              onPressed: () {
                                _searchController.clear();
                                context.read<TodoProvider>().setSearchQuery('');
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    onChanged: (value) {
                      context.read<TodoProvider>().setSearchQuery(value);
                    },
                  ),
                ),
              ),
            ),

            // Stats Summary with Animated Cards
            SliverToBoxAdapter(
              child: Consumer<TodoProvider>(
                builder: (context, provider, child) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _AnimatedStatCard(
                            icon: Icons.list_alt_outlined,
                            label: 'Total',
                            value: provider.totalTodos,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF87A96B), Color(0xFF6E8B7B)],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _AnimatedStatCard(
                            icon: Icons.check_circle_outline,
                            label: 'Done',
                            value: provider.completedTodos,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF9CB99C), Color(0xFF7FA87D)],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _AnimatedStatCard(
                            icon: Icons.pending_outlined,
                            label: 'Active',
                            value: provider.activeTodos,
                            gradient: const LinearGradient(
                              colors: [Color(0xFFB2C9AD), Color(0xFF90A17D)],
                            ),
                          ),
                        ),
                        if (provider.overdueTodos > 0) ...[
                          const SizedBox(width: 8),
                          Expanded(
                            child: _AnimatedStatCard(
                              icon: Icons.warning_amber_outlined,
                              label: 'Overdue',
                              value: provider.overdueTodos,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF708B6F), Color(0xFF5A745A)],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),

            // Todo List
            Consumer<TodoProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final todos = provider.todos;

                if (todos.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.1),
                                  Theme.of(context).colorScheme.secondary
                                      .withValues(alpha: 0.1),
                                ],
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check_circle_outline,
                              size: 80,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'No todos found!',
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap the + button to add a new todo',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final todo = todos[index];
                      return AnimatedTodoCard(
                        todo: todo,
                        index: index,
                        onTap: () => provider.toggleTodo(todo.id),
                        onEdit: () => _showEditTodoScreen(todo),
                        onDelete: () => provider.deleteTodo(todo.id),
                      );
                    }, childCount: todos.length),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: ScaleTransition(
        scale: _fabAnimation,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF87A96B).withValues(alpha: 0.9),
                    const Color(0xFF6E8B7B).withValues(alpha: 0.9),
                  ],
                ),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF87A96B).withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: FloatingActionButton.extended(
                onPressed: _showAddTodoScreen,
                icon: const Icon(Icons.add_outlined),
                label: Text(
                  'Add Todo',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedStatCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final int value;
  final Gradient gradient;

  const _AnimatedStatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.gradient,
  });

  @override
  State<_AnimatedStatCard> createState() => _AnimatedStatCardState();
}

class _AnimatedStatCardState extends State<_AnimatedStatCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    widget.gradient.colors.first.withValues(alpha: 0.8),
                    widget.gradient.colors.last.withValues(alpha: 0.6),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.gradient.colors.first.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(widget.icon, color: Colors.white, size: 24),
                  const SizedBox(height: 4),
                  Text(
                    widget.value.toString(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    widget.label,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedTodoCard extends StatefulWidget {
  final Todo todo;
  final int index;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AnimatedTodoCard({
    super.key,
    required this.todo,
    required this.index,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<AnimatedTodoCard> createState() => _AnimatedTodoCardState();
}

class _AnimatedTodoCardState extends State<AnimatedTodoCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300 + (widget.index * 50)),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getPriorityColor() {
    switch (widget.todo.priority) {
      case TodoPriority.high:
        return const Color(0xFF708B6F);
      case TodoPriority.medium:
        return const Color(0xFF87A96B);
      case TodoPriority.low:
        return const Color(0xFF9CB99C);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Dismissible(
          key: Key(widget.todo.id),
          background: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 24),
            child: const Icon(
              Icons.delete_sweep,
              color: Colors.white,
              size: 32,
            ),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (_) => widget.onDelete(),
          child: GlassCard(
            margin: const EdgeInsets.only(bottom: 12),
            borderRadius: 20,
            padding: EdgeInsets.zero,
            border: Border.all(
              color: _getPriorityColor().withValues(alpha: 0.4),
              width: 2,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onTap,
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Animated Checkbox
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: widget.todo.isCompleted
                                  ? const LinearGradient(
                                      colors: [
                                        Color(0xFF87A96B),
                                        Color(0xFF6E8B7B),
                                      ],
                                    )
                                  : null,
                              border: Border.all(
                                color: widget.todo.isCompleted
                                    ? Colors.transparent
                                    : const Color(
                                        0xFF87A96B,
                                      ).withValues(alpha: 0.5),
                                width: 2,
                              ),
                            ),
                            child: widget.todo.isCompleted
                                ? const Icon(
                                    Icons.check_outlined,
                                    size: 20,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 12),

                          // Title and category
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: _getPriorityColor().withValues(
                                          alpha: 0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        widget.todo.category.emoji,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        widget.todo.title,
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          decoration: widget.todo.isCompleted
                                              ? TextDecoration.lineThrough
                                              : null,
                                          color: widget.todo.isCompleted
                                              ? Colors.grey
                                              : null,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Priority Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  _getPriorityColor(),
                                  _getPriorityColor().withValues(alpha: 0.8),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              widget.todo.priority.label,
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Description
                      if (widget.todo.description != null) ...[
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.only(left: 44),
                          child: Text(
                            widget.todo.description!,
                            style: TextStyle(
                              fontSize: 14,
                              color: widget.todo.isCompleted
                                  ? Colors.grey
                                  : Theme.of(context).colorScheme.onSurface
                                        .withValues(alpha: 0.7),
                              decoration: widget.todo.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ),
                      ],

                      // Due date and actions
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.only(left: 44),
                        child: Row(
                          children: [
                            // Due date with gradient background
                            if (widget.todo.dueDate != null) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: widget.todo.isOverdue
                                        ? [
                                            const Color(0xFF708B6F),
                                            const Color(0xFF5A745A),
                                          ]
                                        : [
                                            const Color(0xFF87A96B),
                                            const Color(0xFF6E8B7B),
                                          ],
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.calendar_today_outlined,
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      DateFormat(
                                        'MMM dd, hh:mm a',
                                      ).format(widget.todo.dueDate!),
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (widget.todo.isOverdue) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF708B6F),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'OVERDUE',
                                    style: GoogleFonts.poppins(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ],

                            const Spacer(),

                            // Action buttons with gradient
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(
                                      0xFF87A96B,
                                    ).withValues(alpha: 0.15),
                                    const Color(
                                      0xFF6E8B7B,
                                    ).withValues(alpha: 0.15),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 18),
                                color: const Color(0xFF87A96B),
                                onPressed: widget.onEdit,
                                padding: const EdgeInsets.all(8),
                                constraints: const BoxConstraints(),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(
                                      0xFF708B6F,
                                    ).withValues(alpha: 0.15),
                                    const Color(
                                      0xFF5A745A,
                                    ).withValues(alpha: 0.15),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  size: 18,
                                ),
                                color: const Color(0xFF708B6F),
                                onPressed: widget.onDelete,
                                padding: const EdgeInsets.all(8),
                                constraints: const BoxConstraints(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
