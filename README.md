# 🌿 Advanced Todo List App

<div align="center">

### A stunning glassmorphism Todo app with sage green aesthetics

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat-square&logo=dart&logoColor=white)
![Material Design](https://img.shields.io/badge/Material%20Design%203-757575?style=flat-square&logo=material-design&logoColor=white)

**Glassmorphism Design** • **Sage Green Theme** • **Minimal Icons** • **Smooth Animations**

</div>

---

## ✨ Features

### 🎨 **Beautiful Glassmorphism UI**
- 💎 Frosted glass effects with backdrop blur on all cards
- 🌿 Calming sage green monochromatic color palette
- 📝 Cute Poppins font for friendly typography
- 📐 Minimal outlined icons throughout
- 🌊 Stunning gradient backgrounds
- 🌓 Gorgeous dark mode with glass effects

### 📋 **Smart Todo Management**
- ✅ Create, edit, and delete todos with rich details
- 🎯 **Priority Levels**: High, Medium, Low with color-coded badges
- 🏷️ **6 Categories** with emojis: Personal 👤, Work 💼, Shopping 🛒, Health 💪, Study 📚, Other 📌
- 📅 **Due Dates** with date and time picker
- ⚠️ **Overdue Alerts** with visual indicators
- ✏️ **Descriptions** for detailed notes

### 🔍 **Advanced Search & Filters**
- 🔎 Real-time search by title or description
- 🎛️ Filter by: All / Active / Completed / Overdue
- 🗂️ Filter by category
- 🔄 Sort by: Date, Due Date, Priority, or Title

### 📊 **Analytics Dashboard**
- 📈 Summary cards (Total, Completed, Active, Overdue)
- 🥧 Beautiful pie chart showing completion rate
- 📊 Category distribution with gradient progress bars
- 💾 All data persists automatically with local storage

### 🎭 **Delightful UX**
- 🎬 Smooth fade, slide, and scale animations
- 👆 Swipe-to-delete gesture
- 🎯 Interactive glass cards with touch feedback
- 🎪 Expandable gradient app bar
- ⚡ Fast and responsive on all platforms

---

## 🚀 Quick Start

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/advanced-todo-app.git

# Navigate to project
cd advanced-todo-app

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Requirements
- Flutter SDK 3.9.2+
- Dart SDK 3.9.2+
- Any platform: iOS, Android, Web, Windows, macOS, or Linux

---

## 📱 Supported Platforms

| Platform | Status |
|----------|:------:|
| Android  | ✅ |
| iOS      | ✅ |
| Web      | ✅ |
| Windows  | ✅ |
| macOS    | ✅ |
| Linux    | ✅ |

---

## 🎨 Design Highlights

### Sage Green Color Palette
```
Primary:   #87A96B (Medium Sage)
Secondary: #9CB99C (Light Sage)
Dark:      #708B6F (Dark Sage)
Pale:      #B2C9AD (Pale Sage)
```

### Glassmorphism Effect
- **Backdrop blur**: 10px sigma
- **Transparency**: Adaptive (70% light, 10% dark)
- **White borders**: Semi-transparent elegant borders
- **Soft shadows**: Colored glows matching the content

### Typography
- **Font**: Poppins (rounded, friendly, modern)
- **Weights**: Regular, Medium, SemiBold, Bold

---

## 📦 Tech Stack

- **Flutter** - Cross-platform UI framework
- **Provider** - State management
- **SharedPreferences** - Local data persistence
- **Google Fonts** - Poppins typography
- **FL Chart** - Beautiful charts and graphs
- **Intl** - Date and time formatting

---

## 📂 Project Structure

```
lib/
├── main.dart                          # App entry & theme
├── models/
│   └── todo.dart                      # Todo data model
├── providers/
│   ├── todo_provider.dart             # Todo state management
│   └── theme_provider.dart            # Theme state
├── services/
│   └── storage_service.dart           # Local storage
├── widgets/
│   └── glass_card.dart                # Glassmorphism widget
└── screens/
    ├── todo_list_screen.dart          # Main screen
    ├── add_edit_todo_screen.dart      # Add/Edit form
    └── statistics_screen.dart         # Analytics
```

---

## 🎯 Usage

### Creating a Todo
1. Tap the **✨ Add Todo** button
2. Fill in title, description (optional)
3. Select priority and category
4. Set due date (optional)
5. Tap **SAVE**

### Managing Todos
- **Complete**: Tap on the todo card
- **Edit**: Tap the edit icon ✏️
- **Delete**: Swipe left or tap delete icon 🗑️
- **Search**: Use search bar to find todos
- **Filter**: Access filters and sorting options

### View Statistics
- Tap the **📊** icon in the app bar
- See completion rate pie chart
- Check category distribution
- Review task summaries

---

## 🛠️ Build for Production

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release

# Windows
flutter build windows --release

# macOS
flutter build macos --release

# Linux
flutter build linux --release
```

---

## 🎨 Customization

### Change Theme Color
Edit `lib/main.dart`:
```dart
seedColor: const Color(0xFF87A96B), // Your color here
```

### Add New Category
Edit `lib/models/todo.dart`:
```dart
enum TodoCategory {
  // existing categories...
  newCategory;
  
  String get label => 'New Category';
  String get emoji => '🎯';
}
```

### Adjust Glass Blur
Edit `lib/widgets/glass_card.dart`:
```dart
filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Adjust values
```

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design for design guidelines
- FL Chart for beautiful charts
- Google Fonts for Poppins font
- The Flutter community

---

## 📞 Support

- 🐛 [Report Bug](../../issues)
- 💡 [Request Feature](../../issues)
- 💬 [Discussions](../../discussions)

---

<div align="center">

### Made with 💚 and Flutter

**Stay organized, stay productive** 🌿✨

⭐ Star this repo if you found it helpful!

</div>
