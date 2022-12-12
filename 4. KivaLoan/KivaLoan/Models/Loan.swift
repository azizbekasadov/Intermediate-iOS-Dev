//
//  Loan.swift
//  KivaLoan
//
//  Created by Azizbek Asadov on 11/12/22.
//  Copyright © 2022 AppCoda. All rights reserved.
//

struct Loan: Hashable, Codable {
    var name: String = ""
    var country: String = ""
    var use: String = ""
    var amount: Int = 0
    
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

