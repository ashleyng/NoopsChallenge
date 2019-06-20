import Foundation
import UIKit

public class MyViewController: UIViewController {
    public let urlSession = URLSession(configuration: .default)
    public var dataTask: URLSessionDataTask? = nil
    public let decoder = JSONDecoder()
    public let baseUrl = URL(string: "https://api.noopschallenge.com")!
    
    public var nextUrl = "/fizzbot"
    public var problemNumbers: [Int] = []
    
    public let messageLabel = UILabel()
    public let numbersLabel = UILabel()
    public let textField = UITextField()
    public let continueButton = UIButton(type: .system)
    public let submitButton = UIButton(type: .system)
    
    public func setupUI() {
        let view = UIView()
        view.backgroundColor = .white
        
        messageLabel.numberOfLines = 0
        messageLabel.text = "Welcome to FizzBot"
        
        continueButton.setTitle("Proceed With Test", for: .normal)
        continueButton.backgroundColor = UIColor(red: 62/255, green: 171/255, blue: 102/255, alpha: 1)
        continueButton.layer.cornerRadius = 5
        continueButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        continueButton.tintColor = .white
        
        submitButton.setTitle("Submit", for: .normal)
        submitButton.backgroundColor = UIColor(red: 21/255, green: 101/255, blue: 232/255, alpha: 1)
        submitButton.layer.cornerRadius = 5
        submitButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        submitButton.tintColor = .white
        
        numbersLabel.text = problemNumbers.map { "\($0)" }.joined(separator: ", ")
        numbersLabel.numberOfLines = 0
        
        textField.borderStyle = .roundedRect
        textField.placeholder = "What's up gamers"
        
        let buttonView = UIStackView(arrangedSubviews: [continueButton, submitButton])
        buttonView.spacing = 8
        buttonView.distribution = .equalCentering
        
        view.addSubview(messageLabel)
        view.addSubview(numbersLabel)
        view.addSubview(textField)
        view.addSubview(buttonView)
        
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        numbersLabel.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            buttonView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            buttonView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 8),
            
            numbersLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            numbersLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 8),
            numbersLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            numbersLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 8),
            
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            textField.topAnchor.constraint(equalTo: numbersLabel.bottomAnchor, constant: 8)
            ])
        
        textField.isHidden = true
        submitButton.isEnabled = false
        
        self.view = view
    }
    
    public func updateUI(with response: GetResponse) {
        self.nextUrl = response.nextQuestion ?? self.nextUrl
        var combinedString = response.message
        if let exampleResponse = response.exampleResponse {
            combinedString += "\n\n Example Response: \(exampleResponse.answer)"
        }
        
        if response.numbers != nil || response.exampleResponse != nil {
            self.textField.isHidden = false
            self.submitButton.isEnabled = true
            self.continueButton.isEnabled = false
        } else {
            self.textField.isHidden = true
            self.submitButton.isEnabled = false
            self.continueButton.isEnabled = true
        }
        
        if let numbers = response.numbers {
            self.numbersLabel.text = numbers.map { "\($0)" }.joined(separator: ", ")
            self.textField.text = numbers.map { "\($0)" }.joined(separator: " ")
        } else {
            self.numbersLabel.text = ""
            self.textField.text = ""
        }
        
        self.messageLabel.text = combinedString
        self.continueButton.setTitle("Continue", for: .normal)
    }
}
