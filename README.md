# 📱 iOS Instagram clone demo

InstagramClone is a SwiftUI-based social media application inspired by Instagram. It was built using modern iOS development patterns and technologies, including **MVVM architecture**, **SwiftUI**, **Combine**, **Async/Await**, **Firebase services**, **custom camera and media handling**, and **sensor-based interactions with CoreMotion**.

---

[![Watch the video](https://img.youtube.com/vi/T-D1KVIuvjA/maxresdefault.jpg)](https://youtu.be/T-D1KVIuvjA)

## 🚀 Features

### **🔐 Authentication**
- Email/password authentication using **Firebase Auth**
- Persistent login state
- Error handling and validation

### **🏠 Feed & Explore**
- Real-time feed of posts stored in **Firebase Firestore**
- Infinite scrolling and pagination
- Smooth image loading using Firebase Storage
- Explore grid layout with SwiftUI lazy grids

### **📸 Custom Camera & Media**
- Fully custom camera built with **AVFoundation**
- Custom UI overlays, shutter button, zoom, focus
- Support for front and back cameras
- Support for image capture
- Custom gallery picker using PHPicker / Photos framework
- Integrated upload flow to Firestore & Firebase Storage

### **👤 Profile Module**
- User profile display
- Edit profile screen
- User stats (posts, followers, following)
- Fetch user-specific content

### **❤️ Social Interactions**
- Like posts
- Comment on posts (Firestore real-time updates)
- Follow / Unfollow users

### **🎥 Reels (Short Videos)**
- Reel-like short video player
- Vertical swipe navigation
- Video preloading and caching
- AVPlayer-based autoplay

### **📩 Notifications & Activity**
- Activity feed
- Real-time triggers via Firestore writes

### **🎚 Animations & UX**
- Smooth transitions using SwiftUI animations
- Hero-like animations on opening media
- Haptic feedbacks

### **📱 Gesture & Motion Integration**
- **CoreMotion**-based motion interactions for dynamic UI effects
- Device tilt effects on media

---

## 🏗 Architecture

### **MVVM (Model-View-ViewModel)**
The app is structured using a clean MVVM architecture:

- **Models** → Define data structures from Firestore and local models
- **ViewModels** → Handle business logic, data fetching, Combine publishers, async tasks
- **Views** → Purely SwiftUI UI components
- **Services** → Firebase operations, camera, gallery, cache, motion

This ensures scalability, testability, and separation of concerns.

---

## 🧰 Technologies Used

### **Swift & iOS Frameworks**
- **SwiftUI** – UI framework
- **Combine** – Data streams and publishers
- **Async/Await** – Modern concurrency
- **AVFoundation** – Custom camera & reels player
- **CoreMotion** – Device motion and accelerometer
- **Photos / PHPicker** – Gallery picker

### **Firebase**
- **Authentication** – Login/signup
- **Firestore (Database)** – User profiles, posts, comments, interactions
- **Storage** – Images & videos

### **Tools & Dependencies**
- Swift Package Manager
- iOS 16+ deployment target

---

## 📂 Project Structure

```
InstagramClone/
│
├── Models/
├── Views/
├── ViewModels/
├── Services/
│   ├── AuthService.swift
│   ├── UserService.swift
│   ├── PostService.swift
│   ├── ReelService.swift
│   └── StorageService.swift
│
├── Camera/
│   ├── CustomCameraView.swift
│   └── CameraService.swift
│
├── Motion/
│   └── MotionManager.swift
│
└── Resources/
    ├── Assets.xcassets
    └── Firebase configuration files
```

---

---

## ⚙️ Setup Instructions

1. Clone the repository:
```bash
git clone https://github.com/youruser/InstagramClone.git
```

2. Open the Xcode project:
```bash
open InstagramClone.xcodeproj
```

3. Add your **GoogleService-Info.plist** file inside the project.

4. Make sure Firebase is configured in `AppDelegate` or SwiftUI `App` initializer.

5. Run the app on iOS 16+ device or simulator.

---

## 📄 License
This project is for educational purposes only and is not intended for commercial use. Instagram™ is a trademark of Meta Platforms, Inc.

---

## 👨‍💻 Author
Developed by Reinner Steven Daza Leiva.

Feel free to contribute or create issues for improvements.

