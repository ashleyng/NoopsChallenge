import Foundation

public struct Colors: Codable {
    public let hexValues: [String]
    
    enum CodingKeys: String, CodingKey {
        case hexValues = "colors"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let colorsDict = try values.decode([[String: String]].self, forKey: .hexValues)
        hexValues = colorsDict.compactMap { $0.first?.value }
    }
}
