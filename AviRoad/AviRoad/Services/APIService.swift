//
//  APIService.swift
//  AviRoad
//
//  Created by Marwan Tutunji on 14/03/2025.
//

import Foundation
import Combine

protocol APIEndpoint {
  var baseURL: URL { get }
  var path: String { get }
  var method: HTTPMethod { get }
  var headers: [String: String]? { get }
  var parameters: [String: Any]? { get }
  var mockResponseData: Data? { get }
}

extension APIEndpoint {
  var headers: [String: String]? {
    return nil
  }
  
  var parameters: [String: Any]? {
    return nil
  }
  
  var mockResponseData: Data? {
    return nil
  }
}

enum APIError: Error {
  case invalidResponse
  case invalidData
  case decodingFailed(Error?)
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

protocol APIClient {
  associatedtype EndpointType: APIEndpoint
  var isMocking: Bool { get }
  func request<T: Decodable>(_ endpoint: EndpointType) -> AnyPublisher<T, Error>
}

class URLSessionAPIClient<EndpointType: APIEndpoint>: APIClient {
  var isMocking: Bool {
#if MOCK_API
    return true
#else
    return false
#endif
  }
  
  func request<T: Decodable>(_ endpoint: EndpointType) -> AnyPublisher<T, Error> {
    guard !isMocking else {
      return mockRequest(endpoint)
    }
    let url = endpoint.baseURL.appendingPathComponent(endpoint.path)
    var request = URLRequest(url: url)
    request.httpMethod = endpoint.method.rawValue
    
    // Set up any request headers or parameters here
    endpoint.headers?.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
    
    return URLSession.shared.dataTaskPublisher(for: request)
      .subscribe(on: DispatchQueue.global(qos: .background))
      .tryMap { data, response -> Data in
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
          throw APIError.invalidResponse
        }
        return data
      }
      .decode(type: T.self, decoder: JSONDecoder())
      .eraseToAnyPublisher()
  }
  
  private func mockRequest<T: Decodable>(_ endpoint: EndpointType) -> AnyPublisher<T, Error> {
    guard let data = endpoint.mockResponseData else {
      return Fail<T, Error>(error: APIError.invalidData).eraseToAnyPublisher()
    }
    do {
      let items = try JSONDecoder().decode(T.self, from: data)
      return Just(items).setFailureType(to: Error.self).eraseToAnyPublisher()
    } catch {
      return Fail<T, Error>(error: APIError.decodingFailed(error)).eraseToAnyPublisher()
    }
  }
}
