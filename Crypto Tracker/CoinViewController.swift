//
//  CoinViewController.swift
//  Crypto Tracker
//
//  Created by William Lund on 5/22/18.
//  Copyright © 2018 Bill Lund. All rights reserved.
//

import UIKit            // Framework for iOS and tvOS
import SwiftChart       // Framework for the SwiftChart CocoaPod

// MARK: - Constants

// TODO: Should these constants be here or in Constants.swift?

private let CHART_HEIGHT : CGFloat = 300.0
private let IMAGE_SIZE : CGFloat = 100.0
private let PRICE_LABEL_HEIGHT : CGFloat = 25.0

// MARK: - Code

/*
 Since we're not using storyboards, this class will define and instantiate all of the windows and labels
 on the window showing a coin and its history.
 UIViewController: The parent class for view controller.
 CoinDataDelegate: The protocol that requires newHistory() and newPrices()
 
 Since there's no init for this class, it is instantiated by its parent, UIViewController.
 */
class CoinViewController : UIViewController, CoinDataDelegate {
    
    var chart : Chart = Chart()
    
    // Value of coin is assigned after CoinViewController is instantiated elsewhere. Since it is assigned
    // elsewhere, it is optional since you don't know it actually happened.
    // FIXME: Assign value of coin in an initializer. (Tricky)
    
    var coin : Coin?
    var priceLabel : UILabel = UILabel()
    var youOwnLabel : UILabel = UILabel()
    var worthLabel : UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // The parent instantiated the class CoinViewController and this method is called
        // once the view has loaded into memory. (I don't think it is visible yet.)
        // That means that there is a "self" to be given back to CoinData and used there.
        CoinData.shared.delegate = self
        
        // The next line moves the graph down so that it isn't overlapped by the navigation
        // This looks like a kluge
        // FIXME: This needs to be done the "right" way. See documentation.
        edgesForExtendedLayout = []
        // If no color is assigned the background is transparent.
        // "view" comes from UIViewController.
        view.backgroundColor = UIColor.white
        
        // Set up the chart with data
        chart.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: CHART_HEIGHT )
        chart.yLabelsFormatter = {
            CoinData.shared.doubleToMoneyString(money: $1)
        }
        
        /*
         Something about the Chart() class takes the labels and sorts them smallest to largest.
         We want to sort largest to smallest. The xLabelsFormatter takes the value from the array ($1)
         subtracts it from 30, rounds it to the nearest int, converts to an Int, converts to a
         String and appends a "d".
        */
        chart.xLabels = [30,25,20,15,10,5,0]
        chart.xLabelsFormatter = { String(Int(round(30 - $1))) + "d" }
        
        // make the chart visible
        view.addSubview(chart)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self,
                                                            action: #selector(editTapped))
        
        if let coin = coin {
            title = coin.symbol
            
            let imageView = UIImageView(frame: CGRect(x: (view.frame.size.width - IMAGE_SIZE) / 2,
                                                      y: CHART_HEIGHT , width: IMAGE_SIZE, height: IMAGE_SIZE))
            imageView.image = coin.image
            view.addSubview(imageView)
            
            priceLabel.frame = CGRect(x: 0.0, y: CHART_HEIGHT + IMAGE_SIZE, width: view.frame.size.width, height: PRICE_LABEL_HEIGHT)
            priceLabel.textAlignment = .center
            view.addSubview(priceLabel)
            
            youOwnLabel.frame = CGRect(x: 0.0, y: CHART_HEIGHT + IMAGE_SIZE + ( PRICE_LABEL_HEIGHT * 2) ,
                                       width: view.frame.size.width, height: PRICE_LABEL_HEIGHT )
            youOwnLabel.textAlignment = .center
            youOwnLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
            view.addSubview(youOwnLabel)
            
            worthLabel.frame = CGRect(x: 0.0, y: CHART_HEIGHT + IMAGE_SIZE + ( PRICE_LABEL_HEIGHT * 3)  ,
                                       width: view.frame.size.width, height: PRICE_LABEL_HEIGHT )
            worthLabel.textAlignment = .center
            worthLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
            view.addSubview(worthLabel)
            
            coin.getHistoricalData()
            newPrices()
        }
        
    } // func viewDidLoad
    
    /*
     This is essentally an alert to get how much of a coin is owned.
    */
    @objc func editTapped() {
        if let coin = coin {
            let alert = UIAlertController(title: "How much \(coin.symbol) do you own?",
                message: nil, preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.placeholder = "0.0"
                textField.keyboardType = .decimalPad
                if self.coin?.amount != 0.0 {
                    textField.text = String( coin.amount)
                }
            }
            
            alert.addAction(UIAlertAction(title: "OK?", style: .default, handler: { (action) in
                if let text = alert.textFields?[0].text {
                    if let amount = Double(text) {
                        self.coin?.amount = amount
                        self.newPrices()
                    }
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
    } // func editTapped
    
    func newHistory() {
        if let coin = coin {
            let series = ChartSeries(coin.historicalData)
            series.area = true
            chart.add(series)
        }
    } // func newHistory
    
    func newPrices() {
        if let coin = coin {
            priceLabel.text = coin.priceAsString()
            worthLabel.text = coin.amountAsString()
            youOwnLabel.text = "You own: \(coin.amount) \(coin.symbol)"
        }
    } // func newPrices
    
} // class CoinViewController
