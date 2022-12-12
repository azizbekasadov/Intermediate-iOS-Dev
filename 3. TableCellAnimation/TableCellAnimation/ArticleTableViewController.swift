//
//  ArticleTableViewController.swift
//  TableCellAnimation
//
//  Created by Simon Ng on 3/10/2020.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import UIKit

extension UITableViewCell {
    enum AnimationType {
        case fadeOut
        case rotation3D
        case flyin
    }
}

class ArticleTableViewController: UITableViewController {
    
    enum Section {
        case all
    }
    
    let articles = [ Article(title: "Use Background Transfer Service To Download File in Background", image: "imessage-sticker-pack"),
                     Article(title: "Face Detection in iOS Using Core Image", image: "face-detection-featured"),
                     Article(title: "Building a Speech-to-Text App Using Speech Framework in iOS", image: "speech-kit-featured"),
                     Article(title: "Building Your First Web App in Swift Using Vapor", image: "vapor-web-framework"),
                     Article(title: "Creating Gradient Colors Using CAGradientLayer", image: "cagradientlayer-demo"),
                     Article(title: "A Beginner's Guide to CALayer", image: "calayer-featured")
    ]
    
    lazy var dataSource = configureDataSource()

    private var animatedCells: [IndexPath] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateSnapshot()
        
        tableView.estimatedRowHeight = 258.0
        tableView.rowHeight = UITableView.automaticDimension
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .automatic
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureDataSource() -> UITableViewDiffableDataSource<Section, Article> {

        let cellIdentifier = "Cell"

        let dataSource = UITableViewDiffableDataSource<Section, Article>(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, article in
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ArticleTableViewCell

                cell.titleLabel.text = article.title
                cell.postImageView.image = UIImage(named: article.image)

                return cell
            }
        )

        return dataSource
    }
    
    func updateSnapshot(animatingChange: Bool = false) {

        // Create a snapshot and populate the data
        var snapshot = NSDiffableDataSourceSnapshot<Section, Article>()
        snapshot.appendSections([.all])
        snapshot.appendItems(articles, toSection: .all)

        dataSource.apply(snapshot, animatingDifferences: animatingChange)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Fade Out Animation
        animateCell(cell, forRowAt: indexPath, with: .flyin)
    }
    
    private func animateCell(_ cell: UITableViewCell, forRowAt indexPath: IndexPath,
                             with animationType: UITableViewCell.AnimationType) {
        
        if !animatedCells.contains(indexPath) {
            switch animationType {
            case .fadeOut:
                cell.alpha = 0
                
                UIView.animate(withDuration: 1) {
                    cell.alpha = 1
                }
            case .rotation3D:
                let rotationAngleInRadians = 90.0 * CGFloat(Double.pi / 180.0)
                let rotationTransform = CATransform3DMakeRotation(rotationAngleInRadians, 0, 0, 1)
                cell.layer.transform = rotationTransform
                UIView.animate(withDuration: 1.0){
                    cell.layer.transform = CATransform3DIdentity
                }
            case .flyin:
                let rotationAngleInRadians = 90.0 * CGFloat(Double.pi / 180.0)
                let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 100, 0)
                cell.layer.transform = rotationTransform
                UIView.animate(withDuration: 1.0){
                    cell.layer.transform = CATransform3DIdentity
                }
            }
            animatedCells.append(indexPath)
        }
    }
}
