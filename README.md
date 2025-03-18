# AdviRoad 
Compound Advisors Dashboard ([assignment](https://github.com/MarwanT/AdviRoad/blob/main/Documentation/ASSIGNMENT.md))

I chose the name of the application by combining the words *Advisor* and *Dashboard*. 
This resulted in the appearance of another meaningful word *Road* which is alligned with any firm's objective, which is to follow the road to success.

## Screenshots
![Home View](https://github.com/MarwanT/AdviRoad/blob/main/Documentation/all-advisors_search-Ja_search-taylo.jpeg)
![Detail Views](https://github.com/MarwanT/AdviRoad/blob/main/Documentation/advisor-sarah-taylor_account-holdings_account-details.jpeg)


## Running the project

Follow these steps to run the project. 

1. Clone the repository
2. Open the .xcodeproj file @ *AdviRoad/AdviRoad/AdviRoad.hcodeproj*
3. Select a device to run the project
4. Run the project

## Features

### The visible part
- Advisors List
    - List all the firm's advisors
    - Advisors can be filtered based on their name, clients, holdings, securities and other related fields
    - The advisor list can be sorted <ins>ascending</ins> or <ins>descending</ins> based on these 4 criterias: 
        - Name
        - Assets total
        - number of clients
        - number of accounts
- Advisor Details View
    - An overview section
    - His managed accounts
    - The custodians he has a representation in
    - The securities related to the holdings included in the accounts managed by this advisor
- Account Details View, which lists all the holdings an account contains
- iPad Ready - With a few tweeks and improvement the application can run on iPad and make use of the split view

### The invisible part
- All the data is fetched from the api call and persisted locally
- In case the API call fails persisted data is displayed


## Project Structure

### Layers
- <ins>**API**</ins> | Responsible of fetching the data from the api or return mock data if specified
- <ins>**Persistence**</ins> | A Core Data implementation responsible of persisting and fetching the data 
- <ins>**Repository**</ins> | Responsible of bringing the required data, it handles the data source (API || Persistence)
- <ins>**View Models**</ins> | Provide the backbone of the main views. Communicate with the repository to load the data
- <ins>**Views**</ins> | Display data provided by the view model
- <ins>**Tests**</ins> | Used for bulletproofing the code from bugs and weird behaviors. It would be a required step for CI/CD later on.

### API Design

I changed the api design based on the terminology and business concepts you explained in the assignement. As well as the reasearch I made to understand further the connection between holdings, securities and how such an echosystem ususally works.

The application data is provided by two main endpoints:
- dashboard
- advisor/id

#### dashboard
```JSON

/**
The dashboard, as a concept can/should display an overview of things.
For this reason the response was designed to tailor this ability.
The application requirements can grow, then we would add other sections to it.
Currently the advisors array is what is needed.
*/

{
  "advisors": [
    {
      "id": "550e8400-e29b-41d4-a716-446655440001",
      "firstName": "Randall",
      "lastName": "Le Pouce",
      "totalAssets": 1234567.89,
      "totalClients": 12,
      "totalAccounts": 15,
      "custodians": [
        {
          "id": "c5a06098-8736-4238-983c-2b191ff7f5de",
          "name": "Schwab",
          "repId": "1001"
        },
        {
          "id": "77326e8c-08d0-4960-8271-ea430693593e",
          "name": "Fidelity",
          "repId": "8989"
        }
      ]
    }
  ]
}
```

#### advisor/id
```JSON

/**
All the details related to the advisor are provided in this enpoint.
In order not to have redundant information the securities related to the 
holdings are returned separatly.
*/

{
  "advisor": {
    "id": "550e8400-e29b-41d4-a716-446655440007",
    "firstName": "Sarah",
    "lastName": "Taylor",
    "totalAssets": 167872.51,
    "totalClients": 7,
    "totalAccounts": 9,
    "custodians": [
      {
        "id": "c5a06098-8736-4238-983c-2b191ff7f5de",
        "name": "Schwab",
        "repId": "1005"
      },
      {
        "id": "77326e8c-08d0-4960-8271-ea430693593e",
        "name": "Fidelity",
        "repId": "8993"
      }
    ],
    "accounts": [
      {
        "id": "91402ebc-2f42-4c79-9dcd-1f2de667258a",
        "name": "Michael Carter - Traditional IRA",
        "number": "98745261",
        "clientId": "e1d3c287-20f2-476c-a31f-88d2c2c1c918",
        "advisorId": "550e8400-e29b-41d4-a716-446655440007",
        "custodianId": "77326e8c-08d0-4960-8271-ea430693593e",
        "holdings": [
          {
            "id": "d4e5f6a7-b8c9-4d5e-9f0a-1b2c3d4e5f6a",
            "ticker": "SPY",
            "units": 25,
            "unitPrice": 435.50
          },
          {
            "id": "e5f6a7b8-c9d0-4e5f-9a0b-1c2d3e4f5a6b",
            "ticker": "ICKAX",
            "units": 40,
            "unitPrice": 500.00
          }
        ]
      },
    ]
  },
  "securities": [
    {
      "id": "2e5012db-3a39-415d-93b4-8b1e3b453c6c",
      "ticker": "ICKAX",
      "name": "Delaware Ivy Crossover Credit Fund Class A",
      "category": "mutual-fund",
      "dateAdded": "2001-06-07T11:12:56.205Z"
    },
    {
      "id": "c3e4f5d6-91b2-4a9d-a27e-7c8d42f6c3b9",
      "ticker": "SPY",
      "name": "SPDR S&P 500 ETF Trust",
      "category": "mutual-fund",
      "dateAdded": "1993-01-22T11:12:56.205Z"
    }
  ]
}
```

### Improvements
- <ins>**Tests** |</ins> The api and persistence layer have a substancial amount of tests to cover their functioning well. However when I reached the development of the views, in order not to take longer in the assignement, and because I believe from the tests that are already there, I showcased my way of work.   
However given more time and in case this is a real application developed for release, more tests would be added for the view models, concurrency tests and UI tests for the views.
- <ins>**Security Categories** |</ins> Use predefined enums instead of strings
- <ins>**IDs** |</ins> Use the _UUID_ type for Ids instead of _String_
- <ins>**SwiftUI** |</ins> As SwiftUI is relatively a new technlogy I am currently learning and developing my skills in, I would take my time readjusting and experimenting optimising better the views segragation, reusability and loading the data
- <ins>**Pagination** |</ins> Consider paginating the APIs

## Next Step

This sample project can be used as a base for releasing a fully fledged production ready application.
However before going live I would consider the following:
- <ins>**Design & Theme** |</ins> The application currently is not designed. It needs to be reviewed and designed properly, and hence adding a theme layer that would easily allow us to adjust and switch design components moving forward
- <ins>**API Stablility** |</ins> The api needs to be stabilized and reviewed with the backend engineer
- <ins>**Tests** |</ins> Have more tests to cover existing code
- <ins>**Localization** |</ins> All the strings in the application need to be localized
