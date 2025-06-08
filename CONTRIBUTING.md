# Contributing to MGCard

Thank you for your interest in contributing to MGCard! 🎉 We welcome contributions from the community and are grateful for any help you can provide.

MGCard is a powerful iOS card component library supporting both UIKit and SwiftUI. Whether you're fixing bugs, adding features, improving documentation, or helping with testing, your contributions are valuable.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Environment](#development-environment)
- [Project Structure](#project-structure)
- [API Architecture](#api-architecture)
- [Contribution Types](#contribution-types)
- [Development Guidelines](#development-guidelines)
- [Testing](#testing)
- [Pull Request Process](#pull-request-process)
- [Release Process](#release-process)

## Code of Conduct

By participating in this project, you agree to abide by our Code of Conduct:

- **Be respectful**: Treat everyone with respect and consideration
- **Be inclusive**: Welcome newcomers and encourage diverse perspectives
- **Be constructive**: Provide helpful feedback and suggestions
- **Be patient**: Remember that everyone has different experience levels
- **Be collaborative**: Work together towards common goals

## Getting Started

### Prerequisites

- **macOS** with Xcode 12.0 or later
- **iOS 14.0+** for UIKit core features
- **iOS 14.0+** for SwiftUI integration
- **Swift 5.0+** knowledge
- Familiarity with UIKit and/or SwiftUI

### Quick Setup

1. **Fork the repository** on GitHub
2. **Clone your fork**:
   ```bash
   git clone https://github.com/yourusername/MGCard.git
   cd MGCard
   ```
3. **Open in Xcode**:
   ```bash
   open Package.swift
   ```
4. **Build the project** (⌘+B) to ensure everything works
5. **Run examples** to see MGCard in action:
   - Check `Sources/Example/` for usage examples
   - Use the demo controller for comprehensive testing

## Development Environment

### Required Tools
- **Xcode 12.0+**: Primary development environment
- **iOS Simulator**: For testing on different devices
- **Git**: Version control (with meaningful commit messages)

### Recommended Tools
- **SwiftFormat**: Code formatting (if you use it, please configure it to match our style)
- **SwiftLint**: Code linting (optional but helpful)

## Project Structure

```
MGCard/
├── Sources/
│   ├── MGCard/                    # Main library source code
│   │   ├── MGCard.swift          # Core UIKit implementation & public API
│   │   ├── MGCardSwiftUI.swift   # SwiftUI wrapper & integration
│   │   ├── MGCardComponent.swift # Component definitions & enums
│   │   ├── CardActionView.swift  # Action button implementation
│   │   └── Extensions.swift      # Utility extensions
│   └── Example/                   # Usage examples & demos
│       ├── MGCardDemoController.swift  # Comprehensive demo (UIKit)
│       ├── UIKitUsageExample.swift     # UIKit usage patterns
│       └── SwiftUIUsageExample.swift   # SwiftUI usage patterns
├── Package.swift                 # Swift Package Manager configuration
├── README.md                    # Project documentation
├── CONTRIBUTING.md              # This file
├── CHANGELOG.md                # Version history
└── LICENSE                     # MIT License
```

## API Architecture

MGCard uses a **layered architecture** with clean separation of concerns:

### Core Layer (UIKit)
- **MGCard.swift**: Main public API class with chainable methods
- **MGCardManager**: Internal queue management system
- **Component System**: Modular component architecture

### SwiftUI Integration Layer
- **MGCardSwiftUI.swift**: SwiftUI wrapper and view modifiers
- **MGCardBuilder**: Result builder for declarative syntax
- **State Management**: Binding-based presentation control

### Component Layer
- **AlertComponent Protocol**: Base interface for all components
- **Component Implementations**: Text, Image, Action, TextInput
- **CardActionView**: Specialized button view implementation

### Public API Design

The API follows these principles:

1. **Method Chaining**: Fluent interface for easy configuration
2. **Sensible Defaults**: Minimal required parameters
3. **Progressive Enhancement**: Basic → Advanced features
4. **Framework Agnostic**: Works in both UIKit and SwiftUI

```swift
// Example: Progressive API complexity
MGCard().text(title: "Hello").show()                    // Basic
MGCard().text(title: "Hello", subtitle: "World").show() // Enhanced
MGCard()                                                 // Full control
    .text(title: "Hello", titleFont: .bold, titleColor: .blue)
    .show()
```

## Contribution Types

### 🐛 Bug Fixes
- Fix issues in existing functionality
- Improve error handling and edge cases
- Address memory leaks or performance issues
- Fix animation or layout problems

### ✨ New Features
- Add new component types (e.g., custom input fields)
- Enhance existing components with new options
- Improve SwiftUI integration features
- Add accessibility and internationalization support

### 📚 Documentation
- Improve README examples and guides
- Add comprehensive inline documentation
- Create tutorials for common use cases
- Update example files with new patterns

### 🔍 Code Review & Quality
- Review code for best practices and performance
- Ensure proper error handling and edge cases
- Verify memory management and lifecycle
- Check accessibility and usability

### 🎨 UI/UX Improvements
- Enhance animations and transitions
- Improve visual design and styling options
- Better responsive behavior across devices
- Accessibility and VoiceOver improvements

## Development Guidelines

### Code Style & Conventions

**Swift Naming:**
```swift
// ✅ Good: Clear, descriptive names
func text(title: String, subtitle: String? = nil) -> MGCard
func action(title: String, style: ButtonStyle, width: WidthStyle) -> MGCard

// ❌ Avoid: Abbreviated or unclear names
func txt(t: String, s: String? = nil) -> MGCard
func btn(t: String, st: BtnStyle, w: WStyle) -> MGCard
```

**Method Chaining API:**
```swift
// ✅ Good: Fluent, readable chain
MGCard()
    .text(title: "Welcome", subtitle: "Get started with MGCard")
    .image(name: "star.fill", width: 60, height: 60)
    .action(title: "Continue", style: .filled(color: .blue), width: .dynamic)
    .show()

// ✅ Good: Progressive complexity
MGCard()
    .text(title: "Simple") // Minimal
    .show()

MGCard()
    .text(
        title: "Advanced",
        titleFont: .boldSystemFont(ofSize: 18),
        titleColor: .systemBlue,
        titleAlignment: .center,
        subtitle: "With full customization",
        subtitleFont: .systemFont(ofSize: 14),
        subtitleColor: .secondaryLabel
    ) // Full control
    .show()
```

**Access Control Guidelines:**
- `public`: External API methods and types (`MGCard`, `ButtonStyle`, `WidthStyle`)
- `internal`: Internal implementation details (`MGCardManager`, component classes)
- `private`: Class-specific implementation details

**Error Handling:**
```swift
// ✅ Good: Graceful fallbacks
guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
    print("MGCard Error: Failed to find a window scene")
    return
}

// ✅ Good: Safe image loading with fallbacks
let image = UIImage.fetch(imageName, fallBackIcon: "questionmark.circle.fill")
```

### Architecture Principles

1. **UIKit-First Design**: Core implementation in UIKit for maximum control and performance
2. **SwiftUI Wrapper Pattern**: Clean SwiftUI integration without compromising UIKit features
3. **Component-Based Architecture**: Modular, reusable components that compose well
4. **Declarative API**: Method chaining for intuitive, readable configuration
5. **Queue Management**: Automatic handling of multiple alerts with proper lifecycle
6. **Memory Safety**: Weak references and proper cleanup in all scenarios

### Documentation Standards

**All public APIs require comprehensive documentation:**

```swift
/// Adds a text component with customizable title and subtitle styling
/// 
/// This method allows you to add text content to the card with full control over
/// typography, colors, and alignment for both title and subtitle text.
/// 
/// - Parameters:
///   - title: The main text to display
///   - titleFont: Optional font for the title (default: system font)
///   - titleColor: Optional color for the title (default: label color)
///   - titleAlignment: Optional alignment for the title (default: center)
///   - subtitle: Optional subtitle text
///   - subtitleFont: Optional font for the subtitle
///   - subtitleColor: Optional color for the subtitle
///   - subtitleAlignment: Optional alignment for the subtitle
///   - spacing: Vertical spacing between title and subtitle (default: 1)
/// - Returns: Self for method chaining
/// 
/// ## Example
/// ```swift
/// MGCard()
///     .text(title: "Welcome", subtitle: "Get started")
///     .show()
/// ```
@discardableResult
public func text(
    title: String,
    titleFont: UIFont? = nil,
    titleColor: UIColor? = nil,
    titleAlignment: NSTextAlignment? = nil,
    subtitle: String? = nil,
    subtitleFont: UIFont? = nil,
    subtitleColor: UIColor? = nil,
    subtitleAlignment: NSTextAlignment? = nil,
    spacing: CGFloat = 1
) -> MGCard
```

## Testing & Validation

### Manual Testing Strategy

Since MGCard is a UI-focused library, comprehensive manual testing is crucial:

**Testing Checklist:**
- [ ] **Build Success**: No compilation errors or warnings
- [ ] **Visual Correctness**: All components render as expected
- [ ] **Interaction**: Buttons, inputs, and gestures work correctly
- [ ] **Animation**: Smooth presentation and dismissal animations
- [ ] **Memory**: No leaks during repeated show/dismiss cycles
- [ ] **Performance**: Smooth on older devices (iPhone 8, iPad Air 2)
- [ ] **Edge Cases**: Long text, many components, rapid interactions

### Example-Based Testing

Use the provided example files for testing:

```swift
// Test using the demo controller
let demoController = MGCardDemoController()
navigationController?.pushViewController(demoController, animated: true)

// Test specific patterns
let uikitExample = UIKitUsageExample()
let swiftuiExample = SwiftUIUsageExample()
```

### Platform Testing

**UIKit Testing:**
```swift
class TestViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Test basic functionality
        MGCard()
            .text(title: "Test Card")
            .action(title: "Test Action", style: .filled(color: .blue), width: .dynamic)
            .show()
        
        // Test complex scenarios
        MGCard()
            .image(name: "star.fill", width: 60, height: 60)
            .text(title: "Complex Test", subtitle: "Multiple components")
            .textInput(placeholder: "Enter text...", subtitle: "Input test")
            .action(title: "Primary", style: .filled(color: .blue), width: .dynamic)
            .action(title: "Secondary", style: .outlined(color: .gray), width: .dynamic)
            .show()
    }
}
```

**SwiftUI Testing:**
```swift
struct TestView: View {
    @State private var showCard = false
    
    var body: some View {
        Button("Test MGCard") { showCard = true }
            .mgCard(isPresented: $showCard) { card in
                card
                    .text(title: "SwiftUI Test")
                    .action(title: "OK", style: .filled(color: .blue), width: .dynamic)
            }
    }
}
```

### Performance Validation

**Memory Testing:**
1. Show and dismiss cards repeatedly (100+ times)
2. Monitor memory usage in Instruments
3. Check for retain cycles and leaks

**Animation Testing:**
1. Test on various device models
2. Verify 60 FPS during animations
3. Test with accessibility settings enabled

## Pull Request Process

### Before Submitting

1. **Create a feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   # or
   git checkout -b fix/bug-description
   ```

2. **Test your changes** thoroughly:
   - Build successfully on multiple Xcode versions
   - Test manually with provided examples
   - Verify both UIKit and SwiftUI integration
   - Test on various iOS versions and devices

3. **Update documentation**:
   - Update README if adding new features
   - Add inline documentation for public APIs
   - Update examples if API changes

4. **Update CHANGELOG.md** with your changes

### PR Requirements

**Title Format:**
- `feat: Add custom input validation to textInput component`
- `fix: Resolve memory leak in card queue management`
- `docs: Update SwiftUI integration examples`
- `perf: Optimize image loading in AlertImage component`

**Description Template:**
```markdown
## Description
Brief description of what this PR accomplishes and why.

## Type of Change
- [ ] 🐛 Bug fix (non-breaking change that fixes an issue)
- [ ] ✨ New feature (non-breaking change that adds functionality)
- [ ] 💥 Breaking change (fix or feature that would cause existing functionality to change)
- [ ] 📚 Documentation update
- [ ] 🎨 Code style/formatting
- [ ] ⚡ Performance improvement

## Testing Completed
- [ ] Manual testing with demo controller
- [ ] UIKit integration testing
- [ ] SwiftUI integration testing
- [ ] Tested on multiple iOS versions
- [ ] Tested on different device sizes
- [ ] Memory leak testing
- [ ] Performance testing on older devices

## Documentation
- [ ] README updated (if needed)
- [ ] CHANGELOG.md updated
- [ ] Inline documentation added for new public APIs
- [ ] Examples updated (if API changed)

## Screenshots/Videos
(If applicable, add screenshots or videos demonstrating the changes)
```

### Review Process

1. **Automated Checks**: Build verification must pass
2. **Code Review**: Review by maintainer(s) focusing on:
   - Code quality and Swift best practices
   - API design consistency
   - Performance implications
   - Memory management
3. **Manual Testing**: Verification on iOS 14+ devices
4. **Documentation Review**: For any public API changes
5. **Final Approval**: Approval and merge

## Release Process

### Version Numbering
We follow [Semantic Versioning](https://semver.org/):
- **Major** (2.0.0): Breaking API changes
- **Minor** (1.1.0): New features, backward compatible
- **Patch** (1.0.1): Bug fixes, backward compatible

### Release Checklist
- [ ] All tests passing
- [ ] Manual testing completed on multiple devices
- [ ] Documentation updated (README, examples, inline docs)
- [ ] CHANGELOG.md updated with release notes
- [ ] Version bumped in Package.swift
- [ ] Git tag created
- [ ] GitHub release created with release notes

## Specific Guidelines

### Adding New Components

When adding a new component type:

1. **Create the component class** in `MGCardComponent.swift` conforming to `AlertComponent`
2. **Add public API method** to `MGCard.swift` following the established pattern
3. **Update SwiftUI support** if needed in `MGCardSwiftUI.swift`
4. **Add to examples** in both UIKit and SwiftUI example files
5. **Test thoroughly** with manual testing
6. **Update documentation** with examples in README

Example new component pattern:
```swift
// 1. Component implementation
internal final class AlertCustomComponent: AlertComponent {
    func renderComponent(dismissHandler: @escaping () -> Void) -> UIView {
        // Implementation
    }
}

// 2. Public API method
public func customComponent(/* parameters */) -> MGCard {
    let component = AlertCustomComponent(/* parameters */)
    return append(component)
}

// 3. Add to examples and test
```

### SwiftUI Integration Guidelines

- Maintain full compatibility with UIKit implementation
- Use `@available` annotations appropriately for iOS version support
- Test with different SwiftUI versions (iOS 13+)
- Ensure state management works correctly with `@State` and `@Binding`
- Provide examples in `SwiftUIUsageExample.swift`

### Performance Considerations

- **Memory Management**: Use weak references appropriately, especially in closures
- **Animation Performance**: Ensure 60 FPS on iPhone 8 and iPad Air 2
- **Queue Efficiency**: Optimize multiple alert handling
- **Image Loading**: Use efficient image loading with proper fallbacks
- **Component Reuse**: Design components for reusability and minimal overhead

## Getting Help

### Questions & Support
- **GitHub Discussions**: For general questions, ideas, and feature requests
- **GitHub Issues**: For bugs, problems, and specific technical issues
- **Email**: mosa.khaldun98@gmail.com for direct maintainer contact

### Resources
- [Swift Documentation](https://swift.org/documentation/)
- [UIKit Documentation](https://developer.apple.com/documentation/uikit)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [iOS Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/ios)
- [Swift Package Manager](https://swift.org/package-manager/)

## Recognition

Contributors are recognized in:
- GitHub contributor list
- CHANGELOG.md for significant contributions
- Release notes for major features
- Special mentions for exceptional contributions

Thank you for contributing to MGCard! 🚀

---

*This guide is living documentation and will be updated as the project evolves.* 
