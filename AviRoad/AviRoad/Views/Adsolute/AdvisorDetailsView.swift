//
//  AdvisorDetailsView.swift
//  AviRoad
//
//  Created by Marwan Tutunji on 18/03/2025.
//

import SwiftUI

struct AdvisorDetailView: View {
  @State var viewModel: AdvisorDetailsViewModel
  
  var body: some View {
    if let advisor = viewModel.advisor {
      NavigationStack {
        List {
          Section(header: Text("Overview")) {
            Text("Total Assets: \(advisor.totalAssets, specifier: "%.2f")")
            Text("Total Clients: \(advisor.totalClients)")
            Text("Total Accounts: \(advisor.totalAccounts)")
          }
          
          if let accounts = advisor.accounts, !accounts.isEmpty {
            Section(header: Text("Accounts")) {
              ForEach(accounts) { account in
                VStack(alignment: .leading) {
                  Text("Name: \(account.name)")
                  Text("Number: \(account.number)")
                  Text("Holdings: \(account.holdings.count)")
                }
                .padding(.vertical, 5)
              }
            }
          }
          
          if !advisor.custodians.isEmpty {
            Section(header: Text("Custodians")) {
              ForEach(advisor.custodians) { custodian in
                VStack(alignment: .leading) {
                  Text("Name: \(custodian.name)")
                  if let repId = custodian.repId {
                    Text("Rep ID: \(repId)")
                  }
                }
                .padding(.vertical, 5)
              }
            }
          }
          
          if let securities = advisor.securities, !securities.isEmpty {
            Section(header: Text("Securities")) {
              ForEach(securities) { security in
                VStack(alignment: .leading) {
                  Text("Ticker: \(security.ticker)")
                  Text("Name: \(security.name)")
                  Text("Category: \(security.category)")
                  Text("Date Added: \(security.dateAdded.ISO8601Format())")
                }
                .padding(.vertical, 5)
              }
            }
          }
        }
        .navigationTitle("\(advisor.name)")
        .listStyle(InsetGroupedListStyle())
      }
    } else {
      Text("Select an advisor to see details")
        .foregroundColor(.gray)
        .italic()
    }
  }
}

#Preview {
  let viewModel: AdvisorDetailsViewModel = {
    let viewModel = AdvisorDetailsViewModel()
    viewModel.advisor = Advisor(
      id: "1",
      firstName: "John",
      lastName: "Doe",
      totalAssets: 1000000,
      totalClients: 100,
      totalAccounts: 100,
      custodians: [
        Custodian(id: "1", name: "Custodian A", repId: "123"),
        Custodian(id: "2", name: "Custodian B", repId: nil)
      ],
      accounts: [
        Account(
          id: "1",
          name: "Account A",
          number: "001",
          clientId: "10",
          advisorId: "1",
          custodianId: "1",
          holdings: [
            Holding(id: "1", ticker: "AAPL", units: 10, unitPrice: 150.0),
            Holding(id: "2", ticker: "GOOGL", units: 5, unitPrice: 2800.0)
          ]
        )
      ])
    viewModel.advisor?.securities = [
      Security(id: "1", ticker: "MSFT", name: "Security Name", category: "bond", dateAdded: Date())
    ]
    return viewModel
  }()
  AdvisorDetailView(viewModel: viewModel)
}
