import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/todo.dart';
import '../widgets/glass_card.dart';

class AddEditTodoScreen extends StatefulWidget {
  final Todo? todo;

  const AddEditTodoScreen({super.key, this.todo});

  @override
  State<AddEditTodoScreen> createState() => _AddEditTodoScreenState();
}

class _AddEditTodoScreenState extends State<AddEditTodoScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TodoPriority _selectedPriority;
  late TodoCategory _selectedCategory;
  DateTime? _dueDate;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.todo?.description ?? '',
    );
    _selectedPriority = widget.todo?.priority ?? TodoPriority.medium;
    _selectedCategory = widget.todo?.category ?? TodoCategory.other;
    _dueDate = widget.todo?.dueDate;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _saveTodo() {
    if (_formKey.currentState!.validate()) {
      final todo = Todo(
        id: widget.todo?.id ?? DateTime.now().toString(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        createdAt: widget.todo?.createdAt ?? DateTime.now(),
        isCompleted: widget.todo?.isCompleted ?? false,
        priority: _selectedPriority,
        category: _selectedCategory,
        dueDate: _dueDate,
      );

      if (mounted) {
        Navigator.of(context).pop(todo);
      }
    }
  }

  Future<void> _selectDueDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_dueDate ?? DateTime.now()),
      );

      if (time != null && mounted) {
        setState(() {
          _dueDate = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Color _getPriorityColor(TodoPriority priority) {
    switch (priority) {
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
    final isEditing = widget.todo != null;
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
                  isEditing ? 'Edit Todo ✏️' : 'Create New Todo ✨',
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
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilledButton.icon(
                    onPressed: _saveTodo,
                    icon: const Icon(Icons.check_circle_outline, size: 18),
                    label: Text(
                      'SAVE',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            // Form Content
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title Input with Glass Effect
                          GlassCard(
                            borderRadius: 16,
                            padding: const EdgeInsets.all(2),
                            border: Border.all(
                              color: const Color(
                                0xFF87A96B,
                              ).withValues(alpha: 0.4),
                              width: 2,
                            ),
                            child: TextFormField(
                              controller: _titleController,
                              autofocus: !isEditing,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Title *',
                                hintText: 'Enter todo title',
                                prefixIcon: Icon(
                                  Icons.check_circle_outline,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(16),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter a title';
                                }
                                return null;
                              },
                              textInputAction: TextInputAction.next,
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Description Input
                          GlassCard(
                            borderRadius: 16,
                            padding: EdgeInsets.zero,
                            child: TextFormField(
                              controller: _descriptionController,
                              style: const TextStyle(fontSize: 15),
                              decoration: InputDecoration(
                                labelText: 'Description (optional)',
                                hintText: 'Add more details...',
                                prefixIcon: Icon(
                                  Icons.description_outlined,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(16),
                              ),
                              maxLines: 4,
                              textInputAction: TextInputAction.done,
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Priority Section
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Theme.of(context).colorScheme.primary,
                                      Theme.of(context).colorScheme.secondary,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.flag_outlined,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Priority Level',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: TodoPriority.values.map((priority) {
                              final isSelected = _selectedPriority == priority;
                              final color = _getPriorityColor(priority);

                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedPriority = priority;
                                      });
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: isSelected
                                            ? LinearGradient(
                                                colors: [
                                                  color,
                                                  color.withValues(alpha: 0.7),
                                                ],
                                              )
                                            : null,
                                        color: isSelected
                                            ? null
                                            : Theme.of(context).cardColor,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isSelected
                                              ? Colors.transparent
                                              : color.withValues(alpha: 0.3),
                                          width: 2,
                                        ),
                                        boxShadow: isSelected
                                            ? [
                                                BoxShadow(
                                                  color: color.withValues(
                                                    alpha: 0.3,
                                                  ),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ]
                                            : [],
                                      ),
                                      child: Text(
                                        priority.label,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: isSelected
                                              ? Colors.white
                                              : color,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 32),

                          // Category Section
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Theme.of(context).colorScheme.primary,
                                      Theme.of(context).colorScheme.secondary,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.category_outlined,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Category',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: TodoCategory.values.map((category) {
                              final isSelected = _selectedCategory == category;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedCategory = category;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: isSelected
                                        ? const LinearGradient(
                                            colors: [
                                              Color(0xFF87A96B),
                                              Color(0xFF6E8B7B),
                                            ],
                                          )
                                        : null,
                                    color: isSelected
                                        ? null
                                        : Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.transparent
                                          : const Color(
                                              0xFF87A96B,
                                            ).withValues(alpha: 0.3),
                                      width: 2,
                                    ),
                                    boxShadow: isSelected
                                        ? [
                                            const BoxShadow(
                                              color: Color(0xCC87A96B),
                                              blurRadius: 8,
                                              offset: Offset(0, 4),
                                            ),
                                          ]
                                        : [],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        category.emoji,
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        category.label,
                                        style: TextStyle(
                                          color: isSelected
                                              ? Colors.white
                                              : Theme.of(
                                                  context,
                                                ).colorScheme.onSurface,
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 32),

                          // Due Date Section
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Theme.of(context).colorScheme.primary,
                                      Theme.of(context).colorScheme.secondary,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.calendar_today_outlined,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Due Date',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          InkWell(
                            onTap: _selectDueDate,
                            borderRadius: BorderRadius.circular(16),
                            child: GlassCard(
                              borderRadius: 16,
                              padding: const EdgeInsets.all(20),
                              border: Border.all(
                                color: const Color(
                                  0xFF87A96B,
                                ).withValues(alpha: 0.4),
                                width: 2,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      Icons.event_outlined,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      _dueDate == null
                                          ? 'No due date set'
                                          : DateFormat(
                                              'MMMM dd, yyyy - hh:mm a',
                                            ).format(_dueDate!),
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: _dueDate != null
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                        color: _dueDate != null
                                            ? Theme.of(
                                                context,
                                              ).colorScheme.primary
                                            : Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withValues(alpha: 0.5),
                                      ),
                                    ),
                                  ),
                                  if (_dueDate != null)
                                    IconButton(
                                      icon: const Icon(Icons.close_outlined),
                                      onPressed: () {
                                        setState(() {
                                          _dueDate = null;
                                        });
                                      },
                                      color: Colors.red,
                                    ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
