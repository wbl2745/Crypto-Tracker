//
//  CoinViewController.swift
//  Crypto Tracker
//
//  Created by William Lund on 5/22/18.
//  Copyright © 2018 Bill Lund. All rights reserved.
//

import UIKit
import SwiftChart

private let chartHeight : CGFloat = 300.0

class CoinViewController : UIViewController, CoinDataDelegate {
    
    var chart : Chart = Chart()
    var coin : Coin?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        CoinData.shared.delegate = self
        
        // The next line moves the graph down so that it isn't overlapped by the navigation
        // This looks like a kluge
        // FIXME: This needs to be done the "right" way. See documentation.
        edgesForExtendedLayout = []
        view.backgroundColor = UIColor.white
        
        // Set up the chart with data
        chart.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: chartHeight )
        chart.yLabelsFormatter = {
            CoinData.shared.doubleToMoneyString(money: $1)
        }
        
        /*
         Something about the Chart() class takes the labels and sorts them smallest to largest.
         We want to sort largest to smallest. The xLabelsFormatter takes the value from the array
         subtracts it from 30, rounds it to the nearest int, converts to an Int, converts to a
         String and appends a "d".
        */
        chart.xLabels = [30,25,20,15,10,5,0]
        chart.xLabelsFormatter = {
            String(Int(round(30 - $1))) + "d"
        }
        // make the chart visible
        view.addSubview(chart)
        
        coin?.getHistoricalData()
        
    } // func viewDidLoad
    
    func newHistory() {
        if let coin = coin {
            let series = ChartSeries(coin.historicalData)
            series.area = true
            chart.add(series)
        }
    }
    
    
    
    
    
    
    

} // class CoinViewController
