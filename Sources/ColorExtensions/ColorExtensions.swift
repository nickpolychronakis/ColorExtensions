import SwiftUI

// Ανάλογα με το λειτουργικό χρησιμοποιώ και άλλου τύπου χρώμα
#if canImport(UIKit)
typealias NativeColor = UIColor
#elseif canImport(AppKit)
typealias NativeColor = NSColor
#endif


public extension Color {
    
    // MARK: - COLOR <-> DATA
    /// Δημιουργεί  ένα Color? απο  Data.
    init?(_ data: Data?) {
        guard let data = data else { return nil }
        guard let newDiaryColor = try? JSONDecoder().decode(DiaryColor.self, from: data) else { return nil }
        let uiColor = UIColor(red: newDiaryColor.r, green: newDiaryColor.g, blue: newDiaryColor.b, alpha: newDiaryColor.a)
        self.init(uiColor)
    }
    
    /// Μετατρέπει το Color σε Data.
    func convertToData() -> Data? {
        guard let components = self.components else { return nil }
        let tempDiaryColor = DiaryColor(r: components.red, g: components.green, b: components.blue, a: components.opacity)
        guard let newData = try? JSONEncoder().encode(tempDiaryColor) else { return nil }
        return newData
    }
    
    // MARK: - ACCESSIBLE COLORS
    /// Ανάλογα με το πόσο φωτεινό ή σκούρο είναι ένα χρώμα, επιστρέφει λευκό ή μαύρο. Προορίζεται για Fonts, για να είναι ευανάγνωστα όταν θα μπούν μπροστά απο αυτό το χρώμα.
    var accessibleFontColor: Color {
        #if os(macOS)
        guard self != Color.clear else { return Color.primary }
        guard self != Color.accentColor else { return Color.primary }
        #endif
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        NativeColor(self).getRed(&red, green: &green, blue: &blue, alpha: nil)
        return isLightColor(red: red, green: green, blue: blue) ? .black : .white
    }
    
    /// Ανάλογα με το πόσο φωτεινό ή σκούρο είναι ένα χρώμα, επιστρέφει λευκό, μαύρο ή clear. Προορίζεται για φόντο σε Fonts, για να είναι ευανάγνωστα ανάλογα με το χρώμα τους.
    var accessibleBackgroundColor: Color {
        #if os(macOS)
        guard self != Color.clear else { return Color.primary }
        guard self != Color.accentColor else { return Color.primary }
        #endif
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        NativeColor(self).getRed(&red, green: &green, blue: &blue, alpha: nil)
        if isTooLightColor(red: red, green: green, blue: blue) {
            return .black
        } else if isTooDarkColor(red: red, green: green, blue: blue) {
            return Color.white
        } else {
            return Color.clear
        }
    }
    
    // MARK: - INTERNALS
    
    /// Επιστρέφει τα χρώματα του Color ξεχωριστά.
    internal var components: (red: CGFloat, green: CGFloat, blue: CGFloat, opacity: CGFloat)? {
        #if os(macOS)
        guard self != Color.clear else { return nil }
        guard self != Color.accentColor else { return nil }
        #endif
        // εδώ θα αποθηκεύονται προσωρινά τα χρώματα
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var o: CGFloat = 0
        // χρησιμοποιώ την συνάρτηση (που προφανώς προέρχεται απο objective C) που παρέχει το UIColor για να πάρω τα χρώματα.
        NativeColor(self).getRed(&r, green: &g, blue: &b, alpha: &o)
        return ((r), (g), (b), (o))
    }

    /// Το χρησιμοποιώ σαν wrapper για να μετατρέψω το Color σε Data και το αντίστροφο. Το κάνω έτσι γιατί δεν μπορώ να μετατρέψω αλλιώς το Color σε Codable.
    internal struct DiaryColor: Codable {
        var r: CGFloat
        var g: CGFloat
        var b: CGFloat
        var a: CGFloat
    }
    
    internal func isLightColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> Bool {
        let lightRed = red > 0.60
        let lightGreen = green > 0.60
        let lightBlue = blue > 0.60

        let lightness = [lightRed, lightGreen, lightBlue].reduce(0) { $1 ? $0 + 1 : $0 }
        return lightness >= 2
    }
    
    internal func isDarkColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> Bool {
        let darkRed = red < 0.85
        let darkGreen = green < 0.85
        let darkBlue = blue < 0.85

        let darkness = [darkRed, darkGreen, darkBlue].reduce(0) { $1 ? $0 + 1 : $0 }
        return darkness >= 2
    }
    
    internal func isTooLightColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> Bool {
        let lightRed = red > 0.85
        let lightGreen = green > 0.85
        let lightBlue = blue > 0.85

        let lightness = [lightRed, lightGreen, lightBlue].reduce(0) { $1 ? $0 + 1 : $0 }
        return lightness >= 2
    }
    
    internal func isTooDarkColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> Bool {
        let darkRed = red < 0.25
        let darkGreen = green < 0.25
        let darkBlue = blue < 0.25

        let darkness = [darkRed, darkGreen, darkBlue].reduce(0) { $1 ? $0 + 1 : $0 }
        return darkness >= 2
    }
}
