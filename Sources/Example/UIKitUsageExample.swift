//
//  UIKitUsageExample.swift
//  MGCard
//
//  Created by Miswag on 08/06/2025.
//

import UIKit
import MGCard

/// Usage patterns and examples for MGCard in UIKit applications
/// This file demonstrates common patterns and best practices for integrating MGCard
/// Copy these patterns into your own UIKit view controllers as needed
class UIKitUsagePatterns {
    
    // MARK: - Basic Usage Patterns
    
    /// Simplest possible MGCard usage
    static func showBasicAlert() {
        MGCard()
            .text(title: "Hello, World!")
            .action(title: "OK", style: .filled(color: .systemBlue), width: .dynamic)
            .show()
    }
    
    /// Alert with image and styled text
    static func showImageAlert() {
        MGCard()
            .image(name: "star.fill", width: 60, height: 60)
            .text(
                title: "Achievement Unlocked!",
                titleFont: .boldSystemFont(ofSize: 18),
                titleColor: .systemGold,
                subtitle: "You've completed your first task"
            )
            .action(title: "Continue", style: .filled(color: .systemGreen), width: .dynamic)
            .show()
    }
    
    /// Multiple action buttons with different styles
    static func showMultipleActionsAlert() {
        MGCard()
            .text(title: "Save Changes?", subtitle: "You have unsaved changes.")
            .action(title: "Save", style: .filled(color: .systemBlue), width: .dynamic) {
                print("Saved!")
            }
            .action(title: "Discard", style: .outlined(color: .systemRed), width: .dynamic) {
                print("Discarded!")
            }
            .action(title: "Cancel", style: .clear(color: .systemGray), width: .dynamic)
            .show()
    }
    
    // MARK: - User Input Patterns
    
    /// Single text input with validation
    static func showTextInputPattern() {
        MGCard()
            .text(title: "Enter Your Name")
            .textInput(
                placeholder: "Full name...",
                subtitle: "This will be displayed on your profile",
                onTextChange: { text in
                    // Real-time validation
                    if let text = text, text.count > 2 {
                        print("Valid name: \(text)")
                    }
                }
            )
            .action(title: "Save", style: .filled(color: .systemBlue), width: .dynamic) {
                print("Profile updated!")
            }
            .action(title: "Cancel", style: .clear(color: .systemGray), width: .dynamic)
            .show()
    }
    
    /// Form with multiple inputs
    static func showFormPattern() {
        MGCard()
            .text(title: "Contact Information")
            .textInput(placeholder: "Email address", subtitle: "Primary contact")
            .textInput(placeholder: "Phone number", subtitle: "Optional")
            .action(title: "Update", style: .filled(color: .systemBlue), width: .dynamic) {
                print("Contact info updated!")
            }
            .show()
    }
    
    // MARK: - Common UI Patterns
    
    /// Success feedback pattern
    static func showSuccessPattern() {
        MGCard()
            .image(name: "checkmark.circle.fill", width: 50, height: 50)
            .text(
                title: "Success!",
                titleFont: .boldSystemFont(ofSize: 20),
                titleColor: .systemGreen,
                subtitle: "Your operation completed successfully"
            )
            .action(title: "Great!", style: .filled(color: .systemGreen), width: .dynamic)
            .show()
    }
    
    /// Error handling pattern
    static func showErrorPattern() {
        MGCard()
            .image(name: "exclamationmark.triangle.fill", width: 50, height: 50)
            .text(
                title: "Error",
                titleFont: .boldSystemFont(ofSize: 18),
                titleColor: .systemRed,
                subtitle: "Network connection failed. Please try again."
            )
            .action(title: "Retry", style: .filled(color: .systemRed), width: .dynamic) {
                print("Retrying...")
            }
            .action(title: "Cancel", style: .clear(color: .systemGray), width: .dynamic)
            .show()
    }
    
    /// Confirmation dialog pattern
    static func showConfirmationPattern() {
        MGCard()
            .text(
                title: "Delete Item?",
                titleFont: .boldSystemFont(ofSize: 16),
                subtitle: "This action cannot be undone."
            )
            .action(title: "Delete", style: .filled(color: .systemRed), width: .fixed(100)) {
                print("Item deleted")
            }
            .action(title: "Cancel", style: .outlined(color: .systemGray), width: .fixed(100))
            .show()
    }
    
    // MARK: - Advanced Patterns
    
    /// Custom styling pattern
    static func showCustomStylingPattern() {
        MGCard()
            .image(name: "paintbrush.fill", width: 70, height: 70)
            .text(
                title: "🎨 Custom Design",
                titleFont: .boldSystemFont(ofSize: 20),
                titleColor: .systemPink,
                subtitle: "This alert uses custom fonts and colors",
                subtitleFont: .italicSystemFont(ofSize: 14),
                subtitleColor: .systemPurple,
                spacing: 12
            )
            .action(
                title: "Amazing!",
                style: .filled(color: .systemPink),
                width: .dynamic,
                height: 50,
                icon: "heart.fill"
            )
            .show()
    }
    
    /// Non-dismissible actions pattern (for settings/navigation)
    static func showNonDismissiblePattern() {
        MGCard()
            .text(title: "Choose an Option")
            .action(
                title: "Settings",
                style: .outlined(color: .systemBlue),
                width: .dynamic,
                icon: "gear",
                canDismissAlert: false  // This action won't dismiss the card
            ) {
                print("Opening settings...")
                // Navigate to settings without dismissing
            }
            .action(
                title: "Help",
                style: .outlined(color: .systemGreen),
                width: .dynamic,
                icon: "questionmark.circle",
                canDismissAlert: false
            ) {
                print("Opening help...")
            }
            .action(title: "Close", style: .clear(color: .systemGray), width: .dynamic)
            .show()
    }
    
    /// Dismiss button pattern
    static func showDismissButtonPattern() {
        MGCard()
            .hasDismissButton(true)
            .dismissButtonAction {
                print("Custom dismiss button action!")
            }
            .text(
                title: "Info Alert",
                subtitle: "Tap the X button to dismiss"
            )
            .action(title: "Got it", style: .filled(color: .systemBlue), width: .dynamic)
            .show()
    }
}

// MARK: - Integration Patterns

extension UIKitUsagePatterns {
    
    /// Table view cell action pattern
    static func showTableViewDeletePattern(for indexPath: IndexPath) {
        MGCard()
            .text(
                title: "Delete Item?",
                subtitle: "This will permanently remove the item from row \(indexPath.row + 1)."
            )
            .action(title: "Delete", style: .filled(color: .systemRed), width: .dynamic) {
                // Perform delete operation
                print("Deleting item at \(indexPath)")
            }
            .action(title: "Cancel", style: .clear(color: .systemGray), width: .dynamic)
            .show()
    }
    
    /// Network operation pattern with sequential alerts
    static func showNetworkOperationPattern() {
        // Show loading alert
        MGCard()
            .text(title: "Processing...")
            .show()
        
        // Simulate network operation
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // Show success alert
            MGCard()
                .image(name: "checkmark.circle.fill", width: 50, height: 50)
                .text(title: "Upload Complete!")
                .action(title: "Continue", style: .filled(color: .systemGreen), width: .dynamic)
                .show()
        }
    }
    
    /// Onboarding flow pattern
    static func showOnboardingPattern(step: Int = 0, totalSteps: Int = 3) {
        let onboardingData = [
            ("hand.wave.fill", "Welcome!", "Let's take a quick tour of what you can do."),
            ("sparkles", "Discover Features", "Explore the powerful tools at your disposal."),
            ("rocket.fill", "Get Started", "You're all set! Start using the app.")
        ]
        
        let (icon, title, subtitle) = onboardingData[step]
        
        MGCard()
            .image(name: icon, width: 60, height: 60)
            .text(
                title: title,
                titleFont: .boldSystemFont(ofSize: 18),
                subtitle: subtitle
            )
            .action(
                title: step < totalSteps - 1 ? "Next" : "Get Started",
                style: .filled(color: .systemBlue),
                width: .dynamic
            ) {
                if step < totalSteps - 1 {
                    showOnboardingPattern(step: step + 1, totalSteps: totalSteps)
                }
            }
            .show()
    }
    
    /// Form validation pattern
    static func showFormValidationPattern() {
        var emailText = ""
        var isValidEmail = false
        
        MGCard()
            .text(title: "Enter Email")
            .textInput(
                placeholder: "email@example.com",
                subtitle: "We'll send you a confirmation",
                onTextChange: { text in
                    emailText = text ?? ""
                    isValidEmail = emailText.contains("@") && emailText.contains(".")
                    print("Email valid: \(isValidEmail)")
                }
            )
            .action(title: "Submit", style: .filled(color: .systemBlue), width: .dynamic) {
                if isValidEmail {
                    print("Valid email submitted: \(emailText)")
                } else {
                    showErrorPattern()
                }
            }
            .action(title: "Cancel", style: .clear(color: .systemGray), width: .dynamic)
            .show()
    }
    
    /// Settings menu pattern
    static func showSettingsMenuPattern() {
        MGCard()
            .text(title: "Settings")
            .action(
                title: "Notifications",
                style: .outlined(color: .systemBlue),
                width: .dynamic,
                icon: "bell",
                canDismissAlert: false
            ) {
                print("Navigate to notifications settings")
            }
            .action(
                title: "Privacy",
                style: .outlined(color: .systemGreen),
                width: .dynamic,
                icon: "lock",
                canDismissAlert: false
            ) {
                print("Navigate to privacy settings")
            }
            .action(
                title: "Account",
                style: .outlined(color: .systemOrange),
                width: .dynamic,
                icon: "person.circle",
                canDismissAlert: false
            ) {
                print("Navigate to account settings")
            }
            .action(title: "Close", style: .clear(color: .systemGray), width: .dynamic)
            .show()
    }
}

// MARK: - Usage in View Controllers

/// Example view controller showing how to integrate MGCard patterns
class ExampleViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "MGCard Examples"
        
        // Example: Show welcome message when view loads
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIKitUsagePatterns.showBasicAlert()
        }
    }
    
    // Example: Handle button tap
    @IBAction func deleteButtonTapped() {
        UIKitUsagePatterns.showConfirmationPattern()
    }
    
    // Example: Handle network error
    private func handleNetworkError() {
        UIKitUsagePatterns.showErrorPattern()
    }
    
    // Example: Show success after save
    private func showSaveSuccess() {
        UIKitUsagePatterns.showSuccessPattern()
    }
} 