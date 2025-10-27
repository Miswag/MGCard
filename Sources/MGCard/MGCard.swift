//
//  MGCard.swift
//  MGCard
//
//  Created by Mosa Khaldun on 26/11/2024.
//

import UIKit

// MARK: - MGCardManager

/// Internal manager responsible for queuing and presenting MGCard instances
/// Ensures only one card is presented at a time and manages the presentation queue
internal final class MGCardManager {
    /// Shared singleton instance
    internal static let shared = MGCardManager()
    
    // MARK: - Private Properties
    
    private var alertQueue: [MGCard] = []
    private var isPresentingAlert = false
    private let queue = DispatchQueue(label: "com.mgcard.manager.queue")
    
    // MARK: - Initialization
    
    private init() {}
    
    // MARK: - Public Methods
    
    /// Adds a card to the presentation queue
    /// - Parameter alertView: The MGCard instance to be presented
    internal func show(_ alertView: MGCard) {
        queue.sync {
            alertQueue.append(alertView)
            DispatchQueue.main.async {
                self.presentNextAlert()
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func presentNextAlert() {
        guard !isPresentingAlert, !alertQueue.isEmpty else { return }
        isPresentingAlert = true
        
        let nextAlert = alertQueue.removeFirst()
        nextAlert.showInternal {
            self.isPresentingAlert = false
            self.presentNextAlert()
        }
    }
}

// MARK: - MGCard

/// A powerful and flexible card component for iOS applications
/// 
/// MGCard provides a declarative API for creating modal card presentations with various components
/// including text, images, action buttons, and text input fields. It supports both UIKit and SwiftUI
/// with automatic queue management for multiple alerts.
/// 
/// ## Usage
/// 
/// ```swift
/// MGCard()
///     .text(title: "Welcome", subtitle: "Get started with MGCard")
///     .action(title: "Continue", style: .filled(color: .blue), width: .dynamic)
///     .show()
/// ```
public final class MGCard: UIView {
    
    // MARK: - UI Components
    
    private let dimmedBackgroundView = UIView()
    private var alertWindow: UIWindow?
    private let alertContainerStackView = UIStackView()
    private let dismissButton = UIButton(type: .system)
    
    // MARK: - Internal Properties
    
    private var components: [AlertComponent] = []
    private var dismissCompletion: (() -> Void)?
    private var dismissButtonCompletion: (() -> Void)?
    private var showDismissButton: Bool = false
    
    /// SwiftUI integration callback for dismiss events
    internal var onDismiss: (() -> Void)?
    
    // MARK: - Initialization
    
    /// Creates a new MGCard instance with default configuration
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupCard()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Convenience initializer for creating a card with zero frame
    public convenience init() {
        self.init(frame: .zero)
    }
    
    // MARK: - Internal Methods
    
    /// Appends a component to the card's component list
    /// - Parameter component: The component to be added
    /// - Returns: Self for method chaining
    @discardableResult
    internal func append(_ component: AlertComponent) -> MGCard {
        components.append(component)
        return self
    }
    
    // MARK: - Public Configuration API
    
    /// Configures whether the dismiss button (X) should be shown
    /// - Parameter show: Boolean indicating if the dismiss button should be visible
    /// - Returns: Self for method chaining
    @discardableResult
    public func hasDismissButton(_ show: Bool) -> MGCard {
        self.showDismissButton = show
        return self
    }
    
    /// Sets the action to be performed when the dismiss button is tapped
    /// - Parameter action: Closure to execute when dismiss button is tapped
    /// - Returns: Self for method chaining
    @discardableResult
    public func dismissButtonAction(_ action: @escaping () -> Void) -> MGCard {
        self.dismissButtonCompletion = action
        return self
    }
    
    // MARK: - Component API
    
    /// Adds an image component to the card
    /// - Parameters:
    ///   - name: The name of the image (system icon or asset name)
    ///   - width: The width of the image in points
    ///   - height: The height of the image in points
    ///   - scale: The content mode for image scaling (default: .scaleAspectFill)
    ///   - renderingMode: The rendering mode for the image (default: .alwaysOriginal)
    ///   - tintColor: Optional tint color for the image (works best with .alwaysTemplate rendering mode)
    /// - Returns: Self for method chaining
    @discardableResult
    public func image(
        name: String,
        width: CGFloat,
        height: CGFloat,
        scale: UIView.ContentMode = .scaleAspectFill,
        renderingMode: UIImage.RenderingMode = .alwaysOriginal,
        tintColor: UIColor? = nil
    ) -> MGCard {
        let imageComponent = AlertImage(
            imageName: name,
            imageScale: scale,
            imageWidth: width,
            imageHeight: height,
            renderingMode: renderingMode,
            tintColor: tintColor
        )
        return append(imageComponent)
    }
    
    /// Adds a text component with optional title and subtitle
    /// - Parameters:
    ///   - title: The main text to display
    ///   - titleFont: Optional font for the title text
    ///   - titleColor: Optional color for the title text
    ///   - titleAlignment: Optional text alignment for the title
    ///   - subtitle: Optional subtitle text
    ///   - subtitleFont: Optional font for the subtitle text
    ///   - subtitleColor: Optional color for the subtitle text
    ///   - subtitleAlignment: Optional text alignment for the subtitle
    ///   - spacing: Vertical spacing between title and subtitle (default: 1)
    /// - Returns: Self for method chaining
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
    ) -> MGCard {
        let textComponent = AlertText(spacing: spacing)
            .addText(
                text: title,
                font: titleFont,
                color: titleColor,
                alignment: titleAlignment
            )
        
        if let subtitle = subtitle {
            textComponent.addText(
                text: subtitle,
                font: subtitleFont,
                color: subtitleColor,
                alignment: subtitleAlignment
            )
        }
        
        return append(textComponent)
    }
    
    /// Adds an action button component to the card
    /// - Parameters:
    ///   - title: The button title text
    ///   - style: The visual style of the button
    ///   - width: The width configuration of the button
    ///   - height: The height of the button in points (default: 35)
    ///   - icon: Optional SF Symbol icon name
    ///   - canDismissAlert: Whether tapping this button should dismiss the card (default: true)
    ///   - font: The font for the button title (defaults to system font, medium weight, size 16)
    ///   - action: Optional closure to execute when button is tapped
    /// - Returns: Self for method chaining
    @discardableResult
    public func action(
        title: String,
        style: ButtonStyle,
        width: WidthStyle,
        height: CGFloat = 35,
        icon: String? = nil,
        canDismissAlert: Bool = true,
        font: UIFont? = nil,
        action: (() -> Void)? = nil
    ) -> MGCard {
        let internalStyle: AlertAction.ButtonStyle = {
            switch style {
            case .filled(let color): return .filled(color: color)
            case .outlined(let color): return .outlined(color: color)
            case .clear(let color): return .clear(color: color)
            }
        }()
        
        let internalWidth: AlertAction.WidthStyle = {
            switch width {
            case .fixed(let value): return .fixed(value)
            case .dynamic: return .dynamic
            }
        }()
        
        let actionComponent = AlertAction(
            title: title,
            style: internalStyle,
            width: internalWidth,
            height: height,
            icon: icon,
            canDismissAlert: canDismissAlert,
            font: font ?? UIFont.systemFont(ofSize: 16, weight: .medium),
            action: action
        )
        return append(actionComponent)
    }
    
    /// Adds a text input component to the card
    /// - Parameters:
    ///   - placeholder: Placeholder text for the input field
    ///   - subtitle: Helper text displayed below the input
    ///   - subtitleFont: Optional font for the subtitle
    ///   - subtitleColor: Optional color for the subtitle
    ///   - textFont: Optional font for the input text
    ///   - textColor: Optional color for the input text
    ///   - backgroundColor: Optional background color for the input field
    ///   - cornerRadius: Optional corner radius for the input field
    ///   - borderColor: Optional border color for the input field
    ///   - borderWidth: Optional border width for the input field
    ///   - onTextChange: Optional callback for text changes
    /// - Returns: Self for method chaining
    @discardableResult
    public func textInput(
        placeholder: String,
        subtitle: String,
        subtitleFont: UIFont? = nil,
        subtitleColor: UIColor? = nil,
        textFont: UIFont? = nil,
        textColor: UIColor? = nil,
        backgroundColor: UIColor? = nil,
        cornerRadius: CGFloat? = nil,
        borderColor: UIColor? = nil,
        borderWidth: CGFloat? = nil,
        onTextChange: ((String?) -> Void)? = nil
    ) -> MGCard {
        let textInputComponent = AlertTextView(
            placeholder: placeholder,
            subtitle: subtitle,
            subtitleFont: subtitleFont,
            subtitleColor: subtitleColor,
            textViewFont: textFont,
            textViewTextColor: textColor,
            textViewBackgroundColor: backgroundColor,
            textViewCornerRadius: cornerRadius,
            textViewBorderColor: borderColor,
            textViewBorderWidth: borderWidth
        )
        
        if let onTextChange = onTextChange {
            textInputComponent.onTextChange = onTextChange
        }
        
        return append(textInputComponent)
    }
    
    // MARK: - Component Linking API
    
    /// Links a text input with an action button for automatic state control
    /// The action button will be enabled/disabled based on text input content
    /// - Parameters:
    ///   - textInputIndex: Index of the text input component (default: 0 for first text input)
    ///   - actionIndex: Index of the action button component (default: 0 for first action)
    /// - Returns: Self for method chaining
    @discardableResult
    public func linkTextInputToAction(textInputIndex: Int = 0, actionIndex: Int = 0) -> MGCard {
        // Find the text input and action components
        let textInputComponents = components.compactMap { $0 as? AlertTextView }
        let actionComponents = components.compactMap { $0 as? AlertAction }
        
        guard textInputIndex < textInputComponents.count,
              actionIndex < actionComponents.count else {
            return self
        }
        
        let textInput = textInputComponents[textInputIndex]
        let action = actionComponents[actionIndex]
        
        // Link them together
        textInput.setSubmitAction(action)
        
        return self
    }
    
    /// Gets the current text value from the first text input
    /// - Returns: The current text value, or nil if no text input exists or is empty
    public func getTextInputValue() -> String? {
        let textInputComponents = components.compactMap { $0 as? AlertTextView }
        return textInputComponents.first?.textValue
    }
    
    /// Gets the current text value from a specific text input
    /// - Parameter index: The index of the text input
    /// - Returns: The current text value, or nil if no text input exists at that index or is empty
    public func getTextInputValue(at index: Int) -> String? {
        let textInputComponents = components.compactMap { $0 as? AlertTextView }
        guard index >= 0 && index < textInputComponents.count else { return nil }
        return textInputComponents[index].textValue
    }
    
    /// Enables or disables the first action button
    /// - Parameter enabled: Whether the button should be enabled
    public func setActionEnabled(_ enabled: Bool) {
        let actionComponents = components.compactMap { $0 as? AlertAction }
        actionComponents.first?.isEnabled = enabled
    }
    
    /// Enables or disables a specific action button
    /// - Parameters:
    ///   - index: The index of the action button to control
    ///   - enabled: Whether the button should be enabled
    public func setActionEnabled(at index: Int, enabled: Bool) {
        let actionComponents = components.compactMap { $0 as? AlertAction }
        guard index >= 0 && index < actionComponents.count else { return }
        actionComponents[index].isEnabled = enabled
    }
    
    // MARK: - Presentation API
    
    /// Presents the card modally using the queue management system
    public func show() {
        MGCardManager.shared.show(self)
    }
    
    // MARK: - UIView Overrides
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        alertContainerStackView.layer.cornerRadius = 12
        alertContainerStackView.clipsToBounds = true
    }
    
    // MARK: - Internal Presentation
    
    /// Internal method for presenting the card with completion handler
    /// - Parameter completion: Closure called when the card is dismissed
    internal func showInternal(completion: @escaping () -> Void) {
        self.dismissCompletion = completion
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            print("MGCard Error: Failed to find a window scene")
            return
        }
        
        setupWindow(in: windowScene)
        setupConstraints()
        setupUI()
        animatePresentation()
    }
    
    // MARK: - Setup Methods
    
    private func setupCard() {
        alertContainerStackView.backgroundColor = .white
        setupDismissButton()
        setupAlertContainer()
    }
    
    private func setupWindow(in windowScene: UIWindowScene) {
        alertWindow = UIWindow(windowScene: windowScene)
        alertWindow?.windowLevel = .alert + 1
        alertWindow?.backgroundColor = .clear
        
        let rootViewController = UIViewController()
        rootViewController.view.backgroundColor = .clear
        alertWindow?.rootViewController = rootViewController
        rootViewController.view.addSubview(self)
        alertWindow?.makeKeyAndVisible()
    }
    
    private func setupConstraints() {
        guard let rootView = alertWindow?.rootViewController?.view else { return }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: rootView.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: rootView.trailingAnchor),
            self.topAnchor.constraint(equalTo: rootView.topAnchor),
            self.bottomAnchor.constraint(equalTo: rootView.bottomAnchor)
        ])
    }
    
    private func setupUI() {
        setupDimmedBackground()
        setupViewComponents()
    }
    
    private func animatePresentation() {
        self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        self.alpha = 0
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 1,
            options: .curveEaseInOut
        ) {
            self.alpha = 1
            self.transform = CGAffineTransform.identity
        }
    }
    
    private func setupDismissButton() {
        dismissButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        dismissButton.tintColor = .label
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
    }
    
    private func setupAlertContainer() {
        alertContainerStackView.axis = .vertical
        alertContainerStackView.spacing = 16
        alertContainerStackView.alignment = .center
        alertContainerStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(alertContainerStackView)
        
        NSLayoutConstraint.activate([
            alertContainerStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            alertContainerStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            alertContainerStackView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -40)
        ])
    }
    
    private func setupDismissButtonConstraints() {
        dismissButton.removeFromSuperview()
        
        if showDismissButton {
            alertContainerStackView.addSubview(dismissButton)
            NSLayoutConstraint.activate([
                dismissButton.topAnchor.constraint(equalTo: alertContainerStackView.topAnchor, constant: 20),
                dismissButton.trailingAnchor.constraint(equalTo: alertContainerStackView.trailingAnchor, constant: -20),
                dismissButton.widthAnchor.constraint(equalToConstant: 20),
                dismissButton.heightAnchor.constraint(equalToConstant: 20)
            ])
        }
    }
    
    private func setupViewComponents() {
        // Remove existing components (except dismiss button)
        for view in alertContainerStackView.arrangedSubviews {
            if view != dismissButton {
                alertContainerStackView.removeArrangedSubview(view)
                view.removeFromSuperview()
            }
        }
        
        setupDismissButtonConstraints()
        
        // Add new components
        for component in components {
            let view = component.renderComponent { [weak self] in
                self?.removeAlertWithAnimation()
            }
            alertContainerStackView.addArrangedSubview(view)
        }
        
        alertContainerStackView.layoutMargins = UIEdgeInsets(top: 25, left: 15, bottom: 25, right: 15)
        alertContainerStackView.isLayoutMarginsRelativeArrangement = true
    }
    
    private func setupDimmedBackground() {
        guard let parentView = self.superview else { return }
        
        dimmedBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        dimmedBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        parentView.insertSubview(dimmedBackgroundView, belowSubview: self)
        
        NSLayoutConstraint.activate([
            dimmedBackgroundView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            dimmedBackgroundView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
            dimmedBackgroundView.topAnchor.constraint(equalTo: parentView.topAnchor),
            dimmedBackgroundView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor)
        ])
        
        dimmedBackgroundView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.dimmedBackgroundView.alpha = 1
        }
    }
    
    // MARK: - Dismissal
    
    @objc private func dismissButtonTapped() {
        dismissButtonCompletion?()
        removeAlertWithAnimation()
    }
    
    internal func removeAlertWithAnimation() {
        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.alpha = 0
                self.dimmedBackgroundView.alpha = 0
            },
            completion: { _ in
                self.cleanup()
            }
        )
    }
    
    private func cleanup() {
        removeFromSuperview()
        dimmedBackgroundView.removeFromSuperview()
        alertWindow?.isHidden = true
        alertWindow = nil
        
        onDismiss?()
        dismissCompletion?()
        dismissCompletion = nil
    }
}
