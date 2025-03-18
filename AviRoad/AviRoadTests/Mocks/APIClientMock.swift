//
//  APIClientMock.swift
//  AviRoad
//
//  Created by Marwan Tutunji on 16/03/2025.
//

import Combine
@testable import AviRoad

class APIClientMock<EndpointType: APIEndpoint>: APIClient {
  private let mockManager: MockManager = MockManager()
  var shouldFailRequest: Bool = false
  
  let advisors: [Advisor]
  let securities: [Security]
  
  init() {
    advisors = mockManager.advisorsInstances(12)
    securities = mockManager.securityInstance()
  }
  
  var isMocking: Bool {
    return true
  }
  
  func request<T: Decodable>(_ endpoint: EndpointType) -> AnyPublisher<T, Error> {
    guard !shouldFailRequest else {
      return Fail(error: APIClientMockError.failedResponse).eraseToAnyPublisher()
    }
    if T.self == DashboardResponse.self {
      let dashboardResponse = DashboardResponse(advisors: advisors)
      return Just(dashboardResponse as! T)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    } else if T.self == AdvisorResponse.self {
      let advisorResponse = AdvisorResponse(advisor: advisors[4], securities: securities)
      return Just(advisorResponse as! T)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    } else {
      return Empty<T, Error>().eraseToAnyPublisher()
    }
  }
}

enum APIClientMockError: Error {
  case failedResponse
}
