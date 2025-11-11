# Market Management App

A complete Flutter application for managing grocery lists with local database storage, price tracking, and image support.

## 📱 Features

- **📝 Item Management**: Add, edit, and delete grocery items
- **🏷️ Categories**: Organize items by type (grocery, protein, drinks, vegetables, cleaning)
- **💰 Price Tracking**: Compare current prices with previous values
- **🖼️ Image Support**: Add custom photos or use category icons
- **✅ Purchase Status**: Mark items as bought/unbought
- **💾 Local Storage**: SQLite database for offline functionality
- **📸 Camera/Gallery Integration**: Capture or select item photos

## 🛠️ Technical Stack

- **Framework**: Flutter
- **Database**: SQLite with sqflite
- **State Management**: Flutter StatefulWidget
- **Image Picker**: Camera and gallery integration
- **UI Components**: Custom bottom sheets, slidable items, currency formatting

## 📁 Project Structure

```
lib/
├── enum/
│   └── status.dart          # Status enum for form operations
├── helpers/
│   └── grocery_helper.dart  # Database operations and models
├── ui/
│   └── home_page.dart       # Main application interface
└── main.dart                # Application entry point

assets/images/               # Category icons
├── grocery.png
├── protein.png
├── drinks.png
├── vegetable.png
└── cleaning.png
```

## 🗃️ Database Schema

The app uses SQLite with the following table structure:

```sql
CREATE TABLE groceryTable(
  idColumn INTEGER PRIMARY KEY,
  nameColumn TEXT,
  valueColumn TEXT,
  oldValueColumn TEXT,
  imgColumn TEXT,
  typeColumn TEXT,
  isSelectedColumn INTEGER
)
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>= 3.0.0)
- Dart (>= 2.17.0)
- Android Studio / VS Code with Flutter extension

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/your-username/market-management.git
cd market-management
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the application**
```bash
flutter run
```

## 📖 Usage

### Adding Items
1. Tap the floating action button (+)
2. Select a category icon
3. Enter item name and price
4. Submit to save

### Managing Items
- **Tap item**: Open action menu
- **Edit Name**: Modify item name
- **Edit Price**: Update price (tracks previous value)
- **Edit Icon/Photo**: Change category or add custom image
- **Swipe right**: Toggle bought/unbought status
- **Delete**: Remove item from list

### Price Comparison
- **Green**: Current price is lower than previous
- **Red**: Current price is higher than previous
- Displays both current and previous prices for comparison

## 🎨 UI Components

### Home Page (`home_page.dart`)
- List view of all grocery items
- Slidable cards with action buttons
- Floating action button for adding new items
- Category-based color coding

### Bottom Sheets
- **Input Bottom Sheet**: Add/edit items with form validation
- **Action Bottom Sheet**: Item management options
- **Photo Options**: Camera/gallery/category selection

## 🔧 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  sqflite: ^2.0.0+4        # Local database
  path: ^1.8.0             # Path utilities
  image_picker: ^1.0.4     # Camera/gallery access
  currency_text_input_formatter: ^1.0.1  # Currency formatting
  flutter_slidable: ^2.0.0 # Swipeable list items
```

## 📊 Data Models

### GroceryItem Class
```dart
class GroceryItem {
  int? id;
  String name;
  String value;
  String oldValue;
  String? img;
  String type;
  int isSelected;
  // ... constructor, fromMap(), toMap() methods
}
```

### Status Enum
```dart
enum Status { 
  newItem,    // Creating new item
  editName,   // Editing item name
  editPrice   // Editing item price
}
```

## 🗃️ Database Operations

The `GroceryHelper` class provides:
- ✅ `saveGroceryItem()` - Create new items
- ✅ `getAllGroceryItems()` - Retrieve all items
- ✅ `updateGroceryItem()` - Modify existing items
- ✅ `deleteGroceryItem()` - Remove items
- ✅ `getGroceryItemCount()` - Get total item count

## 🎯 Key Features Implementation

### Form Validation
- Auto-focus on empty fields during submission
- Currency formatting for price input
- Input validation with visual feedback

### Image Handling
- Category-based default icons
- Camera integration for live photos
- Gallery access for existing images
- File path storage in database

### State Management
- Real-time UI updates with `setState()`
- Database synchronization after operations
- Persistent storage across app sessions

## 📱 Screenshots

*(Add your app screenshots here)*

## 🚧 Future Enhancements

- [ ] Cloud synchronization
- [ ] Barcode scanning
- [ ] Shopping list sharing
- [ ] Price history charts
- [ ] Multiple store price comparison
- [ ] Export to CSV functionality

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📞 Support

If you have any questions or issues, please open an issue on the GitHub repository.

---

**Built with ❤️ using Flutter**
