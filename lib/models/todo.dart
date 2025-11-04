enum TodoPriority {
  low,
  medium,
  high;

  String get label {
    switch (this) {
      case TodoPriority.low:
        return 'Low';
      case TodoPriority.medium:
        return 'Medium';
      case TodoPriority.high:
        return 'High';
    }
  }
}

enum TodoCategory {
  personal,
  work,
  shopping,
  health,
  study,
  other;

  String get label {
    switch (this) {
      case TodoCategory.personal:
        return 'Personal';
      case TodoCategory.work:
        return 'Work';
      case TodoCategory.shopping:
        return 'Shopping';
      case TodoCategory.health:
        return 'Health';
      case TodoCategory.study:
        return 'Study';
      case TodoCategory.other:
        return 'Other';
    }
  }

  String get emoji {
    switch (this) {
      case TodoCategory.personal:
        return '👤';
      case TodoCategory.work:
        return '💼';
      case TodoCategory.shopping:
        return '🛒';
      case TodoCategory.health:
        return '💪';
      case TodoCategory.study:
        return '📚';
      case TodoCategory.other:
        return '📌';
    }
  }
}

class Todo {
  final String id;
  final String title;
  final String? description;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? dueDate;
  final TodoPriority priority;
  final TodoCategory category;
  final List<String> tags;

  Todo({
    required this.id,
    required this.title,
    this.description,
    this.isCompleted = false,
    required this.createdAt,
    this.dueDate,
    this.priority = TodoPriority.medium,
    this.category = TodoCategory.other,
    this.tags = const [],
  });

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? dueDate,
    TodoPriority? priority,
    TodoCategory? category,
    List<String>? tags,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      tags: tags ?? this.tags,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'priority': priority.index,
      'category': category.index,
      'tags': tags,
    };
  }

  // Create from JSON
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      isCompleted: json['isCompleted'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
      priority: TodoPriority.values[json['priority'] as int],
      category: TodoCategory.values[json['category'] as int],
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  // Check if todo is overdue
  bool get isOverdue {
    if (dueDate == null || isCompleted) return false;
    return DateTime.now().isAfter(dueDate!);
  }

  // Check if due today
  bool get isDueToday {
    if (dueDate == null) return false;
    final now = DateTime.now();
    return dueDate!.year == now.year &&
        dueDate!.month == now.month &&
        dueDate!.day == now.day;
  }
}
