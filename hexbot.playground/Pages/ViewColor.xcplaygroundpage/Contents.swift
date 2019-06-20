//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    let urlSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask? = nil
    let decoder = JSONDecoder()
    let baseUrl = URL(string: "http://api.noopschallenge.com/hexbot")!
    
    var button = UIButton(type: .system)
    var colorView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 300))
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        button.setTitle("Get New Color", for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 5
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.tintColor = .white
        button.addTarget(self, action: #selector(fetchNewColor), for: .touchUpInside)
        
        colorView.backgroundColor = .blue
        
        button.translatesAutoresizingMaskIntoConstraints = false
        colorView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(button)
        view.addSubview(colorView)
        
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        self.view = view
    }
    
    @objc
    private func fetchNewColor() {
        dataTask?.cancel()
        defer {
            dataTask = nil
        }
        
        dataTask = urlSession.dataTask(with: baseUrl) { data, response, error in
            self.parseDataTaskResult(data: data, response: response, error: error, completion: { data in
                guard let colors = try? self.decoder.decode(Colors.self, from: data) else {
                    return
                }
                guard var firstColor = colors.hexValues.first else { return }
                let _ = String(firstColor.removeFirst())
                guard let colorVal = UIColor(hexString: firstColor) else {
                    return
                }
                DispatchQueue.main.async {
                    self.colorView.backgroundColor = colorVal
                }
            })
        }
        dataTask?.resume()
    }
    
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

PlaygroundPage.current.liveView = MyViewController()
