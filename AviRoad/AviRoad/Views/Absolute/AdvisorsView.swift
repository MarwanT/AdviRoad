//
//  AdvisorsView.swift
//  AviRoad
//
//  Created by Marwan Tutunji on 18/03/2025.
//

import SwiftUI

struct AdvisorsView: View {
  var viewModel: MainViewModel
  @State var selectedAdvisor: Advisor?
  
  init(viewModel: MainViewModel) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    VStack {
      SortOptionsView(viewModel: viewModel)
        .padding()
      
      if viewModel.isLoading {
        ProgressView()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      } else {
        List(viewModel.advisors, selection: $selectedAdvisor) { advisor in
          VStack(alignment: .leading) {
            Text(advisor.name)
              .font(.headline)
            Text("Assets: \(advisor.totalAssets, specifier: "%.2f")")
              .foregroundStyle(viewModel.selectedSortOption == .assets ? .blue : .black)
              .bold(viewModel.selectedSortOption == .assets)
            Text("Clients: \(advisor.totalClients)")
              .foregroundStyle(viewModel.selectedSortOption == .clients ? .blue : .black)
              .bold(viewModel.selectedSortOption == .clients)
            Text("Accounts: \(advisor.totalAccounts)")
              .foregroundStyle(viewModel.selectedSortOption == .accounts ? .blue : .black)
              .bold(viewModel.selectedSortOption == .accounts)
          }
          .tag(advisor)
        }
        .onChange(of: selectedAdvisor) { oldValue, newValue in
          guard let newValue else { return }
          viewModel.didSelectAdvisor(newValue)
        }
      }
    }
  }
}

#Preview {
  let viewModel = MainViewModel()
  AdvisorsView(viewModel: viewModel)
    .task {
      viewModel.loadAdvisors()
    }
}
