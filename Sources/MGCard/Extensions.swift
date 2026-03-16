//
//  Extensions.swift
//  MGCard
//
//  Created by Mosa Khaldun on 04/06/2025.
//

import UIKit
import Lottie

// MARK: - UIImage Extensions

extension UIImage {
    
    /// Fetches an image from either the module's bundle or system icons with fallback support
    /// 
    /// This method first attempts to load a custom image from the app bundle, then falls back
    /// to system SF Symbols, and finally provides a fallback icon if neither is found.
    /// 
    /// - Parameters:
    ///   - icon: The name of the image to load. Can be a custom asset name or SF Symbol name
    ///   - bundle: The bundle containing the image (defaults to .main)
    ///   - renderingMode: The rendering mode to apply to the loaded image (default: .alwaysTemplate)
    ///   - fallBackIcon: The SF Symbol name to use if the primary icon is not found (default: "questionmark.circle.fill")
    /// - Returns: The requested UIImage if available, otherwise the fallback system image
    /// 
    /// ## Usage
    /// ```swift
    /// // Load a custom icon with template rendering
    /// let icon = UIImage.fetch("my-custom-icon", usingRenderingMode: .alwaysTemplate)
    /// 
    /// // Load an SF Symbol with original rendering
    /// let symbol = UIImage.fetch("star.fill", usingRenderingMode: .alwaysOriginal)
    /// 
    /// // Load with custom fallback
    /// let image = UIImage.fetch("unknown-icon", fallBackIcon: "exclamationmark.triangle")
    /// ```
    static func fetch(
        _ icon: String,
        in bundle: Bundle = .main,
        usingRenderingMode renderingMode: RenderingMode = .alwaysTemplate,
        fallBackIcon: String = "questionmark.circle.fill"
    ) -> UIImage? {
        
        // First try to load from bundle (custom assets)
        if let bundleImage = UIImage(named: icon, in: bundle, compatible_with: nil) {
            return bundleImage.withRenderingMode(renderingMode)
        }
        
        // Then try system icons (SF Symbols)
        if let systemImage = UIImage(systemName: icon) {
            return systemImage.withRenderingMode(renderingMode)
        }
        
        // Finally fall back to the fallback icon
        return UIImage(systemName: fallBackIcon)?.withRenderingMode(renderingMode)
    }
}

// MARK: - LottieAnimation Extensions

extension LottieAnimation {
    /// Returns a `LottieAnimation` object from the module's bundle.
    ///
    /// This method looks for a Lottie animation file with the given name in the module's bundle.
    /// If the animation is not found, it prints an error message and returns `nil`.
    ///
    /// - Parameters:
    ///   - named: The name of the Lottie animation file (without the file extension).
    ///   - bundle: The bundle containing the animation file (defaults to .main).
    /// - Returns: A `LottieAnimation` object if found, or `nil` if the file could not be located.
    public static func returnLottieFile(named: String, in bundle: Bundle = .main) -> LottieAnimation? {
        guard let animation = LottieAnimation.named(named, bundle: bundle) else {
            print("❌ Animation not found: \(named) in bundle: \(bundle)")
            return nil
        }
        
        return animation
    }
}
