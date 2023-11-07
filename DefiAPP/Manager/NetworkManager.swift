//
//  NetworkManager.swift
//  DefiAPP
//
//  Created by 彥甫陳 on 2023/11/1.
//

import Foundation

enum APIError: Error {
    case networkError(Error)
    case invalidStatusCode(Int, String)
    case apiError(message: String)
}


class NetworkManager {
    static let shared = NetworkManager()
    
    func fetchData<T :Decodable>(urlStr: String, method: String, parameters: [String: Any]? = nil, isToken: Bool, completion: @escaping(Result<T, APIError>) -> Void) {
        
        guard let url = URL(string: "https://api.irwa.io/\(urlStr)") else {
            completion(.failure(.apiError(message: "url nil")))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if isToken {
            request.setValue("Bearer \(getToken())", forHTTPHeaderField: "Authorization")
        }
        
        if let parameters = parameters {
            if method == "GET" {
                var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
                components?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
                if let urlWithQuery = components?.url {
                    request.url = urlWithQuery
                }
            }else if method == "POST" {
                do {
                    let requestData = try JSONSerialization.data(withJSONObject: parameters)
                    request.httpBody = requestData
                } catch {
                    completion(.failure(.networkError(error)))
                    return
                }
            }
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let data = data, let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidStatusCode(0, "Invalid response")))
                return
            }
            
            if httpResponse.statusCode != 200 {
                if let apiError = try? JSONDecoder().decode(APIErrorModel.self, from: data) {
                    completion(.failure(.apiError(message: apiError.message ?? "api error")))
                }
            }else {
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedData))
                }catch {
                    completion(.failure(.networkError(error)))
                }
            }
        }.resume()
        
    }
    
    //取得Token判斷是否過期
    func getToken() -> String {
        let expTime = UD.integer(forKey: "expTime")
        let nowTime = GC.getTimeInterval()
        if expTime > nowTime {
            if let token = UD.string(forKey: "token") {
                return token
            }else {
                return ""
            }
        }else {
            //token過期登出
            return ""
        }
    }
    
    
}


struct APIErrorModel: Codable {
   let statusCode: Int?
   let success: Bool
   let message: String?
   let timestamp: Int?
}
