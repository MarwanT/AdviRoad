//
//  MainContentView.swift
//  AviRoad
//
//  Created by Marwan Tutunji on 12/03/2025.
//

import SwiftUI
import SwiftData

struct MainContentView: View {
  @State var viewModel: MainViewModel
  
  init() {
    viewModel = MainViewModel()
  }
  
  var body: some View {
    VStack {
      HStack {
        ScrollView(.horizontal, showsIndicators: false) {
          HStack {
            ForEach(MainViewModel.SortOption.allCases, id: \.self) { option in
              Button(action: {
                viewModel.selectSortOption(option)
              }) {
                Text(option.rawValue)
                  .padding()
                  .frame(height: 40)
                  .background(viewModel.selectedSortOption == option ? Color.blue : Color.gray)
                  .foregroundStyle(.white)
                  .bold(viewModel.selectedSortOption == option)
                  .cornerRadius(18)
              }
            }
          }
        }
        Button(action: {
          viewModel.toggleSortOrder()
        }) {
          Image(systemName: "triangle.fill")
            .rotationEffect(viewModel.sortOrderAscending ? .zero : .degrees(180))
            .padding()
            .frame(height: 40)
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(9)
        }
      }
      .padding()
      
      if (viewModel.isLoading) {
        Spacer()
        ProgressView()
        Spacer()
      } else {
        List(viewModel.advisors) { advisor in
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
          .padding()
        }
      }
      
      Spacer()
    }
    .task {
      viewModel.loadAdvisors()
    }
  }
}

#Preview {
  MainContentView()
}
