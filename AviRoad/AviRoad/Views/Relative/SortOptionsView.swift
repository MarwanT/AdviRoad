//
//  SortOptionsView.swift
//  AviRoad
//
//  Created by Marwan Tutunji on 18/03/2025.
//

import Combine
import SwiftUI

struct SortOptionsView: View {
  @ObservedObject var viewModel: MainViewModel
  
  var body: some View {
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
          .foregroundColor(.blue)
          .cornerRadius(9)
      }
    }
  }
}

#Preview {
  let viewModel = MainViewModel()
  SortOptionsView(viewModel: viewModel)
}
