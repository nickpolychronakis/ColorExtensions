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
            .blue
        ]
        for underTestColor in underTestColors {
            let colorData = underTestColor.convertToData()
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
    
    // MARK: - ACCESSIBLE COLORS
    // Σιγουρεύομαι ότι επιστρέφει το σωστό χρώμα για τα fonts ανάλογα με το χρώμα του φόντου
    func testAccessibleFontColor() {
        let accessibleColorFontUnderTestForLightBackground = Color(.sRGB, red: 0.55, green: 0.55, blue: 0.55, opacity: 1).accessibleFontColor
        XCTAssertEqual(accessibleColorFontUnderTestForLightBackground, Color.white)
        let accessibleColorFontUnderTestForDarkBackground = Color(.sRGB, red: 0.6, green: 0.6, blue: 0.6, opacity: 1).accessibleFontColor
        XCTAssertEqual(accessibleColorFontUnderTestForDarkBackground, Color.black)
    }
    // Σιγουρεύομαι ότι επιστρέφει το σωστό χρώμα για το φόντο, ανάλογα με το χρώμα των fonts.
    func testAccessibleBackgroundColor() {
        let accessibleColorFontUnderTestForTooLight = Color(.sRGB, red: 0.9, green: 0.9, blue: 0.9, opacity: 1).accessibleBackgroundColor
        XCTAssertEqual(accessibleColorFontUnderTestForTooLight, Color.black)
        let accessibleColorFontUnderTestForMedium = Color(.sRGB, red: 0.5, green: 0.5, blue: 0.5, opacity: 1).accessibleBackgroundColor
        XCTAssertEqual(accessibleColorFontUnderTestForMedium, Color.clear)
        let accessibleColorFontUnderTestForTooDark = Color(.sRGB, red: 0.2, green: 0.2, blue: 0.2, opacity: 1).accessibleBackgroundColor
        XCTAssertEqual(accessibleColorFontUnderTestForTooDark, Color.white)
    }
    
    // MARK: - INTERNALS
    
}
