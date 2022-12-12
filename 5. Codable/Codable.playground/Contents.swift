import Foundation

var json = """
{

"name": "John Davis",
"country": "Peru",
"use": "to buy a new collection of clothes to stock her shop before the holidays.",
"amount": 150

}
"""

struct Loan: Hashable, Codable {
    var name: String
    var country: String
    var use: String
    var amount: Int
    
    enum CodingKeys: String, CodingKey {
        case name
        case country = "location"
        case use
        case amount = "loan_amount"
    }
    
    enum LocationKeys: String, CodingKey {
        case country
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try values.decode(String.self, forKey: .name)
        
        let location = try values.nestedContainer(keyedBy: LocationKeys.self, forKey: .country)
        self.country = try location.decode(String.self, forKey: .country)
        
        self.use = try values.decode(String.self, forKey: .use)
        self.amount = try values.decode(Int.self, forKey: .amount)
    }
}

// MARK: Custom Coding Keys
json = """
{

"name": "John Davis",
"country": "Peru",
"use": "to buy a new collection of clothes to stock her shop before the holidays.",
"loan_amount": 150

}
"""

// MARK: Working with Nested Objects
json = """
{

"name": "John Davis",
"location": {
"country": "Peru",
},
"use": "to buy a new collection of clothes to stock her shop before the holidays.",
"loan_amount": 150

}
"""

// MARK: Working with Arrays of Objects
json = """
[{
"name": "John Davis",
"location": {
"country": "Paraguay",
},
"use": "to buy a new collection of clothes to stock her shop before the holidays.",
"loan_amount": 150
},
{
"name": "Las Margaritas Group",
"location": {
"country": "Colombia",
},
"use": "to purchase coal in large quantities for resale.",
"loan_amount": 200
}]

"""

let decoder = JSONDecoder()

//if let jsonData = json.data(using: .utf8) {
//    do {
//        let loan = try decoder.decode(Loan.self, from: jsonData)
//        print(loan)
//    } catch let error {
//        print(error.localizedDescription)
//    }
//}

if let jsonData = json.data(using: .utf8) {
    do {
        let loans = try decoder.decode([Loan].self, from: jsonData)
        print(loans)
    } catch {
        print(error.localizedDescription)
    }
}

// MARK: Pagination
let json1 = """
{
"paging": {
"page": 1,
"total": 6083,
"page_size": 20,
"pages": 305
},
"loans":
[{
"name": "John Davis",
"location": {
"country": "Paraguay",
},
"use": "to buy a new collection of clothes to stock her shop before the holidays.",
"loan_amount": 150
},
{
"name": "Las Margaritas Group",
"location": {
"country": "Colombia",
},
use": "to purchase coal in large quantities for resale.",
"loan_amount": 200
}]
}
"""

struct LoanDataStore: Codable {
    var loans: [Loan]
}

if let jsonData = json1.data(using: .utf8) {
    do {
        let loanDataStore = try decoder.decode(LoanDataStore.self, from: jsonData)
        print(loanDataStore)
    } catch {
        print(error.localizedDescription)
    }
}
