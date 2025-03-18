//
//  MainContentView.swift
//  AviRoad
//
//  Created by Marwan Tutunji on 12/03/2025.
//

import SwiftUI
import SwiftData

struct MainContentView: View {
  @StateObject var viewModel: MainViewModel = MainViewModel()
  
  var body: some View {
    NavigationSplitView {
      AdvisorsView(viewModel: viewModel)
    } detail: {
      AdvisorDetailView(viewModel: viewModel.detailsViewModel)
    }
    .task {
      viewModel.loadAdvisors()
    }
  }
}

#Preview {
  MainContentView()
}
