import XCTest
import SwiftUI

@testable import ColorExtensions

final class ColorExtensionsTests: XCTestCase {
    
    // MARK: - COLOR <-> DATA
    // Σιγουρεύομαι ότι μετατρέπει ένα Color σε Data και επιστρέφει ακριβώς το ίδιο χρώμα.
    func testColorToDataAndBack() {
        let underTestColors: [Color] = [
            .purple,
            .red,
            .green,
            .blue,
            .yellow,
            .orange,
            .black,
            .white,
            .blue,
            .clear,
            .accentColor
        ]
        measure {
            for underTestColor in underTestColors {
                let colorData = underTestColor.data()
                XCTAssertNotNil(colorData, "Δεν δούλεψε σωστά η μετατροπή απο color σε data")
                let colorFromData = Color(colorData)
                XCTAssertNotNil(colorFromData, "Δεν δούλεψε σωστά η μετατροπή απο data σε color")
                let systemColorComponents = underTestColor.components
                let colorFromDataComponents = colorFromData?.components
                
                XCTAssertEqual(systemColorComponents?.red, colorFromDataComponents?.red)
                XCTAssertEqual(systemColorComponents?.green, colorFromDataComponents?.green)
                XCTAssertEqual(systemColorComponents?.blue, colorFromDataComponents?.blue)
                XCTAssertEqual(systemColorComponents?.opacity, colorFromDataComponents?.opacity)
            }
        }
    }
    
    // MARK: - ACCESSIBLE COLORS
    // Σιγουρεύομαι ότι επιστρέφει το σωστό χρώμα για τα fonts ανάλογα με το χρώμα του φόντου
    func testAccessibleFontColor() {
        let accessibleColorFontUnderTestForLightBackground = Color(.sRGB, red: 0.55, green: 0.55, blue: 0.55, opacity: 1).accessibleFontColor
        XCTAssertEqual(accessibleColorFontUnderTestForLightBackground, Color.white)
        let accessibleColorFontUnderTestForDarkBackground = Color(.sRGB, red: 0.6, green: 0.6, blue: 0.6, opacity: 1).accessibleFontColor
        XCTAssertEqual(accessibleColorFontUnderTestForDarkBackground, Color.black)
    }
    
    // MARK: - INTERNALS
    
    func testComponents() {
        let red: CGFloat = 0.2
        let green: CGFloat = 0.5
        let blue: CGFloat = 0.8
        let alpha: CGFloat = 1.0
        #if os(macOS)
        let nsColor = NSColor.init(srgbRed: red, green: green, blue: blue, alpha: alpha)
        let color = Color(nsColor)
        #else
        let uiColor = UIColor.init(red: red, green: green, blue: blue, alpha: alpha)
        let color = Color(uiColor)
        #endif
        
        let components = color.components

        XCTAssertEqual(components?.red, 0.2)
        XCTAssertEqual(components?.green, 0.5)
        XCTAssertEqual(components?.blue, 0.8)
        XCTAssertEqual(components?.opacity, 1.0)
    }
    
    func testIsLightColor() {
        let sutLightColor = Color.isLightColor(red: 0.61, green: 0.61, blue: 0.61)
        let sutDarkColor = Color.isLightColor(red: 0.59, green: 0.59, blue: 0.59)
        XCTAssertTrue(sutLightColor)
        XCTAssertFalse(sutDarkColor)
    }
    
    func testIsDarkColor() {
        let sutLightColor = Color.isDarkColor(red: 0.41, green: 0.41, blue: 0.41)
        let sutDarkColor = Color.isDarkColor(red: 0.39, green: 0.39, blue: 0.39)
        XCTAssertFalse(sutLightColor)
        XCTAssertTrue(sutDarkColor)
    }
    
}
