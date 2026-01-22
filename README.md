# 🌿 Advanced Todo List App

### A stunning glassmorphism Todo app with sage green aesthetics

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)

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


## 📱 Supported Platforms

| Platform | Status |
|----------|:------:|
| Android  | ✅ |
| iOS      | ✅ |
| Web      | ✅ |
| Windows  | ✅ |
| macOS    | ✅ |
| Linux    | ✅ |

## 🖼 Screenshots

<img src="https://raw.githubusercontent.com/kanizadev/p012/refs/heads/main/1.png" hight=446 width=243 /> <img src="https://raw.githubusercontent.com/kanizadev/p012/refs/heads/main/Advanced%20Todo%20.gif" hight=446 width=243 /> 


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


## 📞 Support

- 🐛 [Report Bug](https://github.com/kanizadev/p012/issues)
- 💡 [Request Feature](https://github.com/kanizadev/p012/issues)
- 💬 [Discussions](https://github.com/kanizadev/p012/discussions)

---


### Made with 💚 and Flutter

**Stay organized, stay productive** 🌿✨

⭐ Star this repo if you found it helpful!

