//
//  CryptoTableViewController.swift
//  Crypto Tracker
//
//  Created by William Lund on 5/20/18.
//  Copyright © 2018 Bill Lund. All rights reserved.
//

import UIKit
import LocalAuthentication      // Authentication library

private let HEADER_HEIGHT : CGFloat = 100.0
private let NET_WORTH_HEIGHT : CGFloat = 45.0

/*
 CoinDataDelegate is a protocol defined in CoinData.swift that requires the func newPrices.
 
 It appears to me that the term "delegate" is not a formal part of the language but a concept that
 some of the functions of a class will be carried out by another class. Here newPrices() is required
 by the protocol to trigger a new display of the view.
*/
class CryptoTableViewController: UITableViewController, CoinDataDelegate {
    
    var amountLabel = UILabel()
    
    override func viewWillAppear(_ animated: Bool) {
        // CoinData.shared.delegate is of type CoinDataDelegate. Since this class implements that protocol
        // we can assign this class to the property CoinData.shared.delegate.
        CoinData.shared.delegate = self
        tableView.reloadData()
        displayNetWorth()
    } // func viewWillAppear
    
    func updateSecureButton () {
        if UserDefaults.standard.bool(forKey: Constants.UserDefaultsConstants.AUTH) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Unsecure App", style: .plain, target: self,
                                                                action: #selector(secureTapped))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Secure App", style: .plain, target: self,
                                                                action: #selector(secureTapped))
        }
    } // func updateSecureButton
    
    @objc func secureTapped() {
        if UserDefaults.standard.bool(forKey: Constants.UserDefaultsConstants.AUTH) {
            UserDefaults.standard.set(false, forKey: Constants.UserDefaultsConstants.AUTH)
        } else {
            UserDefaults.standard.set(true, forKey: Constants.UserDefaultsConstants.AUTH)
        }
        updateSecureButton()
    } // func secureTapped
    
    /*
     Once the view has loaded into memory (but not displayed?) this func is called.
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CoinData.shared.getPrices()
        if LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            updateSecureButton()
        }
    } // func viewDidLoad
    
    /*
     Required by the protocol CoinDataDelegate
    */
    
    func newPrices() {
        displayNetWorth()
        tableView.reloadData()
    } // func newPrices
    
    func createHeaderView() -> UIView {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: HEADER_HEIGHT))
        headerView.backgroundColor = UIColor.white
        let netWorthLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: NET_WORTH_HEIGHT))
        netWorthLabel.text = "My Crypto Net Worth"
        netWorthLabel.textAlignment = .center
        headerView.addSubview(netWorthLabel)
        
        amountLabel.frame = CGRect(x: 0, y: NET_WORTH_HEIGHT, width: view.frame.size.width,
                                   height: HEADER_HEIGHT - NET_WORTH_HEIGHT)
        amountLabel.textAlignment = .center
        amountLabel.font = UIFont.boldSystemFont(ofSize: 60.0)
        headerView.addSubview(amountLabel)
        
        displayNetWorth()
        
        return headerView
    } // func createHeaderView
    
    func displayNetWorth() {
        amountLabel.text = CoinData.shared.netWorthAsString()
    } // func displayNetWorth
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return HEADER_HEIGHT
    } // func tableView(_ tableView: UITableView, heightForHeaderInSection section
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return createHeaderView()
    } // func tableView(_ tableView: UITableView, viewForHeaderInSection section
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return CoinData.shared.coins.count
    } // func tableView(_ tableView: UITableView, numberOfRowsInSection

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Since we don't have a large number of cells, we won't "reuse" cells. Just create a new cell
        let cell = UITableViewCell()
        
        // Get the coin and the symbol.
        let coin = CoinData.shared.coins[indexPath.row]
        
        if coin.amount != 0.0 {
            cell.textLabel?.text = "\(coin.symbol) - \(coin.priceAsString()) - \(coin.amount)"
            cell.imageView?.image = coin.image
        } else {
            cell.textLabel?.text = "\(coin.symbol) - \(coin.priceAsString())"
            cell.imageView?.image = coin.image
        }
        return cell
    } // func tableView(_ tableView: UITableView, cellForRowAt indexPath
    
    /*
     Code to transfer to the CoinViewController which displays history.
     If we had been using Storyboard we would have had to prepare for segue and perform seque.
    */
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coinVC = CoinViewController()
        coinVC.coin = CoinData.shared.coins[indexPath.row]
        navigationController?.pushViewController(coinVC, animated: true)
    } // func tableView(_ tableView: UITableView, didSelectRowAt indexPath
    
} //class CryptoTableViewController
