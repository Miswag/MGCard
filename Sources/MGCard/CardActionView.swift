//
//  CardActionView.swift
//  MGCard
//
//  Created by Mosa Khaldun on 26/11/2024.
//

import UIKit

// MARK: - CardActionView

/// Internal view implementation for action buttons in MGCard
/// Handles button styling, layout, and interaction state management
internal final class CardActionView: UIView {
    
    // MARK: - Properties
    
    private let action: () -> Void
    private let widthStyle: AlertAction.WidthStyle
    private let height: CGFloat
    private var style: AlertAction.ButtonStyle
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel()
    private let iconImageView = UIImageView()
    private var stackView: UIStackView!
    
    // MARK: - State Management
    
    /// Controls the enabled state of the button
    /// When disabled, the button becomes non-interactive and visually dimmed
    internal var isEnabled: Bool = true {
        didSet {
            isUserInteractionEnabled = isEnabled
            updateAppearanceForEnabledState()
        }
    }
    
    // MARK: - Initialization
    
    /// Creates a new action button view
    /// - Parameters:
    ///   - title: The button title text
    ///   - style: The visual style configuration
    ///   - icon: Optional SF Symbol icon name
    ///   - widthStyle: Width configuration (fixed or dynamic)
    ///   - height: Button height in points
    ///   - action: Closure to execute when button is tapped
    internal init(
        title: String,
        style: AlertAction.ButtonStyle,
        icon: String? = nil,
        widthStyle: AlertAction.WidthStyle,
        height: CGFloat,
        action: @escaping () -> Void
    ) {
        self.action = action
        self.widthStyle = widthStyle
        self.height = height
        self.style = style
        super.init(frame: .zero)
        
        setupView(title: title, style: style, icon: icon)
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIView Overrides
    
    override internal func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = height / 2
    }
    
    // MARK: - Private Methods
    
    private func setupView(title: String, style: AlertAction.ButtonStyle, icon: String?) {
        setupStackView()
        setupTitleLabel(title: title)
        setupIconIfNeeded(icon: icon)
        setupLayout()
        updateAppearanceForEnabledState()
    }
    
    private func setupStackView() {
        stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
    }
    
    private func setupTitleLabel(title: String) {
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        stackView.addArrangedSubview(titleLabel)
    }
    
    private func setupIconIfNeeded(icon: String?) {
        guard let iconName = icon else { return }
        
        let mediumConfig = UIImage.SymbolConfiguration(weight: .medium)
        if let image = UIImage(systemName: iconName, withConfiguration: mediumConfig) {
            iconImageView.image = image
            iconImageView.contentMode = .scaleAspectFit
            stackView.addArrangedSubview(iconImageView)
        }
    }
    
    private func setupLayout() {
        switch widthStyle {
        case .fixed(let fixedWidth):
            setupFixedWidthLayout(width: fixedWidth)
        case .dynamic:
            setupDynamicWidthLayout()
        }
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: height)
        ])
        
        layer.masksToBounds = true
    }
    
    private func setupFixedWidthLayout(width: CGFloat) {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: width),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func setupDynamicWidthLayout() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupGesture() {
        isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func buttonTapped() {
        action()
    }
    
    private func updateAppearanceForEnabledState() {
        if isEnabled {
            updateEnabledAppearance()
        } else {
            updateDisabledAppearance()
        }
    }
    
    private func updateEnabledAppearance() {
        alpha = 1.0
        switch style {
        case .filled(let color):
            applyFilledStyle(color: color)
        case .outlined(let color):
            applyOutlinedStyle(color: color)
        case .clear(let color):
            applyClearStyle(color: color)
        }
    }
    
    private func updateDisabledAppearance() {
        alpha = 0.5
        backgroundColor = backgroundColor?.withAlphaComponent(0.5)
        titleLabel.textColor = titleLabel.textColor.withAlphaComponent(0.8)
        iconImageView.tintColor = iconImageView.tintColor?.withAlphaComponent(0.8)
    }
    
    private func applyFilledStyle(color: UIColor) {
        backgroundColor = color
        titleLabel.textColor = .white
        iconImageView.tintColor = .white
        layer.borderWidth = 0
    }
    
    private func applyOutlinedStyle(color: UIColor) {
        backgroundColor = .clear
        layer.borderWidth = 1
        layer.borderColor = color.cgColor
        titleLabel.textColor = color
        iconImageView.tintColor = color
    }
    
    private func applyClearStyle(color: UIColor) {
        backgroundColor = .clear
        layer.borderWidth = 0
        titleLabel.textColor = color
        iconImageView.tintColor = color
    }
}
