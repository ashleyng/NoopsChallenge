import UIKit

public extension UIColor {
    // https://gist.github.com/yannickl/16f0ed38f0698d9a8ae7
    convenience init?(hexString: String) {
        guard let intValue = Int(hexString, radix: 16) else { return nil }

        let red = CGFloat((intValue >> 16) & 0xff)
        let green = CGFloat((intValue >> 8) & 0xff)
        let blue = CGFloat(intValue & 0xff)

        self.init(red: red / 255 , green: green / 255, blue: blue / 255, alpha: 1.0)
    }
    
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (red, green, blue, alpha)
    }
}
