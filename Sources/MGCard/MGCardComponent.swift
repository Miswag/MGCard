//
//  MGCardComponent.swift
//  MGCard
//
//  Created by Mosa Khaldun on 26/11/2024.
//

import UIKit

// MARK: - Public Enums

/// Button styling options for action components
public enum ButtonStyle {
    /// Filled button with background color
    case filled(color: UIColor)
    /// Outlined button with border color
    case outlined(color: UIColor)
    /// Clear button with text color only
    case clear(color: UIColor)
}

/// Width configuration options for action components
public enum WidthStyle {
    /// Fixed width in points
    case fixed(CGFloat)
    /// Dynamic width that adjusts to content
    case dynamic
}

// MARK: - AlertComponent Protocol

/// Protocol defining the interface for all MGCard components
/// Components must be able to render themselves as UIView instances
internal protocol AlertComponent {
    /// Renders the component as a UIView
    /// - Parameter dismissHandler: Closure to call when the component should dismiss the card
    /// - Returns: A configured UIView representing this component
    func renderComponent(dismissHandler: @escaping () -> Void) -> UIView
}

// MARK: - AlertText

/// Text component for displaying title and subtitle text with customizable styling
internal final class AlertText: AlertComponent {
    
    // MARK: - Properties
    
    private var texts: [(text: String, font: UIFont?, color: UIColor?, alignment: NSTextAlignment?)] = []
    private let spacing: CGFloat
    
    // MARK: - Initialization
    
    /// Creates a new text component with specified spacing
    /// - Parameter spacing: Vertical spacing between text elements
    internal init(spacing: CGFloat = 1) {
        self.spacing = spacing
    }
    
    // MARK: - Configuration
    
    /// Adds a text element to the component
    /// - Parameters:
    ///   - text: The text content to display
    ///   - font: Optional font for the text
    ///   - color: Optional color for the text
    ///   - alignment: Optional text alignment
    /// - Returns: Self for method chaining
    @discardableResult
    internal func addText(
        text: String,
        font: UIFont? = nil,
        color: UIColor? = nil,
        alignment: NSTextAlignment? = nil
    ) -> AlertText {
        texts.append((text: text, font: font, color: color, alignment: alignment))
        return self
    }
    
    // MARK: - AlertComponent
    
    internal func renderComponent(dismissHandler: @escaping () -> Void) -> UIView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = spacing
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        for text in texts {
            let label = createLabel(for: text)
            stackView.addArrangedSubview(label)
        }
        
        return stackView
    }
    
    // MARK: - Private Methods
    
    private func createLabel(for text: (text: String, font: UIFont?, color: UIColor?, alignment: NSTextAlignment?)) -> UILabel {
        let label = UILabel()
        label.text = text.text
        label.font = text.font ?? UIFont.systemFont(ofSize: 14)
        label.textColor = text.color ?? .label
        label.textAlignment = text.alignment ?? .center
        label.numberOfLines = 10
        return label
    }
}

// MARK: - AlertImage

/// Image component for displaying icons and images with customizable sizing and rendering
internal final class AlertImage: AlertComponent {
    
    // MARK: - Properties
    
    private let imageName: String
    private let imageScale: UIView.ContentMode
    private let imageWidth: CGFloat
    private let imageHeight: CGFloat
    private let renderingMode: UIImage.RenderingMode
    private let tintColor: UIColor?
    
    // MARK: - Initialization
    
    /// Creates a new image component
    /// - Parameters:
    ///   - imageName: Name of the image (system icon or asset)
    ///   - imageScale: Content mode for scaling (default: .scaleAspectFill)
    ///   - imageWidth: Width of the image in points (default: 50)
    ///   - imageHeight: Height of the image in points (default: 50)
    ///   - renderingMode: Image rendering mode (default: .alwaysOriginal)
    ///   - tintColor: Optional tint color for the image
    internal init(
        imageName: String,
        imageScale: UIView.ContentMode = .scaleAspectFill,
        imageWidth: CGFloat = 50,
        imageHeight: CGFloat = 50,
        renderingMode: UIImage.RenderingMode = .alwaysOriginal,
        tintColor: UIColor? = nil
    ) {
        self.imageName = imageName
        self.imageScale = imageScale
        self.imageWidth = imageWidth
        self.imageHeight = imageHeight
        self.renderingMode = renderingMode
        self.tintColor = tintColor
    }
    
    // MARK: - AlertComponent
    
    internal func renderComponent(dismissHandler: @escaping () -> Void) -> UIView {
        let imageView = UIImageView(image: UIImage.fetch(imageName, usingRenderingMode: renderingMode))
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.contentMode = imageScale
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Apply tint color if specified
        if let tintColor = tintColor {
            imageView.tintColor = tintColor
        }
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: imageWidth),
            imageView.heightAnchor.constraint(equalToConstant: imageHeight)
        ])
        
        return imageView
    }
}

// MARK: - AlertAction

/// Action button component with customizable styling and behavior
internal final class AlertAction: AlertComponent {
    
    // MARK: - Enums
    
    internal enum ButtonStyle {
        case filled(color: UIColor)
        case outlined(color: UIColor)
        case clear(color: UIColor)
    }
    
    internal enum WidthStyle {
        case fixed(CGFloat)
        case dynamic
    }
    
    // MARK: - Properties
    
    private let title: String
    private let style: ButtonStyle
    private let width: WidthStyle
    private let height: CGFloat
    private let icon: String?
    private let canDismissAlert: Bool
    private let action: (() -> Void)?
    private let font: UIFont
    
    /// Controls whether the button is enabled and interactive
    internal var isEnabled: Bool = true {
        didSet {
            actionView?.isEnabled = isEnabled
        }
    }
    
    // Keep a weak reference to the action view for state updates
    private weak var actionView: CardActionView?
    
    // MARK: - Initialization
    
    /// Creates a new action button component
    /// - Parameters:
    ///   - title: Button title text
    ///   - style: Visual style of the button
    ///   - width: Width configuration
    ///   - height: Height in points (default: 35)
    ///   - icon: Optional SF Symbol icon name
    ///   - canDismissAlert: Whether button tap should dismiss the card (default: true)
    ///   - font: The font for the button title (defaults to system font, medium weight, size 16)
    ///   - action: Optional closure to execute on tap
    internal init(
        title: String,
        style: ButtonStyle,
        width: WidthStyle,
        height: CGFloat = 35,
        icon: String? = nil,
        canDismissAlert: Bool = true,
        font: UIFont = UIFont.systemFont(ofSize: 16, weight: .medium),
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.style = style
        self.width = width
        self.height = height
        self.icon = icon
        self.action = action
        self.canDismissAlert = canDismissAlert
        self.font = font
    }
    
    // MARK: - AlertComponent
    
    internal func renderComponent(dismissHandler: @escaping () -> Void) -> UIView {
        let button = CardActionView(
            title: title,
            style: style,
            icon: icon,
            widthStyle: width,
            height: height,
            font: font,
            action: { [weak self] in
                self?.handleButtonTap(dismissHandler: dismissHandler)
            }
        )
        
        configureButton(button)
        self.actionView = button
        
        return button
    }
    
    // MARK: - Private Methods
    
    private func handleButtonTap(dismissHandler: @escaping () -> Void) {
        // Only perform action if enabled
        guard isEnabled else { return }
        
        action?()
        
        if canDismissAlert {
            dismissHandler()
        }
    }
    
    private func configureButton(_ button: CardActionView) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: height).isActive = true
        button.isEnabled = isEnabled
    }
}

// MARK: - AlertTextView

/// Text input component with placeholder, validation, and real-time change callbacks
internal final class AlertTextView: NSObject, AlertComponent, UITextViewDelegate {
    
    // MARK: - Properties
    
    private let placeholder: String
    private let subtitle: String
    private let subtitleFont: UIFont?
    private let subtitleColor: UIColor?
    private let textViewFont: UIFont?
    private let textViewTextColor: UIColor?
    private let textViewBackgroundColor: UIColor?
    private let textViewCornerRadius: CGFloat?
    private let textViewBorderColor: UIColor?
    private let textViewBorderWidth: CGFloat?
    
    // UI Components
    private let textView = UITextView()
    
    /// Callback for text changes
    internal var onTextChange: ((String?) -> Void)?
    
    /// Current text value (nil if showing placeholder)
    internal var textValue: String? {
        return textView.textColor == .placeholderText ? nil : textView.text
    }
    
    // MARK: - Initialization
    
    /// Creates a new text input component
    /// - Parameters:
    ///   - placeholder: Placeholder text
    ///   - subtitle: Helper text below the input
    ///   - subtitleFont: Optional font for subtitle
    ///   - subtitleColor: Optional color for subtitle
    ///   - textViewFont: Optional font for input text
    ///   - textViewTextColor: Optional color for input text
    ///   - textViewBackgroundColor: Optional background color
    ///   - textViewCornerRadius: Optional corner radius
    ///   - textViewBorderColor: Optional border color
    ///   - textViewBorderWidth: Optional border width
    internal init(
        placeholder: String,
        subtitle: String,
        subtitleFont: UIFont? = nil,
        subtitleColor: UIColor? = nil,
        textViewFont: UIFont? = nil,
        textViewTextColor: UIColor? = nil,
        textViewBackgroundColor: UIColor? = nil,
        textViewCornerRadius: CGFloat? = nil,
        textViewBorderColor: UIColor? = nil,
        textViewBorderWidth: CGFloat? = nil
    ) {
        self.placeholder = placeholder
        self.subtitle = subtitle
        self.subtitleFont = subtitleFont
        self.subtitleColor = subtitleColor
        self.textViewFont = textViewFont
        self.textViewTextColor = textViewTextColor
        self.textViewBackgroundColor = textViewBackgroundColor
        self.textViewCornerRadius = textViewCornerRadius
        self.textViewBorderColor = textViewBorderColor
        self.textViewBorderWidth = textViewBorderWidth
        super.init()
    }
    
    // MARK: - AlertComponent
    
    internal func renderComponent(dismissHandler: @escaping () -> Void) -> UIView {
        let stackView = createContainerStackView()
        
        configureTextView()
        let subtitleLabel = createSubtitleLabel()
        
        stackView.addArrangedSubview(textView)
        stackView.addArrangedSubview(subtitleLabel)
        
        return stackView
    }
    
    // MARK: - Private Methods
    
    private func createContainerStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.widthAnchor.constraint(equalToConstant: 280).isActive = true
        return stackView
    }
    
    private func configureTextView() {
        textView.font = textViewFont ?? UIFont.systemFont(ofSize: 16)
        textView.textColor = .placeholderText
        textView.backgroundColor = textViewBackgroundColor ?? .secondarySystemBackground
        textView.layer.cornerRadius = textViewCornerRadius ?? 8
        textView.layer.masksToBounds = true
        textView.text = placeholder
        textView.textAlignment = .natural
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        if let borderColor = textViewBorderColor {
            textView.layer.borderColor = borderColor.cgColor
            textView.layer.borderWidth = textViewBorderWidth ?? 1
        }
    }
    
    private func createSubtitleLabel() -> UILabel {
        let label = UILabel()
        label.text = subtitle
        label.font = subtitleFont ?? UIFont.systemFont(ofSize: 12)
        label.textColor = subtitleColor ?? .secondaryLabel
        label.textAlignment = .natural
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    // MARK: - UITextViewDelegate
    
    internal func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .placeholderText {
            textView.text = nil
            textView.textColor = textViewTextColor ?? .label
        }
    }
    
    internal func textViewDidChange(_ textView: UITextView) {
        let text = textView.textColor == .placeholderText ? nil : textView.text
        onTextChange?(text)
    }
    
    internal func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = .placeholderText
        }
    }
}
