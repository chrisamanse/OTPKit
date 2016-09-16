import XCTest
import CryptoKit
@testable import OTPKit

class OTPKitTests: XCTestCase {
    // Passwords for 1...100
    let hotps = [
        "246744", "496532", "568367", "907965", "011909", "082090", "508590", "301924", "768521", "063055",
        "498423", "035670", "462064", "086000", "758704", "991576", "141594", "235081", "645146", "364819",
        "499647", "216412", "166771", "590716", "078318", "850346", "479936", "526533", "231654", "605312",
        "084271", "926492", "305412", "309537", "417758", "953923", "072102", "513445", "889853", "447297",
        "777514", "449016", "046552", "802977", "201609", "478724", "543180", "255683", "516861", "953678",
        "076599", "248814", "916274", "890210", "787416", "980590", "669148", "676410", "732140", "584653",
        "988354", "754946", "031166", "782373", "170038", "152059", "231416", "878183", "174855", "665045",
        "367297", "943230", "479352", "413666", "566606", "212855", "775075", "350074", "256571", "950051",
        "993146", "871779", "955627", "184424", "716365", "037228", "463911", "736737", "170690", "173868",
        "235989", "602726", "612836", "102814", "253569", "858525", "449426", "440907", "081215", "087279"
    ]
    
    func testHOTP() {
        let base32String = "V3ZMBGAETLLSXRJZ6QZD42Z33O3DK3R7"
        
        let secret = try! Base32.decode(base32String)
        
        let passwordGenerator = HOTPGenerator(key: secret, digits: 6, hashFunction: .sha1)
        
        for i: UInt64 in 1...100 {
            let password = (try? passwordGenerator.password(counter: i)) ?? ""
            
            XCTAssert(password.characters.count == 6, "Number of digits should be 6.")
            
            let expected = hotps[Int(i - 1)]
            XCTAssert(password == expected, "Wrong password for counter = \(i). Got \(password). Expected value = \(expected).")
        }
    }


    static var allTests : [(String, (OTPKitTests) -> () throws -> Void)] {
        return [
            ("testHOTP", testHOTP),
        ]
    }
}
