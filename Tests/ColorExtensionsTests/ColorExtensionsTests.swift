import XCTest
import SwiftUI

@testable import ColorExtensions

final class ColorExtensionsTests: XCTestCase {
    
    // MARK: - COLOR <-> DATA
    
    func testColorToDataAndBack() {
        let colorData = Color.orange.convertToData()
        XCTAssertNotNil(colorData, "Δεν δούλεψε σωστά η μετατροπή απο color σε data")
        let redColorFromData = Color(colorData)
        XCTAssertNotNil(redColorFromData, "Δεν δούλεψε σωστά η μετατροπή απο data σε color")
        let systemRedComponents = Color.red.components
        let dataRedComponents = redColorFromData?.components
        
        XCTAssertEqual(systemRedComponents?.red, dataRedComponents?.red)
        XCTAssertEqual(systemRedComponents?.green, dataRedComponents?.green)
        XCTAssertEqual(systemRedComponents?.blue, dataRedComponents?.blue)
        XCTAssertEqual(systemRedComponents?.opacity, dataRedComponents?.opacity)

    }
}
