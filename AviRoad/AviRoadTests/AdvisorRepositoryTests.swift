//
//  AdvisorRepositoryTests.swift
//  AviRoad
//
//  Created by Marwan Tutunji on 16/03/2025.
//

import CoreData
import Combine
import Testing
@testable import AviRoad

struct AdvisorRepositoryTests {
  let mockAPIClient: APIClientMock<AviRoadEndpoint>
  let mockDataPersistence: DataPersistenceMock
  let sut: AdvisorsRepository
  
  init() {
    mockAPIClient = .init()
    mockDataPersistence = .init()
    sut = DefaultAdvisorsRepository(apiClient: mockAPIClient, dataPersistence: mockDataPersistence)
  }
  
  @Test("fetches Advisors from API and saves in persistence layer")
  func fetchAdvisorsFromAPIAndSavesInPersistenceLayer() async throws {
    // Given
    mockAPIClient.shouldFailRequest = false
    
    // When
    let results = try await sut.fetchAdvisors().async()
    
    // Then
    #expect(results.count == mockAPIClient.advisors.count)
    let savedEntities = try await mockDataPersistence.fetchAll(AdvisorEntity.self).async()
    let savedStructures = savedEntities.map({ Advisor(from: $0) })
    #expect(savedStructures.count == results.count)
    results.forEach { advisor in
      #expect(savedStructures.contains(where: { $0 == advisor }))
    }
  }
  
  @Test("fetches Advisors from persistence layer when api fails")
  func fetchAdvisorsFromPersistenceLayerWhenApiFails() async throws {
    // Given
    mockAPIClient.shouldFailRequest = true
    mockDataPersistence.populateSampleData()
    #expect(mockDataPersistence.advisors.count > 0)
    
    // When
    let results = try await sut.fetchAdvisors().async()
    
    // Then
    #expect(results.count == mockDataPersistence.advisors.count)
  }
  
  @Test("fetches an adivor from API and saves the advisor details and securities")
  func fetchAnAdivorFromAPIAndSavesTheAdvisorDetailsAndSecurities() async throws {
    // Given
    mockAPIClient.shouldFailRequest = false
    
    // When
    let advisor = try await sut.fetchAdvisor(id: "ANY_ID").async()
    
    // Then
    #expect(advisor != nil)
    #expect(advisor!.securities != nil)
    #expect(advisor!.securities?.count  == 2)
    let savedEntities = try await mockDataPersistence.fetchAll(AdvisorEntity.self).async()
    let savedStructures = savedEntities.map({ Advisor(from: $0) })
    #expect(savedStructures.count == 1)
    #expect(advisor == savedStructures[0])
  }
  
  @Test("fetches advisor details from persistence layer when api fails")
  func fetchAnAdivorFromPersistenceLayerWhenApiFails() async throws {
    // Given
    mockAPIClient.shouldFailRequest = true
    mockDataPersistence.populateSampleData()
    #expect(mockDataPersistence.advisors.count > 0)
    
    // When
    let advisor = try await sut.fetchAdvisor(id: "ANY_ID").async()
    // Then
    #expect(advisor != nil)
    #expect(advisor!.securities != nil)
    #expect(advisor!.securities?.count ?? 0  > 0)
  }
}
