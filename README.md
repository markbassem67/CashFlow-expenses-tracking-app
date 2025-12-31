# CashFlow – Expense Tracking App (Not finished)
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

| Splash Screen | OnBoarding Screen | Sign Up Screen |
|--------------|------------------------|-------------------|
| <img width="300"  src="https://github.com/user-attachments/assets/275a29fc-e2b9-4191-9878-c8e2378cdecc" /> | <img width="300"  src="https://github.com/user-attachments/assets/299207a9-f4b7-4859-b8bb-02c6ab7d0514" /> | <img width="300"  src="https://github.com/user-attachments/assets/75531f3b-c97a-4dee-99ed-8b682237d33e" /> |

| Empty Transactions Screen | Empty Reminders Screen | Empty Expenses Screen |
|--------------|------------------------|--------------|
| <img width="300" src="https://github.com/user-attachments/assets/0d48d09c-46ba-4f82-99aa-cd28f9b6b4de" /> | <img width="300"  src="https://github.com/user-attachments/assets/42c80a87-c7cf-4f39-9f22-3f1baca14690" /> |  <img width="300"  src="https://github.com/user-attachments/assets/0f914b04-e91a-4acb-95fe-05d6f54a284d" /> |




| Home Screen | Add Transaction Screen | Top Spendings Screen |
|--------------|------------------------|-------------------|
| <img src="https://github.com/user-attachments/assets/0f07ff17-e5df-44b3-9070-926dde85ed36" width="300"/> | <img src="https://github.com/user-attachments/assets/c569b75a-ddf9-4b66-b2a8-0521989860b0" width="300"/> | <img src="https://github.com/user-attachments/assets/045d0b91-8a2e-4a8f-a023-02c1c1031379" width="300"/> |



## 🎨 Design Credits

UI/UX design inspiration by https://www.figma.com/design/3SBOL8VCstkhTz7hA3JOkm/Income---Expense-Tracker-App--Community-?node-id=0-1&t=5Km9VzMN5E6JbTdg-1

