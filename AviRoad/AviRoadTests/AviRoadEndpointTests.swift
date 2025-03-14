//
//  AviRoadEndpointTests.swift
//  AviRoad
//
//  Created by Marwan Tutunji on 14/03/2025.
//

import CoreData
import Combine
import Testing
@testable import AviRoad

struct AviRoadEndpointTests {
  let sut = URLSessionAPIClient<AviRoadEndpoint>()
  var cancellables: Set<AnyCancellable> = []
  
  @Test("Fetches the dashboard mock response and parses it")
  func parseDashboardAPIResponse() async throws {
    // Given
    let api: AviRoadEndpoint = .dashboard
    // When
    let result: DashboardResponse = try await sut.request(api).async()
    // Then
    #expect(result.advisors.count == 10)
    let expectedFirstAdvisor = MockManager.firstMockAdvisor
    #expect(expectedFirstAdvisor == result.advisors.first)
  }
}
