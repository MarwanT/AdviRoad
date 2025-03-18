//
//  AdvisorDetailsViewModel.swift
//  AviRoad
//
//  Created by Marwan Tutunji on 18/03/2025.
//

import Combine
import Foundation
import SwiftUI

@Observable
final class AdvisorDetailsViewModel {
  var advisor: Advisor? {
    didSet {
      if firstViewLoad {
        loadAdvisorDetails()
      }
    }
  }
  var selectedAdvisorName: String?
  private(set) var isLoading = false
  private var firstViewLoad: Bool = true
  
  private var advisorNameMock: String?
  
  private let advisorsRepository: AdvisorsRepository
  private var cancellables: Set<AnyCancellable> = []
  
  init(advisorsRepository: AdvisorsRepository = DefaultAdvisorsRepository()) {
    self.advisorsRepository = advisorsRepository
  }
  
  func loadAdvisorDetails() {
    isLoading = true
    guard let advisorId = advisor?.id else {
      return
    }
    self.advisorsRepository.fetchAdvisor(id: advisorId)
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { [weak self] _ in
        self?.firstViewLoad = false
        self?.isLoading = false
      }, receiveValue: { [weak self] in
        self?.advisor = $0
      })
      .store(in: &cancellables)
      
  }
}
