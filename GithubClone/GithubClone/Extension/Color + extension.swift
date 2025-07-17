

import SwiftUI

extension Color {
    
    init(hex: String) {
        let trimmedHex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedHex == "" {
            self = .clear
            return
        }
        
        if trimmedHex.starts(with: "rgba") {
            // Parse RGBA
            let rgbaValues = trimmedHex
                .replacingOccurrences(of: "rgba", with: "")
                .replacingOccurrences(of: "(", with: "")
                .replacingOccurrences(of: ")", with: "")
                .split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }
            
            if rgbaValues.count == 4,
               let r = Int(rgbaValues[0]),
               let g = Int(rgbaValues[1]),
               let b = Int(rgbaValues[2]),
               let a = Double(rgbaValues[3]) {
                self.init(
                    .sRGB,
                    red: Double(r) / 255,
                    green: Double(g) / 255,
                    blue: Double(b) / 255,
                    opacity: a
                )
                return
            }
        } else if trimmedHex.starts(with: "rgb") {
            let components = trimmedHex
                .replacingOccurrences(of: "rgb(", with: "")
                .replacingOccurrences(of: ")", with: "")
                .split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            
            if components.count == 3,
               let r = Double(components[0]),
               let g = Double(components[1]),
               let b = Double(components[2]) {
                self.init(
                    .sRGB,
                    red: Double(r) / 255,
                    green: Double(g) / 255,
                    blue: Double(b) / 255
                )
                return
            }
        } else {
            // Parse HEX
            let hex = trimmedHex.trimmingCharacters(in: .alphanumerics.inverted)
            var int: UInt64 = 0
            Scanner(string: hex).scanHexInt64(&int)
            
            let a, r, g, b: UInt64
            switch hex.count {
            case 3: // RGB (12-bit)
                (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
            case 6: // RGB (24-bit)
                (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
            case 8: // ARGB (32-bit)
                (r, g, b, a) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
            default:
                (a, r, g, b) = (255, 0, 0, 0)
            }
            
            self.init(
                .sRGB,
                red: Double(r) / 255,
                green: Double(g) / 255,
                blue: Double(b) / 255,
                opacity: Double(a) / 255
            )
            return
        }
        
        // Fallback to clear color
        self.init(.sRGB, red: 0, green: 0, blue: 0, opacity: 0)
    }

    static var exampleGrey = Color(hex: "0C0C0C")
    static var exampleLightGrey = Color(hex: "#B1B1B1")
    static var examplePurple = Color(hex: "7D26FE")
    
    
    init(rgba: [String]) {
        if let r = Double(rgba[0]),
           let g = Double(rgba[1]),
           let b = Double(rgba[2]),
           let a = Double(rgba[3]) {
            
            self.init(
                .sRGB,
                red: Double(r) / 255,
                green: Double(g) / 255,
                blue: Double(b) / 255,
                opacity: Double(a)
            )
        } else {
            self.init(
                .sRGB,
                red: Double(255) / 255,
                green: Double(255) / 255,
                blue: Double(255) / 255,
                opacity: Double(1.0)
            )
        }
    }

}
