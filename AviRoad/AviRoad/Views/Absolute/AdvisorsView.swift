//
//  AdvisorsView.swift
//  AviRoad
//
//  Created by Marwan Tutunji on 18/03/2025.
//

import SwiftUI

struct AdvisorsView: View {
  @ObservedObject var viewModel: MainViewModel
  @State var selectedAdvisor: Advisor?
  @State var searchText: String = ""
  
  init(viewModel: MainViewModel) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    VStack {
      if viewModel.isLoading {
        ProgressView()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      } else {
        List(selection: $selectedAdvisor) {
          Section(
            header: SortOptionsView(viewModel: viewModel)
              .padding(EdgeInsets(top: -12, leading: -27, bottom: 9, trailing: -36))
          ) {
            ForEach(viewModel.advisors) { advisor in
              VStack(alignment: .leading) {
                Text(advisor.name)
                  .foregroundStyle(viewModel.selectedSortOption == .name ? .blue : .primary)
                  .font(.headline)
                Text("Assets: \(advisor.totalAssets, specifier: "%.2f")")
                  .foregroundStyle(viewModel.selectedSortOption == .assets ? .blue : .primary)
                  .bold(viewModel.selectedSortOption == .assets)
                Text("Clients: \(advisor.totalClients)")
                  .foregroundStyle(viewModel.selectedSortOption == .clients ? .blue : .primary)
                  .bold(viewModel.selectedSortOption == .clients)
                Text("Accounts: \(advisor.totalAccounts)")
                  .foregroundStyle(viewModel.selectedSortOption == .accounts ? .blue : .primary)
                  .bold(viewModel.selectedSortOption == .accounts)
              }
              .tag(advisor)
            }
          }
          
          if viewModel.advisors.isEmpty {
            Section() {
              VStack {
                Text("No Advisors found")
                  .foregroundColor(.gray)
                  .italic()
                Button(action: {
                  searchText = ""
                  viewModel.loadAdvisors()
                }) {
                  Image(systemName: "arrow.clockwise.circle.fill")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.gray)
                    .padding()
                }
              }
              .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
          }
        }
        .searchable(text: $searchText, prompt: "Search Advisors")
        .onChange(of: selectedAdvisor) { oldValue, newValue in
          guard let newValue else { return }
          viewModel.didSelectAdvisor(newValue)
        }
        .onChange(of: searchText) { oldValue, newValue in
          viewModel.intentToSearchAdvisors(text: newValue)
        }
        
      }
    }
  }
}

#Preview {
  @Previewable @State var searchText: String = ""
  let viewModel = MainViewModel()
  NavigationSplitView {
    AdvisorsView(viewModel: viewModel)
      .task {
        viewModel.loadAdvisors()
      }
  } detail: {
    Text("Placeholder")
  }
}
