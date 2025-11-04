import 'package:flutter/foundation.dart';
import '../models/todo.dart';
import '../services/storage_service.dart';

enum SortOption {
  dateCreated,
  dueDate,
  priority,
  title;

  String get label {
    switch (this) {
      case SortOption.dateCreated:
        return 'Date Created';
      case SortOption.dueDate:
        return 'Due Date';
      case SortOption.priority:
        return 'Priority';
      case SortOption.title:
        return 'Title';
    }
  }
}

enum FilterOption {
  all,
  active,
  completed,
  overdue;

  String get label {
    switch (this) {
      case FilterOption.all:
        return 'All';
      case FilterOption.active:
        return 'Active';
      case FilterOption.completed:
        return 'Completed';
      case FilterOption.overdue:
        return 'Overdue';
    }
  }
}

class TodoProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();
  List<Todo> _todos = [];
  String _searchQuery = '';
  SortOption _sortOption = SortOption.dateCreated;
  FilterOption _filterOption = FilterOption.all;
  TodoCategory? _selectedCategory;
  bool _isLoading = false;

  List<Todo> get todos => _getFilteredAndSortedTodos();
  String get searchQuery => _searchQuery;
  SortOption get sortOption => _sortOption;
  FilterOption get filterOption => _filterOption;
  TodoCategory? get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;

  // Statistics
  int get totalTodos => _todos.length;
  int get completedTodos => _todos.where((t) => t.isCompleted).length;
  int get activeTodos => _todos.where((t) => !t.isCompleted).length;
  int get overdueTodos => _todos.where((t) => t.isOverdue).length;

  TodoProvider() {
    loadTodos();
  }

  // Load todos from storage
  Future<void> loadTodos() async {
    _isLoading = true;
    notifyListeners();

    try {
      _todos = await _storageService.loadTodos();
    } catch (e) {
      debugPrint('Error loading todos: $e');
      _todos = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  // Save todos to storage
  Future<void> _saveTodos() async {
    try {
      await _storageService.saveTodos(_todos);
    } catch (e) {
      debugPrint('Error saving todos: $e');
    }
  }

  // Add todo
  Future<void> addTodo(Todo todo) async {
    _todos.insert(0, todo);
    notifyListeners();
    await _saveTodos();
  }

  // Update todo
  Future<void> updateTodo(String id, Todo updatedTodo) async {
    final index = _todos.indexWhere((t) => t.id == id);
    if (index != -1) {
      _todos[index] = updatedTodo;
      notifyListeners();
      await _saveTodos();
    }
  }

  // Toggle todo completion
  Future<void> toggleTodo(String id) async {
    final index = _todos.indexWhere((t) => t.id == id);
    if (index != -1) {
      _todos[index] = _todos[index].copyWith(
        isCompleted: !_todos[index].isCompleted,
      );
      notifyListeners();
      await _saveTodos();
    }
  }

  // Delete todo
  Future<void> deleteTodo(String id) async {
    _todos.removeWhere((t) => t.id == id);
    notifyListeners();
    await _saveTodos();
  }

  // Delete all completed todos
  Future<void> deleteCompleted() async {
    _todos.removeWhere((t) => t.isCompleted);
    notifyListeners();
    await _saveTodos();
  }

  // Set search query
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Set sort option
  void setSortOption(SortOption option) {
    _sortOption = option;
    notifyListeners();
  }

  // Set filter option
  void setFilterOption(FilterOption option) {
    _filterOption = option;
    notifyListeners();
  }

  // Set category filter
  void setCategoryFilter(TodoCategory? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Get filtered and sorted todos
  List<Todo> _getFilteredAndSortedTodos() {
    var filtered = _todos.toList();

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((todo) {
        final titleMatch = todo.title.toLowerCase().contains(_searchQuery.toLowerCase());
        final descMatch = todo.description?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false;
        return titleMatch || descMatch;
      }).toList();
    }

    // Apply status filter
    switch (_filterOption) {
      case FilterOption.active:
        filtered = filtered.where((t) => !t.isCompleted).toList();
        break;
      case FilterOption.completed:
        filtered = filtered.where((t) => t.isCompleted).toList();
        break;
      case FilterOption.overdue:
        filtered = filtered.where((t) => t.isOverdue).toList();
        break;
      case FilterOption.all:
        break;
    }

    // Apply category filter
    if (_selectedCategory != null) {
      filtered = filtered.where((t) => t.category == _selectedCategory).toList();
    }

    // Apply sorting
    switch (_sortOption) {
      case SortOption.dateCreated:
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case SortOption.dueDate:
        filtered.sort((a, b) {
          if (a.dueDate == null && b.dueDate == null) return 0;
          if (a.dueDate == null) return 1;
          if (b.dueDate == null) return -1;
          return a.dueDate!.compareTo(b.dueDate!);
        });
        break;
      case SortOption.priority:
        filtered.sort((a, b) => b.priority.index.compareTo(a.priority.index));
        break;
      case SortOption.title:
        filtered.sort((a, b) => a.title.compareTo(b.title));
        break;
    }

    return filtered;
  }

  // Get todos by category for statistics
  Map<TodoCategory, int> getTodosByCategory() {
    final map = <TodoCategory, int>{};
    for (final category in TodoCategory.values) {
      map[category] = _todos.where((t) => t.category == category).length;
    }
    return map;
  }

  // Get completion rate for last 7 days
  List<int> getWeeklyCompletion() {
    final now = DateTime.now();
    final result = <int>[];

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final count = _todos.where((t) {
        return t.isCompleted &&
            t.createdAt.year == date.year &&
            t.createdAt.month == date.month &&
            t.createdAt.day == date.day;
      }).length;
      result.add(count);
    }

    return result;
  }
}

