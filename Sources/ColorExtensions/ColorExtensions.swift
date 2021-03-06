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
        let uiColor = NativeColor(red: newDiaryColor.r, green: newDiaryColor.g, blue: newDiaryColor.b, alpha: newDiaryColor.a)
        self.init(uiColor)
    }
    
    /// Μετατρέπει το Color σε Data.
    func data() -> Data? {
        guard let components = self.components else { return nil }
        let tempDiaryColor = DiaryColor(r: components.red, g: components.green, b: components.blue, a: components.opacity)
        guard let newData = try? JSONEncoder().encode(tempDiaryColor) else { return nil }
        return newData
    }
    
    /// Το χρησιμοποιώ σαν wrapper για να μετατρέψω το Color σε Data και το αντίστροφο. Το κάνω έτσι γιατί δεν μπορώ να μετατρέψω αλλιώς το Color σε Codable.
    private struct DiaryColor: Codable {
        var r: CGFloat
        var g: CGFloat
        var b: CGFloat
        var a: CGFloat
    }
    
    // MARK: - ACCESSIBLE COLORS
    /// Ανάλογα με το πόσο φωτεινό ή σκούρο είναι ένα χρώμα, επιστρέφει λευκό ή μαύρο. Προορίζεται για Fonts, για να είναι ευανάγνωστα όταν θα μπούν μπροστά απο αυτό το χρώμα.
    var accessibleFontColor: Color {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        NativeColor(self).getRed(&red, green: &green, blue: &blue, alpha: nil)
        return Self.isLightColor(red: red, green: green, blue: blue) ? .black : .white
    }
    
    // MARK: - INTERNALS
    
    /// Επιστρέφει τα χρώματα του Color
    /// ΠΡΟΣΟΧΗ: Σε περίπτωση που μας ενδιαφέρει η μεγάλη ακρίβια στις τιμές, όταν δημιουργούμε ένα χρώμα απο τα βασικά χρώματα, να χρησιμοποιούμε το UIColor ή NSColor και μετά να το μετατρέπουμε σε Color. Το Color της SwiftUI όταν δημιουργείται απο τα επιμέρους χρώματα, και μετά τα ξαναδιαχωρίσουμε με το components, χάνεται η ακρίβεια και υπάρχουν διαφορές στους μεγάλους δεκαδικούς αριθμούς.
    internal var components: (red: CGFloat, green: CGFloat, blue: CGFloat, opacity: CGFloat)? {
        // εδώ θα αποθηκεύονται προσωρινά τα χρώματα
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var o: CGFloat = 0
        #if os(macOS)
        // Για macOS πρέπει να εισάγω εγώ την παλέτα χρωμάτων (Color Space)
        guard let colorWithColorSpace = NativeColor(self).usingColorSpace(.sRGB) else { return nil }
        #else
        let colorWithColorSpace = NativeColor(self)
        #endif
        // χρησιμοποιώ την συνάρτηση (που προφανώς προέρχεται απο objective C) που παρέχει το UIColor για να πάρω τα χρώματα.
        colorWithColorSpace.getRed(&r, green: &g, blue: &b, alpha: &o)
        return ((r), (g), (b), (o))
    }
    
    internal static func isLightColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> Bool {
        let lightRed = red > 0.60
        let lightGreen = green > 0.60
        let lightBlue = blue > 0.60

        let lightness = [lightRed, lightGreen, lightBlue].reduce(0) { $1 ? $0 + 1 : $0 }
        return lightness >= 2
    }
    
    internal static func isDarkColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> Bool {
        let darkRed = red < 0.40
        let darkGreen = green < 0.40
        let darkBlue = blue < 0.40

        let darkness = [darkRed, darkGreen, darkBlue].reduce(0) { $1 ? $0 + 1 : $0 }
        return darkness >= 2
    }
    
}
