import Foundation
import CoreGraphics

public struct Point: Codable {
    public let x: Int
    public let y: Int
}

public struct Vector: Codable {
    public let pointA: CGPoint
    public let pointB: CGPoint
    public let speed: Int
    
    enum CodingKeys: String, CodingKey {
        case pointA = "a"
        case pointB = "b"
        case speed
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let pointA = try values.decode(Point.self, forKey: .pointA)
        let pointB = try values.decode(Point.self, forKey: .pointB)
        let speed = try values.decode(Int.self, forKey: .speed)
        self.pointA = CGPoint(x: abs(pointA.x), y: abs(pointA.y))
        self.pointB = CGPoint(x: abs(pointB.x), y: abs(pointB.y))
        self.speed = speed
    }
}

public struct Vectors: Codable {
    public let vectors: [Vector]
}
