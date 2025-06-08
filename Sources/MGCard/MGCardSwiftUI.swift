//
//  MGCardSwiftUI.swift
//  MGCard
//
//  Created by Mosa Khaldun on 04/06/2025.
//

import SwiftUI

// MARK: - Infix Operator Declaration

/// Pipe operator for functional composition
infix operator |>: MultiplicationPrecedence

// MARK: - MGCardView

/// SwiftUI wrapper for MGCard that integrates with SwiftUI's state management
/// 
/// MGCardView provides a declarative SwiftUI interface for presenting MGCard instances
/// with automatic state binding and lifecycle management.
/// 
/// ## Usage
/// ```swift
/// @State private var showCard = false
/// 
/// var body: some View {
///     Button("Show Card") { showCard = true }
///         .mgCard(isPresented: $showCard) { card in
///             card
///                 .text(title: "Hello SwiftUI!")
///                 .action(title: "OK", style: .filled(color: .blue), width: .dynamic)
///         }
/// }
/// ```

public struct MGCardView: View {
    
    // MARK: - Properties
    
    @Binding private var isPresented: Bool
    private var showDismissButton: Bool
    private var dismissButtonCompletion: (() -> Void)?
    private var cardBuilder: (MGCard) -> MGCard
    
    // MARK: - Initialization
    
    /// Creates a new MGCardView with SwiftUI state binding
    /// - Parameters:
    ///   - isPresented: Binding to control the card's visibility
    ///   - showDismissButton: Whether to show the dismiss (X) button (default: true)
    ///   - dismissButtonCompletion: Optional closure called when dismiss button is tapped
    ///   - content: Result builder closure for configuring the card
    public init(
        isPresented: Binding<Bool>,
        showDismissButton: Bool = true,
        dismissButtonCompletion: (() -> Void)? = nil,
        @MGCardBuilder content: @escaping (MGCard) -> MGCard
    ) {
        self._isPresented = isPresented
        self.showDismissButton = showDismissButton
        self.dismissButtonCompletion = dismissButtonCompletion
        self.cardBuilder = content
    }
    
    // MARK: - View Body
    
    public var body: some View {
        EmptyView()
            .onChange(of: isPresented) { newValue in
                if newValue {
                    presentCard()
                }
            }
            .onAppear {
                if isPresented {
                    presentCard()
                }
            }
    }
    
    // MARK: - Private Methods
    
    private func presentCard() {
        let alertView = createConfiguredCard()
        setupDismissCallback(for: alertView)
        alertView.show()
    }
    
    private func createConfiguredCard() -> MGCard {
        let baseCard = MGCard()
            .hasDismissButton(showDismissButton)
            .dismissButtonAction {
                dismissButtonCompletion?()
            }
        return cardBuilder(baseCard)
    }
    
    private func setupDismissCallback(for card: MGCard) {
        card.onDismiss = {
            DispatchQueue.main.async {
                self.isPresented = false
            }
        }
    }
}

// MARK: - MGCardBuilder

/// Result builder for creating MGCard configurations with declarative syntax
/// 
/// This result builder enables the clean, declarative syntax for configuring
/// MGCard instances within SwiftUI views.
/// 
/// ## Example
/// ```swift
/// @MGCardBuilder
/// func buildCard() -> MGCard {
///     MGCard()
///         .text(title: "Welcome")
///         .action(title: "Continue", style: .filled(color: .blue), width: .dynamic)
/// }
/// ```
@resultBuilder
public struct MGCardBuilder {
    /// Builds a single MGCard configuration
    /// - Parameter card: The configured MGCard instance
    /// - Returns: The same MGCard instance for method chaining
    public static func buildBlock(_ card: MGCard) -> MGCard {
        return card
    }
}

// MARK: - View Extension

public extension View {
    
    /// Presents an MGCard modally when the provided binding becomes true
    /// 
    /// This modifier integrates MGCard with SwiftUI's declarative state management,
    /// automatically presenting and dismissing the card based on the binding state.
    /// 
    /// - Parameters:
    ///   - isPresented: Binding that controls when the card is shown
    ///   - showDismissButton: Whether to display the dismiss (X) button (default: true)
    ///   - dismissButtonCompletion: Optional closure executed when dismiss button is tapped
    ///   - content: Result builder closure for configuring the card's content
    /// - Returns: A modified view that can present MGCard modally
    /// 
    /// ## Usage
    /// ```swift
    /// ContentView()
    ///     .mgCard(isPresented: $showAlert) { card in
    ///         card
    ///             .image(name: "checkmark.circle", width: 60, height: 60)
    ///             .text(title: "Success!", subtitle: "Your action completed successfully")
    ///             .action(title: "Continue", style: .filled(color: .green), width: .dynamic)
    ///     }
    /// ```
    func mgCard(
        isPresented: Binding<Bool>,
        showDismissButton: Bool = true,
        dismissButtonCompletion: (() -> Void)? = nil,
        @MGCardBuilder content: @escaping (MGCard) -> MGCard
    ) -> some View {
        self.background(
            MGCardView(
                isPresented: isPresented,
                showDismissButton: showDismissButton,
                dismissButtonCompletion: dismissButtonCompletion,
                content: content
            )
            .opacity(0) // Hidden background view that handles presentation
        )
    }
}

// MARK: - Helper Operators

/// Pipe operator for functional composition
/// This enables cleaner functional-style code composition
func |> <T, U>(value: T, function: (T) -> U) -> U {
    return function(value)
} 
