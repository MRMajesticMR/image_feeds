//
//  OAuth2Service.swift
//  Image Feed
//
//  Created by Аркадий Захаров on 27.12.2023.
//

import Foundation

class OAuth2Service {
    
    static let shared = OAuth2Service()
    
    private let decoder = JSONDecoder()
    private let urlSession = URLSession.shared
    private let oAuth2TokenStorage: OAuth2TokenStorage = OAuth2TokenStorage.shared
    
    private let baseUrl = "https://unsplash.com"
    
    private let _clientId: String
    private let _clientSecret: String
    private let _redirectUri: String
    
    init(clientId: String = AccessKey,
         clientSecret: String = SecretKey,
         redirectUri: String = RedirectURI) {
        _clientId = clientId
        _clientSecret = clientSecret
        _redirectUri = redirectUri
    }
    
    func fetchAuthToken(code: String,
                        completion: @escaping (Result<Void, Error>) -> Void) {
        let fulfillCompletion: (Result<Void, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        var urlComponents = URLComponents(string: "\(baseUrl)/oauth/token")!
        urlComponents.queryItems = [URLQueryItem(name: "client_id", value: _clientId),
                                    URLQueryItem(name: "client_secret", value: _clientSecret),
                                    URLQueryItem(name: "redirect_uri", value: _redirectUri),
                                    URLQueryItem(name: "code", value: code),
                                    URLQueryItem(name: "grant_type", value: "authorization_code")]
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "POST"
        
        let task = urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                fulfillCompletion(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode < 200 || response.statusCode >= 300 {
                fulfillCompletion(.failure(NetworkError.httpStatusCode(response.statusCode)))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let object = try self.decoder.decode(OAuthTokenResponseBody.self, from: data)
                self.oAuth2TokenStorage.saveToken(object.accessToken)
                
                fulfillCompletion(.success(Void()))
            } catch {
                fulfillCompletion(.failure(NetworkError.parseError))
            }
        }
        task.resume()
    }
}
