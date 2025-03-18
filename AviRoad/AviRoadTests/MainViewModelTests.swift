//
//  MainViewModelTests.swift
//  AviRoad
//
//  Created by Marwan Tutunji on 18/03/2025.
//

import Testing
@testable import AviRoad

struct MainViewModelTests {
  let mockRepository: AdvisorsRepositoryMock
  let sut: MainViewModel
  
  init() {
    mockRepository = AdvisorsRepositoryMock()
    sut = MainViewModel(advisorsRepository: mockRepository)
  }
  
  @Test("Loads advisors on launch")
  func loadAdvisorsOnLaunch() async throws {
    // Given
    #expect(sut.isLoading == false)
    
    // When
    sut.loadAdvisors()
    #expect(sut.isLoading == true)
    try await Task.sleep(for: .milliseconds(500))
    
    // Then
    #expect(sut.isLoading == false)
    #expect(sut.advisors.count == mockRepository.advisors.count)
  }
  
  @Test("Sorts advisors by name")
  func sortAdvisorsByName() {
    // Given
    sut.loadAdvisors()
    
    // When sorting by name in ascending order
    sut.selectedSortOption = .name
    sut.sortOrderAscending = true
    sut.sortAdvisors()
    
    // Then
    for (index, advisor) in sut.advisors.enumerated() {
      #expect(advisor.name.starts(with: "Mar\(index)") == true)
    }
    
    // When sorting by name in descending order
    sut.sortOrderAscending = false
    sut.sortAdvisors()
    
    // Then
    for (index, advisor) in sut.advisors.enumerated() {
      #expect(advisor.name.starts(with: "Mar\(sut.advisors.count - index)") == true)
    }
  }
  
  @Test("Sorts advisors by assets")
  func sortAdvisorsByAssets() {
    // Given
    sut.loadAdvisors()
    
    // When sorting by assets in ascending order
    sut.selectedSortOption = .assets
    sut.sortOrderAscending = true
    sut.sortAdvisors()
    
    // Then
    zip(sut.advisors, sut.advisors.dropFirst()).forEach {
      #expect($0.totalAssets <= $1.totalAssets)
    }
    
    // When sorting by name in descending order
    sut.sortOrderAscending = false
    sut.sortAdvisors()
    
    // Then
    zip(sut.advisors, sut.advisors.dropFirst()).forEach {
      #expect($0.totalAssets >= $1.totalAssets)
    }
  }
  
  @Test("Sorts advisors by clients")
  func sortAdvisorsByClients() {
    // Given
    sut.loadAdvisors()
    
    // When sorting by assets in ascending order
    sut.selectedSortOption = .clients
    sut.sortOrderAscending = true
    sut.sortAdvisors()
    
    // Then
    zip(sut.advisors, sut.advisors.dropFirst()).forEach {
      #expect($0.totalClients <= $1.totalClients)
    }
    
    // When sorting by name in descending order
    sut.sortOrderAscending = false
    sut.sortAdvisors()
    
    // Then
    zip(sut.advisors, sut.advisors.dropFirst()).forEach {
      #expect($0.totalClients >= $1.totalClients)
    }
  }
  
  @Test("Sorts advisors by accounts")
  func sortAdvisorsByAccounts() {
    // Given
    sut.loadAdvisors()
    
    // When sorting by assets in ascending order
    sut.selectedSortOption = .accounts
    sut.sortOrderAscending = true
    sut.sortAdvisors()
    
    // Then
    zip(sut.advisors, sut.advisors.dropFirst()).forEach {
      #expect($0.totalAccounts <= $1.totalAccounts)
    }
    
    // When sorting by name in descending order
    sut.sortOrderAscending = false
    sut.sortAdvisors()
    
    // Then
    zip(sut.advisors, sut.advisors.dropFirst()).forEach {
      #expect($0.totalAccounts >= $1.totalAccounts)
    }
  }
  
  @Test("Toggles sort order")
  func toggleSortOrder() {
    // Given
    sut.loadAdvisors()
    
    // When sorting by assets in ascending order
    sut.selectedSortOption = .clients
    sut.sortOrderAscending = true
    sut.sortAdvisors()
    
    // Then
    zip(sut.advisors, sut.advisors.dropFirst()).forEach {
      #expect($0.totalClients <= $1.totalClients)
    }
    
    // When sorting by name in descending order
    sut.toggleSortOrder()
    
    // Then
    zip(sut.advisors, sut.advisors.dropFirst()).forEach {
      #expect($0.totalClients >= $1.totalClients)
    }
  }
  
  @Test("Selects sort option")
  func selectSortOption() {
    // Given
    sut.loadAdvisors()
    #expect(sut.selectedSortOption != .assets)
    
    // When selecting a new sort option
    sut.selectSortOption(.assets)
    
    // Then
    #expect(sut.selectedSortOption == .assets)
    zip(sut.advisors, sut.advisors.dropFirst()).forEach {
      #expect($0.totalAssets <= $1.totalAssets)
    }
  }
}
