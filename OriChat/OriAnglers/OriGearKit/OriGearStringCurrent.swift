import Foundation

extension String {
    @usableFromInline
    var decrypted: String {
        var result = ""
        let characters = Array(self)
        var index = 0
        while index < characters.count {
            result.append(characters[index])
            index += 3
        }
        return result
    }
}

prefix operator ~

@inlinable
prefix func ~ (obfuscated: String) -> String {
    obfuscated.decrypted
}
