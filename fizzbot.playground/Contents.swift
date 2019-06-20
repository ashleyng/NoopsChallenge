//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

extension MyViewController {
    public override func loadView() {
        setupUI()
        continueButton.addTarget(self, action: #selector(getRequest), for: .touchUpInside)
        submitButton.addTarget(self, action: #selector(postRequest), for: .touchUpInside)
    }
    
    @objc
    private func getRequest() {
        dataTask?.cancel()
        defer {
            dataTask = nil
        }
        let urlRequest = URLRequest(url: baseUrl.appendingPathComponent(nextUrl))
        dataTask = executeTask(request: urlRequest)
        dataTask?.resume()
    }
    
    @objc
    private func postRequest() {
        dataTask?.cancel()
        defer {
            dataTask = nil
        }
        let parameters = ["answer": textField.text ?? ""]
        var request = URLRequest(url: baseUrl.appendingPathComponent(nextUrl))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return
        }
        request.httpBody = httpBody
        
        dataTask = executeTask(request: request)
        dataTask?.resume()
    }
    
    private func executeTask(request: URLRequest) -> URLSessionDataTask {
        return urlSession.dataTask(with: request) { data, response, error in
            data.parseDataTaskResult(response: response, error: error, completion: { data in
                guard let response = try? self.decoder.decode(GetResponse.self, from: data) else {
                    return
                }
                DispatchQueue.main.async {
                    self.updateUI(with: response)
                }
            }, onError: { error in
                print(error)
            })
        }
    }
}

// Present the view controller in the Live View window
let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 768, height: 1024))
let vc = MyViewController()
window.rootViewController = vc
window.makeKeyAndVisible()
PlaygroundPage.current.liveView = window
