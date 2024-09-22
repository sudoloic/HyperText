import Testing
import Foundation
@testable import HyperText


struct HTMLNSAttributedStringTests {
    
    @Test("Test NSAttributedString HTML extension with valid HTML")
    func htmlAttributedString() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        let htmlString = """
    <p>Lorem ipsum dolor sit amet</p>
    """
        let string = "Lorem ipsum dolor sit amet"
        let attributedString = try #require(NSAttributedString(html: htmlString))
        #expect(attributedString.string.contains(string) == true)
    }


    @Test("Test NSAttributedString HTML extension with plain text")
    func textAttributedString() async throws {
        let string = "test"
        let attributedString = try #require(NSAttributedString(html: string))
        #expect(attributedString.string.contains(string) == true)
    }
}
