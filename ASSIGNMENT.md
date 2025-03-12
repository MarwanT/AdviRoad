# Advisor Dashboard - Take Home Assignment (iOS)

## Introduction
Hello! We’re glad you’re interested in joining the team at Compound! In this step of
the interview process you will be completing a take home assessment that will be
the basis for future technical interviews. Please use this exercise to demonstrate
your talent, creativity, and problem solving ability. This exercise is inspired by
problems we encounter daily and we hope that it is a enjoyable challenge to solve.

There is no time limit for the exercise, but we expect that you should be able to
complete it within a few hours. Make sure to both showcase your abilities and
capture the additional steps you would take to make the code production ready.

We ask that you do not share your solution publicly. Please create a private
repository and add the compound-interview-bot as a collaborator of the project
when it is complete and ready to be reviewed.

## What do I need to submit?
- Please build an iOS application using Swift as described in the next section.
- We must be able to run your app and see a response containing answers to
the questions below. Provide any documentation necessary to accomplish this
as part of the repository you submit.
- You can assume reviewer has knowledge of how to run an iOS application
before when developing your documentation, but please provide any
additional instructions or commands that may be needed to start it.

### Business background
Compound’s business runs on tools to enable financial advisors provide a magical
experience for their clients. Financial advisors can be part of an organizational
group which we refer to as a firm. In this scenario you will be aggregating client
account information for the advisory firm. This will provide insights into the
underlying account investments for the advisor and the firm.

#### Terminology
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

### What are you building?
You are working to build features that power a Firm’s Advisor Dashboard. The
advisor dashboard will help us gain valuable insights across our advisors.
- Create components for the Firm-Advisor Dashboard.
    - Design and implement a table view to see information about the advisors.
The view should:
        - Show us the advisors and a summary of the assets that they are
managing.
        - Provide the ability to drill in and see information about the individual
accounts that they are managing
        - See the holdings that are in the account.
        - Consider the example data below.
    - Add 1 sort or filter feature.
        - You can add the sort/filter wherever makes sense to you based on the
implementation from the first part.
        - One possible example could be sort the advisors by name or total
assets that they are managing.
- API Design
    - You may use the provided JSON files as mock responses from a server

#### Example Data:
This data does not need to be used as is. This is the core shape of the data, but
you may change it, normalize it, or transform it as you build out the API layer
accordingly.

```JSON
// Advisor:
{
    "id": "4",
    "name": "Randall",
    "custodians": [
        { 
            "name": "Schwab", 
            "repId": "1271" },
        { 
            "name": "Fidelity", 
            "repId": "8996" 
        }
    ]
}

// Account:
{
    "name": "Bradley Green - 401k",
    "number": "21889645",
    "repId": "9883",
    "holdings": [
        { 
            "ticker": "HEMCX", 
            "units": 77, 
            "unitPrice": 398.63 
        }
    ],
    "custodian": "Schwab"
}

// Security:
{
    "id": "2e5012db-3a39-415d-93b4-8b1e3b453c6c",
    "ticker": "ICKAX",
    "name": "Delaware Ivy Crossover Credit Fund Class A",
    "dateAdded": "2001-06-07T11:12:56.205Z"
}
```

### Expectations of the Exercise:
- Requirements:
    - Provide instructions for running the app
    - Add Documentation for:
        - Any assumptions you make.
        - Document any todos, optimizations, or next steps you would take in
order to get this feature ready to launch.
    - Try to put your best foot forward with the submission. Include polish in
your submission that’s comparable to what you would put into code
review.
- Submit your solution!
    - Invite the [compound-interview-bot](https://github.com/compound-interview-bot) as a collaborator.

## FAQ:

##### Private repository submission details.
- Make sure your Github repository is private.
- Add compound-interview-bot as a collaborator when your project is complete
and ready to be reviewed
    - Here’s a [link](https://github.com/compound-interview-bot) to the account
    - You can search how to add Github collaborators, but here’s a [link](https://docs.github.com/en/account-and-profile/setting-up-and-managing-your-personal-account-on-github/managing-access-to-your-personal-repositories/inviting-collaborators-to-a-personal-repository) if helpful

##### How will this exercise be evaluated?
An engineer will review the code you submit. At a minimum they must be able to
run the app and see the expected results.  
You should provide any necessary documentation within the repository. While
your solution does not need to be fully production ready, you are being evaluated
so put your best foot forward.

##### I have questions about the problem statement
For any requirements not specified via an example, use your best judgment to
determine the expected result. Document any assumptions you make.

##### How long do I have to complete the exercise?
There is no time limit for the exercise. Out of respect for your time, we designed
this exercise with the intent that it should take a few hours. But, please take as
much time as you need to complete the work.