import Foundation

class APIClient {
    private let enhancePromptURL = URL(string: "http://localhost:7172/api/enhance")!
    private let enhanceGrammarURL = URL(string: "http://localhost:7172/api/grammar")!
    
    func enhance(_ text: String, cmd: String, completion: @escaping (Result<String, Error>) -> Void) {
        var request = URLRequest(url: cmd == "E" ? enhancePromptURL : enhanceGrammarURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let payload: [String: String] = ["text": text]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload)
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "APIClient", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let enhancedText = json["result"] as? String {
                    completion(.success(enhancedText))
                } else if let enhancedText = String(data: data, encoding: .utf8) {
                    completion(.success(enhancedText))
                } else {
                    completion(.failure(NSError(domain: "APIClient", code: -1, userInfo: [NSLocalizedDescriptionKey: "Could not parse response"])))
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
