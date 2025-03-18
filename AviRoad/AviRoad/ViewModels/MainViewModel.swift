//
//  MainViewModel.swift
//  AviRoad
//
//  Created by Marwan Tutunji on 18/03/2025.
//

import Combine
import Foundation


final class MainViewModel: ObservableObject {
  @Published var advisors: [Advisor] = []
  @Published var sortOrderAscending: Bool = true
  @Published var selectedSortOption: SortOption = .name
  @Published var isLoading: Bool = false
  @Published var searchText: String = ""
  
  private let advisorsRepository: AdvisorsRepository
  private var cachedAdvisors: [Advisor] = []
  private var cancellables: Set<AnyCancellable> = []
  
  private(set) var detailsViewModel: AdvisorDetailsViewModel
  
  init(
    advisorsRepository: AdvisorsRepository = DefaultAdvisorsRepository(),
    detailsViewModel: AdvisorDetailsViewModel = AdvisorDetailsViewModel()) {
      self.advisorsRepository = advisorsRepository
      self.detailsViewModel = detailsViewModel
      $searchText
        .debounce(for: .milliseconds(400), scheduler: DispatchQueue.main)
        .sink(receiveValue: { [weak self] value in
          print("After Debounce do the search: \(value)")
          self?.searchAdvisors()
        } )
        .store(in: &cancellables)
    }
  
  func loadAdvisors() {
    isLoading = true
    advisorsRepository.fetchAdvisors()
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        self?.isLoading = false
        switch completion {
        case .failure(let error):
          print("Error: \(error)")
        case .finished:
          break
        }
      } receiveValue: { [weak self] advisors in
        self?.advisors = advisors
        self?.cachedAdvisors = advisors
        self?.sortAdvisors()
      }
      .store(in: &cancellables)
  }
  
  func didSelectAdvisor(_ advisor: Advisor) {
    detailsViewModel.advisor = advisor
    detailsViewModel.selectedAdvisorName = advisor.name
  }
  
  func intentToSearchAdvisors(text: String) {
    searchText = text
  }
  
  private func searchAdvisors() {
    guard !searchText.isEmpty else {
      advisors = cachedAdvisors
      sortAdvisors()
      return
    }
    let lowercasedSearchableText = searchText.lowercased()
    advisors = cachedAdvisors.filter { advisors in
      return advisors.searchableText.contains(lowercasedSearchableText)
    }
  }
  
  func sortAdvisors() {
    switch selectedSortOption {
    case .name:
      advisors.sort {
        sortOrderAscending ?
        $0.name < $1.name : $0.name > $1.name
      }
    case .assets:
      advisors.sort {
        sortOrderAscending ?
        $0.totalAssets < $1.totalAssets : $0.totalAssets > $1.totalAssets
      }
    case .clients:
      advisors.sort {
        sortOrderAscending ?
        $0.totalClients < $1.totalClients : $0.totalClients > $1.totalClients
      }
    case .accounts:
      advisors.sort {
        sortOrderAscending ?
        $0.totalAccounts < $1.totalAccounts : $0.totalAccounts > $1.totalAccounts
      }
    }
  }
  
  func toggleSortOrder() {
    sortOrderAscending.toggle()
    sortAdvisors()
  }
  
  func selectSortOption(_ option: SortOption) {
    selectedSortOption = option
    sortAdvisors()
  }
}

extension MainViewModel {
  enum SortOption: String, CaseIterable {
    case name = "Name"
    case assets = "Assets"
    case clients = "Clients"
    case accounts = "Accounts"
  }
}
