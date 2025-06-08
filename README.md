# MGCard

A powerful and flexible card component library for iOS applications, supporting both UIKit and SwiftUI with a clean, declarative API.

[![Swift Version](https://img.shields.io/badge/Swift-5.0+-orange.svg)](https://swift.org)
[![iOS Version](https://img.shields.io/badge/iOS-14.0+-blue.svg)](https://developer.apple.com/ios/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## 📱 Demo 

https://github.com/user-attachments/assets/1d18da25-5fe7-4285-b74b-77a4e36e1191

## Features

✨ **Rich Components**
- Text with customizable fonts, colors, and alignment
- Images with flexible sizing and rendering modes
- Action buttons with multiple styles (filled, outlined, clear)
- Text input fields with placeholders and validation
- Dismiss button with custom actions

🎯 **Dual Framework Support**
- **UIKit**: Advanced window management and animations
- **SwiftUI**: Native declarative syntax with state binding

🔧 **Flexible API**
- Method chaining for clean, readable code
- Component-specific configuration methods
- Comprehensive styling options
- Queue management for multiple alerts
- Window-level presentation system
- Spring-based animations with custom damping

🎨 **Modern Design**
- Smooth animations and transitions
- Customizable button styles and colors
- Responsive layout with dynamic sizing
- Professional UI components
- Rounded corners (12pt radius) for modern look
- Semi-transparent dimmed background (25% opacity)

## Installation

### Swift Package Manager

Add MGCard to your project using Xcode:

1. Go to **File** → **Add Package Dependencies**
2. Enter the repository URL: `https://github.com/Miswag/MGCard.git`
3. Select **Up to Next Major Version** and click **Add Package**

Or add it to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/Miswag/MGCard.git", from: "1.0.0")
]
```

## Quick Start

### UIKit Usage

```swift
import MGCard

// Simple alert
MGCard()
    .text(title: "Success!", subtitle: "Operation completed successfully")
    .action(title: "OK", style: .filled(color: .blue), width: .dynamic)
    .show()

// Alert with dismiss button
MGCard()
    .hasDismissButton(true)
    .dismissButtonAction { print("Dismissed") }
    .image(name: "star.fill", width: 60, height: 60)
    .text(title: "Welcome!", titleFont: .boldSystemFont(ofSize: 20))
    .action(title: "Continue", style: .filled(color: .green), width: .dynamic)
    .show()
```

### SwiftUI Usage

```swift
import SwiftUI
import MGCard

struct ContentView: View {
    @State private var showAlert = false
    
    var body: some View {
        Button("Show Alert") { showAlert = true }
            .mgCard(isPresented: $showAlert) { card in
                card
                    .text(title: "Hello SwiftUI!", subtitle: "MGCard works great with SwiftUI")
                    .action(title: "Awesome", style: .filled(color: .blue), width: .dynamic)
            }
    }
}
```

## Components

### Text Component

Display formatted text with full customization:

```swift
.text(
    title: "Main Title",
    titleFont: .boldSystemFont(ofSize: 20),
    titleColor: .black,
    titleAlignment: .center,
    subtitle: "Optional subtitle",
    subtitleFont: .systemFont(ofSize: 14),
    subtitleColor: .gray,
    subtitleAlignment: .center,
    spacing: 8
)
```

### Image Component

Show images with flexible sizing and rendering:

```swift
.image(
    name: "star.fill",              // System icon or asset name
    width: 80,
    height: 80,
    scale: .scaleAspectFit,         // Content mode
    renderingMode: .alwaysTemplate  // Rendering mode
)
```

### Action Button Component

Create interactive buttons with various styles:

```swift
// Filled button
.action(
    title: "Primary Action",
    style: .filled(color: .blue),
    width: .dynamic,
    height: 44,
    icon: "checkmark.circle",
    canDismissAlert: true
) {
    print("Primary action tapped")
}

// Outlined button
.action(
    title: "Secondary Action",
    style: .outlined(color: .red),
    width: .fixed(120)
) {
    print("Secondary action tapped")
}

// Clear button
.action(
    title: "Tertiary Action",
    style: .clear(color: .gray),
    width: .dynamic
)
```

### Text Input Component

Add text input fields with real-time validation and formatting:

```swift
.textInput(
    placeholder: "Enter your email...",
    subtitle: "We'll never share your email",
    subtitleFont: .caption,
    subtitleColor: .secondaryLabel,
    textFont: .body,
    textColor: .label,
    backgroundColor: .secondarySystemBackground,
    cornerRadius: 8,
    borderColor: .separator,
    borderWidth: 1
) { text in
    print("Text changed: \(text ?? "")")
    // Real-time validation, formatting, or processing
}
```

**Text Input Features:**
- **Real-time callbacks**: Get notified of every text change
- **Placeholder handling**: Smart placeholder text management
- **Custom styling**: Full control over appearance
- **UITextView delegate**: Proper text editing behavior
- **Height control**: Fixed 100pt height for consistent layout

## Button Styles

### Filled Style
```swift
.action(title: "Save", style: .filled(color: .blue), width: .dynamic)
```

### Outlined Style
```swift
.action(title: "Cancel", style: .outlined(color: .red), width: .dynamic)
```

### Clear Style
```swift
.action(title: "Skip", style: .clear(color: .gray), width: .dynamic)
```

## Width Styles

### Dynamic Width
Automatically adjusts to content with padding:
```swift
.action(title: "Auto Size", style: .filled(color: .blue), width: .dynamic)
```

### Fixed Width
Specific width in points:
```swift
.action(title: "Fixed", style: .filled(color: .blue), width: .fixed(200))
```

## Dismiss Button

Configure the dismiss button (X) in the top-right corner:

```swift
MGCard()
    .hasDismissButton(true)
    .dismissButtonAction {
        print("User dismissed the alert")
        // Custom dismiss logic here
    }
    // ... other components
    .show()
```

## Advanced Examples

### Multi-Component Alert

```swift
MGCard()
    .hasDismissButton(true)
    .image(name: "person.crop.circle", width: 80, height: 80)
    .text(
        title: "Profile Setup",
        titleFont: .boldSystemFont(ofSize: 22),
        subtitle: "Complete your profile information"
    )
    .textInput(
        placeholder: "Full Name",
        subtitle: "Enter your full name"
    ) { name in
        print("Name: \(name ?? "")")
    }
    .textInput(
        placeholder: "Email Address", 
        subtitle: "We'll send confirmation here"
    ) { email in
        print("Email: \(email ?? "")")
    }
    .action(
        title: "Create Profile",
        style: .filled(color: .systemBlue),
        width: .dynamic,
        icon: "person.badge.plus"
    ) {
        print("Creating profile...")
    }
    .action(
        title: "Skip for Now",
        style: .clear(color: .systemGray),
        width: .dynamic
    ) {
        print("Skipping profile setup")
    }
    .show()
```

### SwiftUI Form Alert

```swift
struct LoginView: View {
    @State private var showLoginAlert = false
    @State private var username = ""
    @State private var password = ""
    
    var body: some View {
        VStack {
            Button("Login") { showLoginAlert = true }
        }
        .mgCard(
            isPresented: $showLoginAlert,
            showDismissButton: true,
            dismissButtonCompletion: { print("Login dismissed") }
        ) { card in
            card
                .image(name: "lock.shield", width: 60, height: 60)
                .text(
                    title: "Secure Login",
                    titleFont: .boldSystemFont(ofSize: 20),
                    subtitle: "Enter your credentials to continue"
                )
                .textInput(placeholder: "Username", subtitle: "Your username") { text in
                    username = text ?? ""
                }
                .textInput(placeholder: "Password", subtitle: "Your password") { text in
                    password = text ?? ""
                }
                .action(
                    title: "Sign In",
                    style: .filled(color: .systemBlue),
                    width: .dynamic,
                    icon: "arrow.right.circle"
                ) {
                    performLogin(username: username, password: password)
                }
                .action(
                    title: "Forgot Password?",
                    style: .clear(color: .systemBlue),
                    width: .dynamic
                ) {
                    showForgotPassword()
                }
        }
    }
    
    func performLogin(username: String, password: String) {
        // Login logic
    }
    
    func showForgotPassword() {
        // Forgot password logic
    }
}
```

## Advanced Features

### Queue Management

MGCard automatically manages multiple alerts in a queue:

```swift
// These will show one after another
MGCard().text(title: "First Alert").action(title: "OK", style: .filled(color: .blue), width: .dynamic).show()
MGCard().text(title: "Second Alert").action(title: "OK", style: .filled(color: .green), width: .dynamic).show()
MGCard().text(title: "Third Alert").action(title: "OK", style: .filled(color: .red), width: .dynamic).show()
```

### Window-Level Presentation

MGCard uses advanced window management to ensure proper presentation:

- **High-level window**: Appears above all other content
- **Scene-based**: Automatically finds the correct window scene
- **Auto-dismiss**: Properly cleans up window resources
- **Thread-safe**: Queue management with dedicated dispatch queue

### Animation System

Cards appear with smooth spring animations:

- **Scale entrance**: Cards scale up from 0.5x to 1.0x size
- **Spring damping**: 0.6 damping ratio for natural feel
- **Fade transition**: Background dims with smooth alpha transition
- **Duration**: 0.5 seconds for entrance, 0.3 seconds for exit

### Custom Styling Options

Beyond basic styling, MGCard offers:

```swift
MGCard()
    .text(
        title: "Custom Styling",
        titleFont: .systemFont(ofSize: 20, weight: .bold),
        titleColor: .systemBlue,
        titleAlignment: .left,
        spacing: 12  // Custom spacing between text elements
    )
    .action(
        title: "Custom Button",
        style: .filled(color: .systemPurple),
        width: .fixed(250), // Exact width control
        height: 50,         // Custom height
        icon: "star.fill",  // SF Symbols support
        canDismissAlert: false // Prevent auto-dismiss
    )
```

## Requirements

- iOS 14.0+
- Swift 5.0+
- Xcode 12.0+

## License

MGCard is released under the MIT license. See [LICENSE](LICENSE) for details.

## Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## Support

- 📧 Email: [mosa.khaldun98@gmail.com]
- 🐛 Issues: [GitHub Issues](https://github.com/Miswag/MGCard/issues)
- 💡 Feature Requests: [GitHub Discussions](https://github.com/Miswag/MGCard/discussions)

---

Made with ❤️ for the iOS community
