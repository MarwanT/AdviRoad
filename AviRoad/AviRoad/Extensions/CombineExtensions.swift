//
//  CombineExtensions.swift
//  AviRoad
//
//  Created by Marwan Tutunji on 12/03/2025.
//

import Combine

extension AnyPublisher {
  func async() async throws -> Output {
    try await withCheckedThrowingContinuation { continuation in
      var cancellable: AnyCancellable?
      cancellable = self.sink(
        receiveCompletion: { completion in
          if case .failure(let error) = completion {
            continuation.resume(throwing: error)
          }
          cancellable?.cancel()
        },
        receiveValue: { value in
          continuation.resume(returning: value)
          cancellable?.cancel()
        }
      )
    }
  }
}
