# SMPosts 📰

SMPosts is an iOS demo application built as part of a technical exercise. It showcases an app that interacts with the [JSONPlaceholder](https://jsonplaceholder.typicode.com/) API to fetch, display, and create posts. It includes features such as post browsing, detail views with comments, post creation, and basic caching with connectivity awareness. The app is built using Swift and modern iOS development techniques.

## 📸 Screenshots

### 📋 Posts List
![Posts List (Light)](https://i.postimg.cc/g2d4pHVK/IMG-6294.png)
![Posts List (Dark)](https://i.postimg.cc/13HB3VM1/IMG-6295.png)

### 📄 Post Details
![Post Details (Light)](https://i.postimg.cc/BvngLZwL/IMG-6297.png)
![Post Details (Dark)](https://i.postimg.cc/N0Cx1hWN/IMG-6296.png)

## 📱 Features

- Displays a list of posts from [JSONPlaceholder](https://jsonplaceholder.typicode.com/)
- Tap to view detailed post info, including:
  - First 3 related comments
  - A random image from [picsum.photos](https://picsum.photos/)
- Create and submit new posts
- Local deletion of posts from the list & cache
- Basic cache layer to preserve the last fetched data
- Connectivity-aware behavior:
  - informs user of network state
  - Displays cached content when available
- App Settings (via iOS Preferences app):
  - **Clear cache on next launch**
  - **Switch between Real and Mock environments** _(Mock loads static local JSON data)_

## ⚙️ Tech Stack & Architecture

- **Language**: Swift
- **UI**: SwiftUI
- **Architecture**: MVVM
- **Data Layer**: URLSession + Combine
- **Image Handling**: Custom AsyncImage with persistent caching

## 🌐 Environments

- **Real**: Live API data from [jsonplaceholder.typicode.com](https://jsonplaceholder.typicode.com/)
- **Mock**: Local bundled JSON for offline testing or demo mode

## 📋 Project Constraints

- The only constraint was to use **Swift**
- SwiftUI and any architecture choice were allowed

## 🚀 Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/Salah-Eddine-Kahack/SMPosts-iOS-Demo.git
2. Open the project:
    - Open `SMPosts-iOS-Demo.xcodeproj` in Xcode.

3. Build & Run:
    - Select an iPhone simulator or device.
    - Hit `Cmd + R` to build and run the app.
    - Requires Xcode 16, Swift 6, and iOS 16.4+.

## 🙏 Thanks

Thanks to JSONPlaceholder and picsum.photos for providing free and useful demo APIs.

This app was a fun opportunity to demonstrate clean architecture, data flow, and UI responsiveness. All in native Swift.
Feel free to fork the repo, open issues, or just say hi! 👋
