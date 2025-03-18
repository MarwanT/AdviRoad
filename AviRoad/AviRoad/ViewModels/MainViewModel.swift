//
//  MainViewModel.swift
//  AviRoad
//
//  Created by Marwan Tutunji on 18/03/2025.
//

import Combine
import Foundation

@Observable
final class MainViewModel {
  var advisors: [Advisor] = []
  var sortOrderAscending: Bool = true
  var selectedSortOption: SortOption = .name
  var isLoading: Bool = false
  
  private let advisorsRepository: AdvisorsRepository
  private var cancellables: Set<AnyCancellable> = []
  
  private(set) var detailsViewModel: AdvisorDetailsViewModel
  
  init(
    advisorsRepository: AdvisorsRepository = DefaultAdvisorsRepository(),
    detailsViewModel: AdvisorDetailsViewModel = AdvisorDetailsViewModel()) {
      self.advisorsRepository = advisorsRepository
      self.detailsViewModel = detailsViewModel
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
        self?.sortAdvisors()
      }
      .store(in: &cancellables)
  }
  
  func didSelectAdvisor(_ advisor: Advisor) {
    detailsViewModel.advisor = advisor
    detailsViewModel.selectedAdvisorName = advisor.name
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
