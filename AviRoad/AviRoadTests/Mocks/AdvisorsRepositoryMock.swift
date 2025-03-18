//
//  AdvisorsRepositoryMock.swift
//  AviRoad
//
//  Created by Marwan Tutunji on 18/03/2025.
//

import Combine
@testable import AviRoad

final class AdvisorsRepositoryMock: AdvisorsRepository {
  private let mockManager = MockManager()
  var shouldFailReuqest: Bool = false
  
  var advisors: [Advisor] = []
  
  init() {
    advisors = mockManager.advisorsInstances(9)
  }
  
  func fetchAdvisors() -> AnyPublisher<[Advisor], AdvisorsRepositoryError> {
    return Just(advisors).setFailureType(to: AdvisorsRepositoryError.self).eraseToAnyPublisher()
  }
  
  func fetchAdvisor(id: String) -> AnyPublisher<Advisor?, AdvisorsRepositoryError> {
    return Just(advisors[4]).setFailureType(to: AdvisorsRepositoryError.self).eraseToAnyPublisher()
  }
}
