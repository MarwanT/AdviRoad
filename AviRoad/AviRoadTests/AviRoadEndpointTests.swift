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
  
  @Test("Fetches the advisor mock response and parses it")
  func parseAdvisorAPIResponse() async throws {
    // Given
    let advisorId = "550e8400-e29b-41d4-a716-446655440007"
    let api: AviRoadEndpoint = .advisor(id: advisorId)
    // When
    let result: AdvisorResponse = try await sut.request(api).async()
    // Then
    #expect(result.advisor.id == advisorId)
    #expect(result.advisor.accounts?.count == 9)
    #expect(result.securities.count == 9)
  }
}
