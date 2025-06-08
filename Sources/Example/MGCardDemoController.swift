//
//  MGCardDemoController.swift
//  MGCard
//
//  Created by Miswag on 05/06/2025.
//

import UIKit
import MGCard

public class MGCardDemoController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupButtons()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "MGCard Variations Test"
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        scrollView.addSubview(stackView)
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
    }
    
    private func setupButtons() {
        let buttonConfigs: [(title: String, color: UIColor, action: () -> Void)] = [
            ("Simple Text Alert", .systemBlue, showSimpleTextAlert),
            ("Multi-Text Alert", .systemGreen, showMultiTextAlert),
            ("Alert with Image", .systemPurple, showImageAlert),
            ("Single Action Alert", .systemOrange, showSingleActionAlert),
            ("Multiple Actions Alert", .systemRed, showMultipleActionsAlert),
            ("Text Input Alert", .systemTeal, showTextInputAlert),
            ("Complex Alert", .systemPink, showComplexAlert),
            ("Success Alert", .systemGreen, showSuccessAlert),
            ("Warning Alert", .systemYellow, showWarningAlert),
            ("Error Alert", .systemRed, showErrorAlert),
            ("Info Alert", .systemBlue, showInfoAlert),
            ("Confirmation Alert", .systemIndigo, showConfirmationAlert),
            ("Form Alert", .systemBrown, showFormAlert),
            ("Settings Alert", .systemGray, showSettingsAlert),
            ("Profile Alert", .systemCyan, showProfileAlert),
            ("Custom Styled Alert", .systemMint, showCustomStyledAlert),
            ("Dismiss Button Alert", .systemTeal, showDismissButtonAlert)
        ]
        
        for config in buttonConfigs {
            let button = createTestButton(title: config.title, color: config.color, action: config.action)
            stackView.addArrangedSubview(button)
        }
    }
    
    private func createTestButton(title: String, color: UIColor, action: @escaping () -> Void) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = color
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        button.addAction(UIAction { _ in action() }, for: .touchUpInside)
        
        return button
    }
    
    // MARK: - Alert Variations
    
    private func showSimpleTextAlert() {
        MGCard()
            .text(
                title: "Hello World!",
                titleFont: .boldSystemFont(ofSize: 18),
                titleAlignment: .center
            )
            .action(
                title: "OK",
                style: .filled(color: .systemBlue),
                width: .dynamic
            )
            .show()
    }
    
    private func showMultiTextAlert() {
        MGCard()
            .text(
                title: "Welcome!",
                titleFont: .boldSystemFont(ofSize: 20),
                titleColor: .label,
                titleAlignment: .center,
                subtitle: "This is a multi-text alert with multiple lines of information",
                subtitleFont: .systemFont(ofSize: 16),
                subtitleColor: .secondaryLabel,
                subtitleAlignment: .center,
                spacing: 8
            )
            .action(
                title: "Got it!",
                style: .filled(color: .systemGreen),
                width: .dynamic
            )
            .show()
    }
    
    private func showImageAlert() {
        MGCard()
            .image(
                name: "star.fill",
                width: 60,
                height: 60
            )
            .text(
                title: "Congratulations!",
                titleFont: .boldSystemFont(ofSize: 18),
                titleAlignment: .center,
                subtitle: "You've earned a star!",
                subtitleFont: .systemFont(ofSize: 14),
                subtitleColor: .secondaryLabel,
                subtitleAlignment: .center
            )
            .action(
                title: "Close",
                style: .filled(color: .systemYellow),
                width: .dynamic
            )
            .show()
    }
    
    private func showSingleActionAlert() {
        MGCard()
            .text(
                title: "Single Action Alert",
                titleFont: .boldSystemFont(ofSize: 16),
                titleAlignment: .center
            )
            .action(
                title: "Tap me!",
                style: .filled(color: .systemPurple),
                width: .dynamic
            ) {
                print("Single action tapped!")
            }
            .show()
    }
    
    private func showMultipleActionsAlert() {
        MGCard()
            .text(
                title: "Choose an option",
                titleFont: .boldSystemFont(ofSize: 16),
                titleAlignment: .center
            )
            .action(
                title: "Primary",
                style: .filled(color: .systemBlue),
                width: .dynamic
            ) {
                print("Primary action tapped!")
            }
            .action(
                title: "Secondary",
                style: .outlined(color: .systemBlue),
                width: .dynamic
            ) {
                print("Secondary action tapped!")
            }
            .action(
                title: "Cancel",
                style: .clear(color: .systemRed),
                width: .dynamic
            ) {
                print("Cancel action tapped!")
            }
            .show()
    }
    
    private func showTextInputAlert() {
        MGCard()
            .text(
                title: "Enter your feedback",
                titleFont: .boldSystemFont(ofSize: 16),
                titleAlignment: .center
            )
            .textInput(
                placeholder: "Type your message here...",
                subtitle: "Your feedback helps us improve",
                onTextChange: { text in
                    print("Text changed: \(text ?? "nil")")
                }
            )
            .action(
                title: "Submit",
                style: .filled(color: .systemGreen),
                width: .dynamic
            ) {
                print("Feedback submitted!")
            }
            .action(
                title: "Cancel",
                style: .clear(color: .systemGray),
                width: .dynamic
            )
            .show()
    }
    
    private func showComplexAlert() {
        MGCard()
            .image(
                name: "exclamationmark.triangle.fill",
                width: 50,
                height: 50
            )
            .text(
                title: "Complex Alert",
                titleFont: .boldSystemFont(ofSize: 20),
                titleAlignment: .center
            )
            .text(
                title: "This is a complex alert with multiple components",
                titleFont: .systemFont(ofSize: 14),
                titleColor: .secondaryLabel,
                titleAlignment: .center,
                subtitle: "Including image, text, input, and actions",
                subtitleFont: .systemFont(ofSize: 12),
                subtitleColor: .tertiaryLabel,
                subtitleAlignment: .center,
                spacing: 4
            )
            .textInput(
                placeholder: "Enter details...",
                subtitle: "Additional information (optional)"
            )
            .action(
                title: "Confirm",
                style: .filled(color: .systemRed),
                width: .dynamic,
                icon: "checkmark"
            ) {
                print("Complex action confirmed!")
            }
            .action(
                title: "More Info",
                style: .outlined(color: .systemBlue),
                width: .dynamic,
                icon: "info.circle",
                canDismissAlert: false
            ) {
                print("More info requested!")
            }
            .show()
    }
    
    private func showSuccessAlert() {
        MGCard()
            .image(
                name: "checkmark.circle.fill",
                width: 60,
                height: 60
            )
            .text(
                title: "Success!",
                titleFont: .boldSystemFont(ofSize: 22),
                titleColor: .systemGreen,
                titleAlignment: .center,
                subtitle: "Your operation completed successfully",
                subtitleFont: .systemFont(ofSize: 14),
                subtitleColor: .secondaryLabel,
                subtitleAlignment: .center,
                spacing: 6
            )
            .action(
                title: "Great!",
                style: .filled(color: .systemGreen),
                width: .dynamic,
                icon: "hand.thumbsup"
            )
            .show()
    }
    
    private func showWarningAlert() {
        MGCard()
            .image(
                name: "exclamationmark.triangle.fill",
                width: 60,
                height: 60
            )
            .text(
                title: "Warning",
                titleFont: .boldSystemFont(ofSize: 20),
                titleColor: .systemOrange,
                titleAlignment: .center,
                subtitle: "This action cannot be undone",
                subtitleFont: .systemFont(ofSize: 14),
                subtitleColor: .secondaryLabel,
                subtitleAlignment: .center,
                spacing: 6
            )
            .action(
                title: "Proceed Anyway",
                style: .filled(color: .systemOrange),
                width: .dynamic
            ) {
                print("Proceeded with warning!")
            }
            .action(
                title: "Cancel",
                style: .outlined(color: .systemGray),
                width: .dynamic
            )
            .show()
    }
    
    private func showErrorAlert() {
        MGCard()
            .image(
                name: "xmark.circle.fill",
                width: 60,
                height: 60
            )
            .text(
                title: "Error",
                titleFont: .boldSystemFont(ofSize: 20),
                titleColor: .systemRed,
                titleAlignment: .center,
                subtitle: "Something went wrong. Please try again.",
                subtitleFont: .systemFont(ofSize: 14),
                subtitleColor: .secondaryLabel,
                subtitleAlignment: .center,
                spacing: 6
            )
            .action(
                title: "Retry",
                style: .filled(color: .systemRed),
                width: .dynamic,
                icon: "arrow.clockwise"
            ) {
                print("Retry requested!")
            }
            .action(
                title: "Cancel",
                style: .clear(color: .systemGray),
                width: .dynamic
            )
            .show()
    }
    
    private func showInfoAlert() {
        MGCard()
            .image(
                name: "info.circle.fill",
                width: 50,
                height: 50
            )
            .text(
                title: "Information",
                titleFont: .boldSystemFont(ofSize: 18),
                titleColor: .systemBlue,
                titleAlignment: .center
            )
            .text(
                title: "Here's some important information you should know about this feature.",
                titleFont: .systemFont(ofSize: 14),
                titleColor: .secondaryLabel,
                titleAlignment: .left,
                spacing: 8
            )
            .text(
                title: "• Feature A is now available\n• Bug fixes and improvements\n• Enhanced user experience",
                titleFont: .systemFont(ofSize: 12),
                titleColor: .label,
                titleAlignment: .left
            )
            .action(
                title: "Got it",
                style: .filled(color: .systemBlue),
                width: .dynamic
            )
            .show()
    }
    
    private func showConfirmationAlert() {
        MGCard()
            .text(
                title: "Confirm Action",
                titleFont: .boldSystemFont(ofSize: 18),
                titleAlignment: .center,
                subtitle: "Are you sure you want to delete this item? This action cannot be undone.",
                subtitleFont: .systemFont(ofSize: 14),
                subtitleColor: .secondaryLabel,
                subtitleAlignment: .center,
                spacing: 8
            )
            .action(
                title: "Delete",
                style: .filled(color: .systemRed),
                width: .fixed(120),
                icon: "trash"
            ) {
                print("Item deleted!")
            }
            .action(
                title: "Cancel",
                style: .outlined(color: .systemGray),
                width: .fixed(120)
            )
            .show()
    }
    
    private func showFormAlert() {
        MGCard()
            .text(
                title: "Quick Form",
                titleFont: .boldSystemFont(ofSize: 18),
                titleAlignment: .center
            )
            .textInput(
                placeholder: "Enter your name...",
                subtitle: "Full name required"
            )
            .textInput(
                placeholder: "Enter your email...",
                subtitle: "We'll never share your email"
            )
            .action(
                title: "Submit Form",
                style: .filled(color: .systemBlue),
                width: .dynamic,
                icon: "paperplane"
            ) {
                print("Form submitted!")
            }
            .show()
    }
    
    private func showSettingsAlert() {
        MGCard()
            .text(
                title: "Settings",
                titleFont: .boldSystemFont(ofSize: 18),
                titleAlignment: .center
            )
            .action(
                title: "Notifications",
                style: .outlined(color: .systemBlue),
                width: .dynamic,
                icon: "bell",
                canDismissAlert: false
            ) {
                print("Notifications settings opened!")
            }
            .action(
                title: "Privacy",
                style: .outlined(color: .systemGreen),
                width: .dynamic,
                icon: "lock",
                canDismissAlert: false
            ) {
                print("Privacy settings opened!")
            }
            .action(
                title: "Account",
                style: .outlined(color: .systemOrange),
                width: .dynamic,
                icon: "person.circle",
                canDismissAlert: false
            ) {
                print("Account settings opened!")
            }
            .action(
                title: "Close",
                style: .clear(color: .systemGray),
                width: .dynamic
            )
            .show()
    }
    
    private func showProfileAlert() {
        MGCard()
            .image(
                name: "person.circle.fill",
                width: 80,
                height: 80
            )
            .text(
                title: "John Doe",
                titleFont: .boldSystemFont(ofSize: 20),
                titleAlignment: .center,
                subtitle: "john.doe@example.com",
                subtitleFont: .systemFont(ofSize: 14),
                subtitleColor: .secondaryLabel,
                subtitleAlignment: .center,
                spacing: 4
            )
            .text(
                title: "iOS Developer",
                titleFont: .systemFont(ofSize: 12),
                titleColor: .tertiaryLabel,
                titleAlignment: .center
            )
            .action(
                title: "Edit Profile",
                style: .filled(color: .systemBlue),
                width: .dynamic,
                icon: "pencil"
            ) {
                print("Edit profile tapped!")
            }
            .action(
                title: "Logout",
                style: .outlined(color: .systemRed),
                width: .dynamic,
                icon: "rectangle.portrait.and.arrow.right"
            ) {
                print("Logout tapped!")
            }
            .show()
    }
    
    private func showCustomStyledAlert() {
        MGCard()
            .hasDismissButton(true)
            .image(
                name: "sparkles",
                width: 70,
                height: 70
            )
            .text(
                title: "🎉 Custom Styled Alert 🎉",
                titleFont: .boldSystemFont(ofSize: 18),
                titleColor: .systemPink,
                titleAlignment: .center,
                subtitle: "This alert showcases custom styling options",
                subtitleFont: .italicSystemFont(ofSize: 14),
                subtitleColor: .systemPurple,
                subtitleAlignment: .center,
                spacing: 10
            )
            .action(
                title: "Awesome!",
                style: .filled(color: .systemPink),
                width: .dynamic,
                height: 44,
                icon: "heart.fill"
            ) {
                print("Custom styled action!")
            }
            .action(
                title: "Cool Design",
                style: .outlined(color: .systemPurple),
                width: .dynamic,
                height: 44,
                icon: "paintbrush.fill"
            ) {
                print("Cool design action!")
            }
            .show()
    }
    
    private func showDismissButtonAlert() {
        MGCard()
            .hasDismissButton(true)
            .dismissButtonAction {
                print("Dismiss button tapped!")
            }
            .image(
                name: "info.circle",
                width: 50,
                height: 50
            )
            .text(
                title: "Dismiss Button Example",
                titleFont: .boldSystemFont(ofSize: 16),
                titleAlignment: .center,
                subtitle: "This alert has a dismiss button (X) in the top-right corner",
                subtitleFont: .systemFont(ofSize: 14),
                subtitleColor: .secondaryLabel,
                subtitleAlignment: .center
            )
            .action(
                title: "OK",
                style: .filled(color: .systemBlue),
                width: .dynamic
            )
            .show()
    }
}
