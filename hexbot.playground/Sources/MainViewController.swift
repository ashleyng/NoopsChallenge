import Foundation
import UIKit

public class MainViewController: UIViewController {
    let urlSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask? = nil
    let decoder = JSONDecoder()
    let baseUrl = URL(string: "http://api.noopschallenge.com/hexbot")!
    
    var button = UIButton(type: .system)
    var colorView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 300))
    var completion: ((UIColor) -> ())?
    
    func parseDataTaskResult(data: Data?,
                             response: URLResponse?,
                             error: Error?,
                             completion: ((Data) -> Void)? = nil) {
        if let data = data,
            let response = response as? HTTPURLResponse {
            if (response.statusCode == 200) {
                completion?(data)
            }
        }
    }
}
