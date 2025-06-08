//
//  SwiftUIUsageExample.swift
//  MGCard
//
//  Created by Miswag on 08/06/2025.
//

import SwiftUI
import MGCard

/// Usage patterns and examples for MGCard in SwiftUI applications
/// This file demonstrates common patterns and best practices for integrating MGCard with SwiftUI
/// Copy these patterns into your own SwiftUI views as needed

// MARK: - Basic Usage Patterns
struct BasicSwiftUIPatterns {
    
    /// Simple alert pattern
    struct SimpleAlertPattern: View {
        @State private var showAlert = false
        
        var body: some View {
            Button("Show Simple Alert") {
                showAlert = true
            }
            .mgCard(isPresented: $showAlert) { card in
                card
                    .text(title: "Hello, SwiftUI!")
                    .action(title: "OK", style: .filled(color: .systemBlue), width: .dynamic)
            }
        }
    }
    
    /// Image alert pattern
    struct ImageAlertPattern: View {
        @State private var showAlert = false
        
        var body: some View {
            Button("Show Achievement") {
                showAlert = true
            }
            .mgCard(isPresented: $showAlert) { card in
                card
                    .image(name: "star.fill", width: 60, height: 60)
                    .text(
                        title: "Achievement Unlocked!",
                        titleFont: .boldSystemFont(ofSize: 18),
                        titleColor: .systemGold,
                        subtitle: "You've completed your first task"
                    )
                    .action(title: "Continue", style: .filled(color: .systemGreen), width: .dynamic)
            }
        }
    }
    
    /// Multiple actions pattern
    struct MultipleActionsPattern: View {
        @State private var showAlert = false
        @State private var result = ""
        
        var body: some View {
            VStack {
                Button("Save Changes Dialog") {
                    showAlert = true
                }
                
                if !result.isEmpty {
                    Text("Result: \(result)")
                        .foregroundColor(.secondary)
                }
            }
            .mgCard(isPresented: $showAlert) { card in
                card
                    .text(title: "Save Changes?", subtitle: "You have unsaved changes.")
                    .action(title: "Save", style: .filled(color: .systemBlue), width: .dynamic) {
                        result = "Saved"
                    }
                    .action(title: "Discard", style: .outlined(color: .systemRed), width: .dynamic) {
                        result = "Discarded"
                    }
                    .action(title: "Cancel", style: .clear(color: .systemGray), width: .dynamic)
            }
        }
    }
}

// MARK: - Input Patterns
struct InputPatterns {
    
    /// Text input with state binding
    struct TextInputPattern: View {
        @State private var showAlert = false
        @State private var userName = ""
        
        var body: some View {
            VStack {
                Button("Enter Name") {
                    showAlert = true
                }
                
                if !userName.isEmpty {
                    Text("Name: \(userName)")
                        .foregroundColor(.secondary)
                }
            }
            .mgCard(isPresented: $showAlert) { card in
                card
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
                        // In a real app, you'd capture the text input value
                        userName = "User Name"
                    }
                    .action(title: "Cancel", style: .clear(color: .systemGray), width: .dynamic)
            }
        }
    }
    
    /// Form validation pattern
    struct FormValidationPattern: View {
        @State private var showAlert = false
        @State private var email = ""
        @State private var isValidEmail = false
        
        var body: some View {
            VStack(spacing: 16) {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: email) { value in
                        isValidEmail = value.contains("@") && value.contains(".")
                    }
                
                Button("Validate Email") {
                    if isValidEmail {
                        print("Valid email: \(email)")
                    } else {
                        showAlert = true
                    }
                }
                .disabled(!isValidEmail)
            }
            .padding()
            .mgCard(isPresented: $showAlert) { card in
                card
                    .image(name: "exclamationmark.triangle", width: 40, height: 40)
                    .text(title: "Invalid Email", subtitle: "Please enter a valid email address")
                    .action(title: "OK", style: .filled(color: .systemOrange), width: .dynamic)
            }
        }
    }
}

// MARK: - Feedback Patterns
struct FeedbackPatterns {
    
    /// Success feedback pattern
    struct SuccessPattern: View {
        @State private var showSuccess = false
        
        var body: some View {
            Button("Show Success") {
                showSuccess = true
            }
            .mgCard(isPresented: $showSuccess) { card in
                card
                    .image(name: "checkmark.circle.fill", width: 50, height: 50)
                    .text(
                        title: "Success!",
                        titleFont: .boldSystemFont(ofSize: 20),
                        titleColor: .systemGreen,
                        subtitle: "Your operation completed successfully"
                    )
                    .action(title: "Great!", style: .filled(color: .systemGreen), width: .dynamic)
            }
        }
    }
    
    /// Error handling pattern
    struct ErrorPattern: View {
        @State private var showError = false
        
        var body: some View {
            Button("Show Error") {
                showError = true
            }
            .mgCard(isPresented: $showError) { card in
                card
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
            }
        }
    }
    
    /// Loading and network operation pattern
    struct NetworkOperationPattern: View {
        @State private var isLoading = false
        @State private var showSuccess = false
        @State private var showError = false
        
        var body: some View {
            VStack(spacing: 20) {
                Button("Perform Network Operation") {
                    performNetworkOperation()
                }
                .disabled(isLoading)
                
                if isLoading {
                    ProgressView("Loading...")
                }
            }
            .mgCard(isPresented: $showSuccess) { card in
                card
                    .image(name: "checkmark.circle.fill", width: 50, height: 50)
                    .text(title: "Success!", subtitle: "Operation completed successfully")
                    .action(title: "Continue", style: .filled(color: .systemGreen), width: .dynamic)
            }
            .mgCard(isPresented: $showError) { card in
                card
                    .image(name: "xmark.circle.fill", width: 50, height: 50)
                    .text(title: "Error", subtitle: "Operation failed")
                    .action(title: "Retry", style: .filled(color: .systemRed), width: .dynamic) {
                        performNetworkOperation()
                    }
                    .action(title: "Cancel", style: .clear(color: .systemGray), width: .dynamic)
            }
        }
        
        private func performNetworkOperation() {
            isLoading = true
            
            // Simulate network operation
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                isLoading = false
                
                // Simulate random success/failure
                if Bool.random() {
                    showSuccess = true
                } else {
                    showError = true
                }
            }
        }
    }
}

// MARK: - Advanced Patterns
struct AdvancedPatterns {
    
    /// State-based conditional alerts
    struct ConditionalAlertPattern: View {
        @State private var isLoggedIn = false
        @State private var showLoginPrompt = false
        @State private var showWelcome = false
        
        var body: some View {
            VStack(spacing: 20) {
                Text("Status: \(isLoggedIn ? "Logged In" : "Logged Out")")
                
                Button("Access Protected Feature") {
                    if isLoggedIn {
                        showWelcome = true
                    } else {
                        showLoginPrompt = true
                    }
                }
            }
            .mgCard(isPresented: $showLoginPrompt) { card in
                card
                    .image(name: "person.circle", width: 50, height: 50)
                    .text(title: "Login Required", subtitle: "Please log in to access this feature")
                    .action(title: "Log In", style: .filled(color: .systemBlue), width: .dynamic) {
                        isLoggedIn = true
                        showWelcome = true
                    }
                    .action(title: "Cancel", style: .clear(color: .systemGray), width: .dynamic)
            }
            .mgCard(isPresented: $showWelcome) { card in
                card
                    .image(name: "checkmark.circle.fill", width: 50, height: 50)
                    .text(title: "Welcome!", subtitle: "You have successfully accessed the feature")
                    .action(title: "Continue", style: .filled(color: .systemGreen), width: .dynamic)
            }
        }
    }
    
    /// Custom dismiss button pattern
    struct DismissButtonPattern: View {
        @State private var showAlert = false
        
        var body: some View {
            Button("Show Dismissible Alert") {
                showAlert = true
            }
            .mgCard(
                isPresented: $showAlert,
                dismissButtonCompletion: {
                    print("Custom dismiss action from SwiftUI!")
                }
            ) { card in
                card
                    .text(
                        title: "Info Alert",
                        subtitle: "Tap the X button to dismiss with custom action"
                    )
                    .action(title: "Got it", style: .filled(color: .systemBlue), width: .dynamic)
            }
        }
    }
    
    /// List interaction pattern
    struct ListActionsPattern: View {
        @State private var items = ["Item 1", "Item 2", "Item 3", "Item 4"]
        @State private var showDeleteConfirmation = false
        @State private var itemToDelete: String?
        
        var body: some View {
            NavigationView {
                List {
                    ForEach(items, id: \.self) { item in
                        HStack {
                            Text(item)
                            Spacer()
                            Button("Delete") {
                                itemToDelete = item
                                showDeleteConfirmation = true
                            }
                            .foregroundColor(.red)
                        }
                    }
                }
                .navigationTitle("My Items")
            }
            .mgCard(isPresented: $showDeleteConfirmation) { card in
                card
                    .text(
                        title: "Delete \(itemToDelete ?? "Item")?",
                        subtitle: "This action cannot be undone."
                    )
                    .action(title: "Delete", style: .filled(color: .systemRed), width: .dynamic) {
                        if let item = itemToDelete {
                            items.removeAll { $0 == item }
                        }
                    }
                    .action(title: "Cancel", style: .clear(color: .systemGray), width: .dynamic)
            }
        }
    }
    
    /// Settings menu pattern
    struct SettingsMenuPattern: View {
        @State private var showSettings = false
        
        var body: some View {
            Button("Open Settings") {
                showSettings = true
            }
            .mgCard(isPresented: $showSettings) { card in
                card
                    .text(title: "Settings")
                    .action(
                        title: "Notifications",
                        style: .outlined(color: .systemBlue),
                        width: .dynamic,
                        icon: "bell",
                        canDismissAlert: false
                    ) {
                        print("Navigate to notifications")
                    }
                    .action(
                        title: "Privacy",
                        style: .outlined(color: .systemGreen),
                        width: .dynamic,
                        icon: "lock",
                        canDismissAlert: false
                    ) {
                        print("Navigate to privacy")
                    }
                    .action(title: "Close", style: .clear(color: .systemGray), width: .dynamic)
            }
        }
    }
}

// MARK: - Usage in Real Views
struct ExampleUsageView: View {
    @State private var showWelcome = false
    @State private var showLogout = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("My App")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Button("Logout") {
                showLogout = true
            }
        }
        .onAppear {
            // Show welcome on first appearance
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                showWelcome = true
            }
        }
        .mgCard(isPresented: $showWelcome) { card in
            card
                .image(name: "hand.wave.fill", width: 50, height: 50)
                .text(title: "Welcome Back!", subtitle: "Ready to get started?")
                .action(title: "Let's Go", style: .filled(color: .systemBlue), width: .dynamic)
        }
        .mgCard(isPresented: $showLogout) { card in
            card
                .text(title: "Logout?", subtitle: "Are you sure you want to logout?")
                .action(title: "Logout", style: .filled(color: .systemRed), width: .dynamic) {
                    print("User logged out")
                }
                .action(title: "Cancel", style: .clear(color: .systemGray), width: .dynamic)
        }
    }
}

// MARK: - Demo View for Testing
struct SwiftUIUsagePatternsDemo: View {
    var body: some View {
        NavigationView {
            List {
                Section("Basic Patterns") {
                    NavigationLink("Simple Alert", destination: BasicSwiftUIPatterns.SimpleAlertPattern())
                    NavigationLink("Image Alert", destination: BasicSwiftUIPatterns.ImageAlertPattern())
                    NavigationLink("Multiple Actions", destination: BasicSwiftUIPatterns.MultipleActionsPattern())
                }
                
                Section("Input Patterns") {
                    NavigationLink("Text Input", destination: InputPatterns.TextInputPattern())
                    NavigationLink("Form Validation", destination: InputPatterns.FormValidationPattern())
                }
                
                Section("Feedback Patterns") {
                    NavigationLink("Success", destination: FeedbackPatterns.SuccessPattern())
                    NavigationLink("Error", destination: FeedbackPatterns.ErrorPattern())
                    NavigationLink("Network Operation", destination: FeedbackPatterns.NetworkOperationPattern())
                }
                
                Section("Advanced Patterns") {
                    NavigationLink("Conditional Alert", destination: AdvancedPatterns.ConditionalAlertPattern())
                    NavigationLink("Dismiss Button", destination: AdvancedPatterns.DismissButtonPattern())
                    NavigationLink("List Actions", destination: AdvancedPatterns.ListActionsPattern())
                    NavigationLink("Settings Menu", destination: AdvancedPatterns.SettingsMenuPattern())
                }
            }
            .navigationTitle("MGCard SwiftUI Patterns")
        }
    }
}
