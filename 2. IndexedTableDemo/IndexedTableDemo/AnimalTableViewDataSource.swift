//
//  AnimalTableViewDataSource.swift
//  IndexedTableDemo
//
//  Created by Azizbek Asadov on 10/12/22.
//

import UIKit

final class AnimalTableViewDataSource: UITableViewDiffableDataSource<String, String> {
    override func tableView(_ tableView: UITableView,
                            titleForHeaderInSection section: Int) -> String? {
        return self.snapshot().sectionIdentifiers[section]
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    }
    
    override func tableView(_ tableView: UITableView,
                            sectionForSectionIndexTitle title: String,
                            at index: Int) -> Int {
        guard let index = self.snapshot().sectionIdentifiers.firstIndex(of: title) else {
            return -1
        }
        return index
    }
}
