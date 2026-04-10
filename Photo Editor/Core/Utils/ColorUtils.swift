import Foundation
import SwiftUI

class ColorUtils {
    static let primary = Color(red: 0.2, green: 0.4, blue: 0.6)
    static let secondary = Color(red: 0.8, green: 0.4, blue: 0.2)
    static let accent = Color(red: 0.2, green: 0.6, blue: 0.4)
    static let background = Color(red: 0.95, green: 0.95, blue: 0.95)
    static let surface = Color(red: 0.98, green: 0.98, blue: 0.98)
    static let text = Color(red: 0.1, green: 0.1, blue: 0.1)
    static let textSecondary = Color(red: 0.5, green: 0.5, blue: 0.5)
    static let border = Color(red: 0.8, green: 0.8, blue: 0.8)
    
    static func hexToColor(hex: String) -> Color {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: Double
        if hex.count == 8 {
            a = Double((int >> 24) & 0xFF) / 255
            r = Double((int >> 16) & 0xFF) / 255
            g = Double((int >> 8) & 0xFF) / 255
            b = Double(int & 0xFF) / 255
        } else {
            a = 1.0
            r = Double((int >> 16) & 0xFF) / 255
            g = Double((int >> 8) & 0xFF) / 255
            b = Double(int & 0xFF) / 255
        }
        return Color(red: r, green: g, blue: b, opacity: a)
    }
    
    static func colorToHex(color: Color) -> String {
        let nsColor = NSColor(color)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        nsColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        let hex = String(format: "%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
        return hex
    }
    
    static func adjustBrightness(color: Color, amount: CGFloat) -> Color {
        let nsColor = NSColor(color)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        nsColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        return Color(red: min(1.0, max(0.0, r + amount)), green: min(1.0, max(0.0, g + amount)), blue: min(1.0, max(0.0, b + amount)), opacity: a)
    }
}
