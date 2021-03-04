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
}
