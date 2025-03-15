# AdviRoad 
Compound Advisors Dashboard ([assignment](https://github.com/MarwanT/AdviRoad/blob/main/ASSIGNMENT.md))

#### Terminlogy
- **Firm** - Company that the Advisors work for. You can assume the Company
here is Compound Planning and the Advisors are the ones that work with us.
- **Client** - Someone who receives financial guidance and advice from a financial
advisor.
- **Advisor** - A person who is employed to provide financial services or guidance
to clients
- **Holding** - The contents of an investment portfolio held by an individual or an
entity.
- **Security** - A tradable financial asset such as equities or fixed income
instruments
- **Account** - Investment accounts can hold stocks, bonds, funds and other
securities, as well as cash.
- **Custodian** - A financial institution that holds customers' securities for
safekeeping

## Project Structure

Following the terminology mentioned in the main assignement and listed above, I took the liberty to redefine the **API** structure as follows:



### API Enpoints

```JSON
// Custodian
{
    "id": "c5a06098-8736-4238-983c-2b191ff7f5de",
    "name": "Schwab"
}

// Client
{
    "id": "9c4f9877-8ea7-4744-b250-966cec798ccd",
    "firstName": "Bradley",
    "lastName": "Green",
    "dateOfBirth": "2000-03-13T20:12:18Z",
}

// Security:
{
    "id": "2e5012db-3a39-415d-93b4-8b1e3b453c6c",
    "ticker": "ICKAX",
    "name": "Delaware Ivy Crossover Credit Fund Class A",
    "category": "mutual-fund", // stock, bond...
    "dateAdded": "2001-06-07T11:12:56.205Z"
}

// Account
{
    "id": "cf2124b9-0f63-4475-9b90-59a4aa85f2b6",
    "name": "Bradley Green - 401k",
    "number": "21889645",
    "clientId": "9c4f9877-8ea7-4744-b250-966cec798ccd",
    "advisorRepId": "4",  
    "custodian": { 
        "id": "c5a06098-8736-4238-983c-2b191ff7f5de", 
        "name": "Schwab"
    },  
    "holdings": [ 
        {
            "ticker": "ICKAX",
            "units": 77,
            "unitPrice": 398.63
        }
    ]
}

// Advisor
{
    "id": "4",
    "firstName": "Randall",
    "lastName": "Le Pouce",
    "custodians": [
        { 
            "id": "c5a06098-8736-4238-983c-2b191ff7f5de",
            "name": "Schwab", 
            "repId": "1271" },
        { 
            "id": "77326e8c-08d0-4960-8271-ea430693593e",
            "name": "Fidelity", 
            "repId": "8996" 
        }
    ]
}
```

### Improvements
- Use enum for the Security categories
- Use UUID for ids as a type instead of String
- Add more tests for testing concurrencies
