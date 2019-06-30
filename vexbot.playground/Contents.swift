//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

private let maxWidth: Int = 500 //700
private let maxHeight: Int = 800 //1000

private let colors: [UIColor] = [.red, .green, .blue, .cyan, .magenta, .orange, .purple]

class MyViewController : UIViewController {
    let urlSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask? = nil
    let decoder = JSONDecoder()
    let baseUrl = URL(string: "https://api.noopschallenge.com/vexbot")!
    
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: maxWidth, height: maxHeight))
    var generateButton = UIButton(type: .system)
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        
        generateButton.setTitle("Generate Vectors", for: .normal)
        generateButton.tintColor = .blue
        generateButton.addTarget(self, action: #selector(callApi), for: .touchUpInside)
        
        view.addSubview(generateButton)
        
        generateButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            generateButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            generateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        
        self.view = view
    }
    
    @objc
    private func callApi() {
        dataTask?.cancel()
        defer {
            dataTask = nil
        }
        let mag = 50
        let count = 300
        let urlString = baseUrl.absoluteString + "?magnitude=\(mag)&connected=1&width=\(maxWidth)&height=\(maxHeight)&count=\(count)"
        let urlParams = URL(string: urlString)!
        
        dataTask = urlSession.dataTask(with: urlParams) { data, response, error in
            self.parseDataTaskResult(data: data, response: response, error: error) { data in
                guard let vectors = try? self.decoder.decode(Vectors.self, from: data) else {
                    print("failed to decode")
                    return
                }
                DispatchQueue.main.async {
                    print(vectors)
                    self.drawLine(vectors: vectors)
                }
            }
            
        }
        dataTask?.resume()
    }
    
    func drawLine(vectors: Vectors) {
        guard let first = vectors.vectors.first else {
            return
        }
        
        let image = renderer.image { context in
            context.cgContext.move(to: first.pointA)
            context.cgContext.addLine(to: first.pointB)
            context.cgContext.setLineWidth(1)
            let colorIndex = Int.random(in: 0..<colors.count)
            context.cgContext.setStrokeColor(colors[colorIndex].cgColor)
            
            for vector in vectors.vectors {
                context.cgContext.addLine(to: vector.pointB)
                let colorIndex = Int.random(in: 0..<colors.count)
                context.cgContext.setStrokeColor(colors[colorIndex].cgColor)
            }
            context.cgContext.strokePath()

        }

        let imageView = UIImageView(image: image)
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
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
// Present the view controller in the Live View window
let window = UIWindow(frame: CGRect(x: 0, y: 0, width: maxWidth, height: maxHeight))
let vc = MyViewController()
window.rootViewController = vc
window.makeKeyAndVisible()
PlaygroundPage.current.liveView = window
