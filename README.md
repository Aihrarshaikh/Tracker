# Expense Tracker App

This Flutter application helps users track their expenses, providing features like adding, updating, and deleting expenses, as well as visualizing expense data.

<table>
  <tr>
    <td><img src="img1.jpeg" width="200" height="400"></td>
    <td><img src="img2.jpeg" width="200" height="400"></td>
  </tr>
  <tr>
    <td><img src="img3.jpeg" width="200" height="400"></td>
    <td><img src="img4.jpeg" width="200" height="400"></td>
  </tr>
  <tr>
   <td><img src="img5.jpeg" width="200" height="400"></td>
    <td><img src="img6.jpeg" width="200" height="400"></td>
  </tr>
  <tr>
    <td><img src="img7.jpeg" width="200" height="400"></td>
  </tr>
</table>


## Setup Instructions

1. Ensure you have Flutter installed on your machine. If not, follow the [official Flutter installation guide](https://flutter.dev/docs/get-started/install).

2. Clone this repository:
   ```
   git clone https://github.com/Aihrarshaikh/Tracker.git
   ```

3. Navigate to the project directory:
   ```
   cd Tracker
   ```

4. Install dependencies:
   ```
   flutter pub get
   ```

5. Run the build runner to generate necessary files:
   ```
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

## Running the App

1. Connect a device or start an emulator.

2. Run the app:
   ```
   flutter run
   ```

## Running Tests

To run the tests, use the following command:
```
flutter test
```

## Project Structure

The project follows a clean architecture approach:

- `lib/core`: Contains core functionality and theme data.
- `lib/data`: Implements data sources and models.
- `lib/domain`: Defines entities and repository interfaces.
- `lib/presentation`: Contains UI-related code (providers, screens, widgets).
- `lib/services`: Implements additional services like notifications.


# Expense Tracker App: Design and Architecture Report

## 1. Architectural Overview

The Expense Tracker App follows the principles of Clean Architecture, which promotes separation of concerns and maintainability. The architecture is divided into the following layers:

1. Presentation Layer
2. Domain Layer
3. Data Layer

### 1.1 Presentation Layer

This layer contains the UI components and is responsible for displaying data to the user and handling user interactions. It includes:

- Screens: `addExpenseScreen.dart`, `expenseListScreen.dart`, `expenseSummaryScreen.dart`
- Widgets: `expenseChart.dart`, `expenseItem.dart`
- Providers: `expenseProvider.dart`

The use of providers (specifically, `expenseProvider.dart`) indicates the implementation of the Provider pattern for state management, which is a recommended approach in Flutter for managing app-wide state.

### 1.2 Domain Layer

This layer contains the core business logic of the application. It includes:

- Entities: `expense.dart`
- Repository Interfaces: `expenseRepository.dart`

The domain layer is independent of other layers and defines the core functionality of the app.

### 1.3 Data Layer

This layer is responsible for data retrieval and storage. It includes:

- Data Sources: `expenseLocalDataSource.dart`
- Models: `expenseModel.dart`, `expenseModel.g.dart`
- Repository Implementations: `expenseRepositoryImp.dart`

The presence of a `.g.dart` file suggests the use of code generation, possibly for JSON serialization/deserialization.

## 2. Design Decisions

### 2.1 State Management

The choice of Provider for state management allows for efficient updating of the UI when the underlying data changes. The `ExpenseProvider` class encapsulates the business logic for managing expenses, including loading, adding, updating, and deleting expenses.

### 2.2 Local Data Storage

The presence of `expenseLocalDataSource.dart` suggests that the app uses local storage for persisting expense data. This is a good choice for an expense tracking app as it allows for offline functionality and quick data access.

### 2.3 Code Generation

The use of code generation (as evidenced by `expenseModel.g.dart`) likely simplifies the process of converting between Dart objects and JSON, which is useful for data persistence and potentially for API communication if implemented in the future.

### 2.4 Separation of Model and Entity

The distinction between `expenseModel.dart` and `expense.dart` (in the domain layer) suggests a separation between the data representation used for storage/network (Model) and the business logic representation (Entity). This separation allows for easier changes to the data layer without affecting the core business logic.

## 3. Testing Approach

The testing approach for this application focuses on unit testing, particularly for the `ExpenseProvider` class. The test file `widget_test.dart` contains several test groups:

1. Initial State Testing
2. Load Expenses Testing
3. Add Expense Testing
4. Update Expense Testing
5. Delete Expense Testing
6. Filtered Expenses Testing
7. Total Expenses Calculation Testing
8. Expenses by Category Testing

The tests use mock objects (created with the Mockito package) to simulate the behavior of the `ExpenseRepository`. This allows for isolated testing of the `ExpenseProvider` logic without depending on actual data storage.

The comprehensive test suite covers various scenarios, including success cases and error handling. This approach helps ensure the reliability and correctness of the core business logic.

## 4. Areas for Potential Improvement

1. UI Testing: The current test suite focuses on unit tests. Adding widget tests and integration tests would provide more comprehensive coverage.

2. Error Handling: While error states are tested, the actual error handling in the UI could be expanded for a better user experience.

3. Dependency Injection: Consider implementing a dependency injection system for easier management of dependencies and to facilitate testing.

4. Localization: If the app is intended for a global audience, implementing localization would be beneficial.

5. Themeing: The presence of `appTheme.dart` suggests some theming implementation. This could be expanded to support dynamic theming or dark mode.

## Conclusion

The Expense Tracker App demonstrates a well-structured architecture that separates concerns and should be maintainable as the app grows. The testing approach provides good coverage of the core business logic. With some additional enhancements in areas like UI testing and error handling, this app has a solid foundation for further development and scaling.

## License

This project is open source and available under the [MIT License](LICENSE).