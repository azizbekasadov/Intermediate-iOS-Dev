//
//  KivaLoanTableViewController.swift
//  KivaLoan
//
//  Created by Simon Ng on 4/10/2016.
//  Updated by Simon Ng on 6/12/2017.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

protocol KivaLoadTaskProtocol {
    typealias LoanCompletion = ((_ data: [Loan], _ error: Error?) -> Void)
    func getLatestLoans(completion: LoanCompletion?)
}

struct KivaLoanTask: KivaLoadTaskProtocol {
    private let kivaLoanURL = "https://api.kivaws.org/v1/loans/newest.json"
    
    func getLatestLoans(completion: LoanCompletion?) {
        guard let loanUrl = URL(string: kivaLoanURL) else {
            return
        }
        
        let request = URLRequest(url: loanUrl)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            
            if let error = error {
                completion?([], error)
                return
            }
            
            // Parse JSON data
            if let data = data {
                let loans = parseJsonData(data: data)
                completion?(loans, nil)
            }
        })
        
        task.resume()
    }
    
    private func parseJsonData(data: Data) -> [Loan] {
        var loans = [Loan]()
        
        do {
//            let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
            
            // Parse JSON data
//            let jsonLoans = jsonResult?["loans"] as! [AnyObject]
//            for jsonLoan in jsonLoans {
//                var loan = Loan()
//                loan.name = jsonLoan["name"] as! String
//                loan.amount = jsonLoan["loan_amount"] as! Int
//                loan.use = jsonLoan["use"] as! String
//                let location = jsonLoan["location"] as! [String:AnyObject]
//                loan.country = location["country"] as! String
//                loans.append(loan)
//            }
            let decoder = JSONDecoder()
            
            let loanDataStore = try decoder.decode(LoanDataStore.self, from: data)
            loans = loanDataStore.loans
            
        } catch {
            print(error)
        }
        
        return loans
    }
}

class KivaLoanTableViewController: UITableViewController {
    enum Section {
        case all
    }
    
    private var loans = [Loan]()
    
    private var task: KivaLoadTaskProtocol = KivaLoanTask()
    
    private var dataSource: UITableViewDiffableDataSource<Section, Loan>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 92.0
        tableView.rowHeight = UITableView.automaticDimension
        
        self.dataSource = configureDataSource()
        tableView.dataSource = self.dataSource
        
        getLatestLoans()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func getLatestLoans() {
        task.getLatestLoans { [weak self] data, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if !data.isEmpty {
                guard let self = self else { return }
                
                self.loans = data
//                OperationQueue.main.addOperation({
//                    self.updateSnapshot(animatingChange: true)
//                })
                
                DispatchQueue.main.async {
                    self.updateSnapshot(animatingChange: true)
                }
            }
        }
    }
    
    func configureDataSource() -> UITableViewDiffableDataSource<Section, Loan> {
        
        let cellIdentifier = "Cell"
        
        let dataSource = UITableViewDiffableDataSource<Section, Loan>(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, loan in
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! KivaLoanTableViewCell
                cell.nameLabel.text = loan.name
                cell.countryLabel.text = loan.country
                cell.useLabel.text = loan.use
                cell.amountLabel.text = "$\(loan.amount)"
                
                return cell
            }
        )
        
        return dataSource
    }
    
    private func updateSnapshot(animatingChange: Bool = false) {
        // Create a snapshot and populate the data
        var snapshot = NSDiffableDataSourceSnapshot<Section, Loan>()
        snapshot.appendSections([.all])
        snapshot.appendItems(loans, toSection: .all)
        dataSource.apply(snapshot, animatingDifferences: animatingChange)
    }
    
}
