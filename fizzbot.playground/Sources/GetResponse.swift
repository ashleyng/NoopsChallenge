import Foundation

public struct Rules: Codable {
    public let number: Int
    public let response: String
}

public struct Response: Codable {
    public let answer: String
    
    public init(answer: String) {
        self.answer = answer
    }
}

public struct GetResponse: Codable {
    public let message: String
    public let rules: [Rules]?
    public let numbers: [Int]?
    public let nextQuestion: String?
    public let exampleResponse: Response?
    public let result: String?
}
