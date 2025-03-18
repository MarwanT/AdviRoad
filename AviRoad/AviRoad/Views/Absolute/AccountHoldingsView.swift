//
//  AccountHoldingsView.swift
//  AviRoad
//
//  Created by Marwan Tutunji on 18/03/2025.
//

import SwiftUI

struct AccountHoldingsView: View {
  @State var account: Account
  
  var body: some View {
    List {
      Section(header: Text("Account Details")) {
        Text("Name: \(account.name)")
        Text("Number: \(account.number)")
      }
      
      if !account.holdings.isEmpty {
        Section(header: Text("Holdings")) {
          ForEach(account.holdings) { holding in
            VStack(alignment: .leading) {
              Text("Ticker: \(holding.ticker)")
              Text("Units: \(holding.units)")
              Text("Unit Price: \(holding.unitPrice, specifier: "%.2f")")
            }
            .padding(.vertical, 5)
          }
        }
      } else {
        Text("No holdings available.")
          .foregroundColor(.gray)
          .italic()
      }
    }
    .navigationTitle("Account Holdings")
    .listStyle(InsetGroupedListStyle())
  }
}


#Preview {
  let account: Account = Account(
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
  AccountHoldingsView(account: account)
}
