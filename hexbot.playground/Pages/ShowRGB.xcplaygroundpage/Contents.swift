//: [Previous](@previous)

import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    let urlSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask? = nil
    let decoder = JSONDecoder()
    let baseUrl = URL(string: "http://api.noopschallenge.com/hexbot")!
    
    var button = UIButton(type: .system)
    var colorView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 300))
    var redLabel = UILabel()
    var blueLabel = UILabel()
    var greenLabel = UILabel()
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        
        button.setTitle("Get New Color", for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 5
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.tintColor = .white
        button.addTarget(self, action: #selector(fetchNewColor), for: .touchUpInside)
        
        redLabel.text = "Red"
        greenLabel.text = "Green"
        blueLabel.text = "Blue"
        
        colorView.backgroundColor = .blue
        
        let stackView = UIStackView(arrangedSubviews: [redLabel, blueLabel, greenLabel])
        stackView.axis = .vertical
        
        view.addSubview(button)
        view.addSubview(stackView)
        view.addSubview(colorView)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        colorView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -16),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
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
                let rgba = colorVal.rgba
                DispatchQueue.main.async {
                    self.colorView.backgroundColor = colorVal
                    self.redLabel.textColor = UIColor(red: rgba.red, green: 0, blue: 0, alpha: 1)
                    self.redLabel.text = "Red \(Int(rgba.red * 255))"
                    self.greenLabel.textColor = UIColor(red: 0, green: rgba.green, blue: 0, alpha: 1)
                    self.greenLabel.text = "Green \(Int(rgba.green * 255))"
                    self.blueLabel.textColor = UIColor(red: 0, green: 0, blue: rgba.blue, alpha: 1)
                    self.blueLabel.text = "Blue \(Int(rgba.blue * 255))"
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


//: [Next](@next)
