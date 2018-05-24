//
//  CryptoTableViewController.swift
//  Crypto Tracker
//
//  Created by William Lund on 5/20/18.
//  Copyright © 2018 Bill Lund. All rights reserved.
//

import UIKit
/*
 CoinDataDelegate is a protocol defined in CoinData.swift that requires the func newPrices.
 
 It appears to me that the term "delegate" is not a formal part of the language but a concept that
 some of the functions of a class will be carried out by another class. Here newPrices() is required
 by the protocol to trigger a new display of the view.
*/
class CryptoTableViewController: UITableViewController, CoinDataDelegate {

    /*
     Once the view has loaded into memory (but not displayed?) this func is called.
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // CoinData.shared.delegate is of type CoinDataDelegate. Since this class implements that protocol
        // we can assign this class to the property CoinData.shared.delegate.
        CoinData.shared.delegate = self
        CoinData.shared.getPrices()
    }

    /*
     Required by the protocol CoinDataDelegate
    */
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
    
    /*
     Code to transfer to the CoinViewController which displays history.
     If we had been using Storyboard we would have had to prepare for segue and perform seque.
    */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coinVC = CoinViewController()
        coinVC.coin = CoinData.shared.coins[indexPath.row]
        navigationController?.pushViewController(coinVC, animated: true)
        
    }
    
    
    
    
    
    
    
} //class CryptoTableViewController
