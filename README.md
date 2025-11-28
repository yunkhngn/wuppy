# Wuppy

**Wuppy** is a native macOS personal finance and freelance management application designed for individual freelancers. It helps you track jobs, manage debts, monitor income and expenses, and set financial goals, all with a privacy-first, local-first approach that syncs via iCloud.

![macOS](https://img.shields.io/badge/platform-macOS-lightgrey.svg)
![Swift](https://img.shields.io/badge/language-Swift-orange.svg)
![License](https://img.shields.io/badge/license-MIT-blue.svg)

## Features

- **Dashboard**: Get a quick overview of your financial health, including total income, expenses, net result, and active debts.
- **Freelance Job Management**: Track jobs from draft to payment. Manage deadlines, billing types (hourly/fixed), and client details.
- **Debt Management**: Keep track of money you owe ("I Owe") and money others owe you ("They Owe Me").
- **Income & Expenses**: Log transactions, categorize them, and link them to specific freelance jobs.
- **Financial Goals**: Set savings targets and track your progress over time.
- **Analytics**: Visualize your income trends and expense breakdowns with interactive charts.
- **Menu Bar App**: Quick access to your available balance and upcoming deadlines right from the macOS menu bar.
- **Notifications**: Receive native reminders for job deadlines and debt due dates.
- **iCloud Sync**: Seamlessly sync your data across your Mac devices using CloudKit.
- **Bilingual**: Full support for English and Vietnamese.

## Tech Stack

- **Language**: Swift 6
- **UI Framework**: SwiftUI (macOS 14+ style)
- **Data Persistence**: SwiftData
- **Sync**: CloudKit (via SwiftData `ModelContainer`)
- **Charts**: Swift Charts
- **Architecture**: MVVM

## Requirements

- macOS 14.0 (Sonoma) or later
- Xcode 15.0 or later

## Setup & Installation

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/yourusername/Wuppy.git
    cd Wuppy
    ```

2.  **Open in Xcode**:
    Double-click `Wuppy.xcodeproj` to open the project.

3.  **Configure Signing & Capabilities**:
    - Select the `Wuppy` target.
    - Go to the **Signing & Capabilities** tab.
    - Select your **Team**.
    - Ensure **iCloud** capability is added.
    - Check **CloudKit** under iCloud services.
    - Create or select an existing **CloudKit Container**.

4.  **Build and Run**:
    Press `Cmd + R` to build and run the app on your Mac.

## Localization

Wuppy supports **English** and **Vietnamese**. The app automatically detects the system language. To test a specific language, you can change your system settings or edit the Run Scheme in Xcode (Options -> App Language).

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
