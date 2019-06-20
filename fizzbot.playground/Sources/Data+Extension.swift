import Foundation

public extension Optional where Wrapped == Data {
    func parseDataTaskResult(response: URLResponse?,
                                    error: Error?,
                                    completion: ((Data) -> Void)? = nil,
                                    onError: ((Error) -> Void)? = nil) {
        if let data = self,
            let response = response as? HTTPURLResponse {
            if (response.statusCode == 200) {
                completion?(data)
            } else if response.statusCode == 400, let error = error {
                onError?(error)
            }
        }
    }
}
