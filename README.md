# CashFlow – Expense Tracking App
An easy-to-use Flutter app that helps users track their expenses, set goals, and manage their financial habits. The app is designed with persistence in mind so that data is retained even after closing or restarting the app.


## ✅ Core Architecture & Setup

- Chose Flutter with Bloc (Cubit) for state management.

- Organised project into clean layers:

   - data/ → repositories, models, persistence

   - logic/ → cubits & states

   - presentation/ → screens & widgets
 

## 🚀 Features

- Add, edit, and delete transactions.

- Categorise transactions as Income or Expense.

- Display total balance, total income, and total expenses.

- Store user profile name.

- User profile name is saved locally using Shared Preferences and restored on app restart.

- Lightweight and fast thanks to local storage (no external server required).

## 🛠️ Tech Stack

- Flutter (Dart) – Cross-platform UI toolkit.

- Shared Preferences – For storing user profile data persistently.

- Hive – Used for storing transaction data locally.


## Screenshots

## 🎨 Design Credits

UI/UX design inspiration by https://www.figma.com/design/3SBOL8VCstkhTz7hA3JOkm/Income---Expense-Tracker-App--Community-?node-id=0-1&t=5Km9VzMN5E6JbTdg-1

