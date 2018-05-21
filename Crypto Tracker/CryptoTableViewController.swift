//
//  CryptoTableViewController.swift
//  Crypto Tracker
//
//  Created by William Lund on 5/20/18.
//  Copyright © 2018 Bill Lund. All rights reserved.
//

import UIKit

class CryptoTableViewController: UITableViewController, CoinDataDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        CoinData.shared.delegate = self
        CoinData.shared.getPrices()
    }

    func newPrices() {
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return CoinData.shared.coins.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Since we don't have a large number of cells, we won't "reuse" cells. Just create a new cell
        let cell = UITableViewCell()
        
        // Get the coin and the symbol.
        let coin = CoinData.shared.coins[indexPath.row]
        cell.textLabel?.text = "\(coin.symbol) - \(coin.priceAsString())"
        cell.imageView?.image = coin.image

        return cell
    } // tableView()
    
} //class CryptoTableViewController
