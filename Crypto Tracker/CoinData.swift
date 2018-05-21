//
//  CoinData.swift
//  Crypto Tracker
//
//  Created by William Lund on 5/20/18.
//  Copyright © 2018 Bill Lund. All rights reserved.
//

import UIKit    // Includes Foundation code
import Alamofire

/*
 This is a "singleton", there can only be one instance of this class.
 TODO: Use getters instead of referencing code.
*/
class CoinData {
    
    // Refer to this class as CoinData.shared
    static let shared = CoinData()
    var coins = [Coin]()
    weak var delegate : CoinDataDelegate?
    
    // prevent any other code from instantiating this class
    private init() {
        let symbols = [
             "BTC"
            ,"ETH"
            ,"LTC"
            ]
        
        for symbol in symbols {
            let coin = Coin(symbol)
            coins.append(coin)
        }
    }
    
    func getPrices() {
        
        var listOfSymbols = ""
        for coin in coins {
            listOfSymbols += coin.symbol
            if coin.symbol != coins.last?.symbol {
                listOfSymbols += ","
            }
        }
        
        Alamofire.request("https://min-api.cryptocompare.com/data/pricemulti?fsyms=\(listOfSymbols)&tsyms=USD").responseJSON { (response) in
            if let json = response.result.value as? [String:Any] {
                for coin in self.coins {
                    if let coinJSON = json[coin.symbol] as?
                        [String:Double] {
                        if let price = coinJSON["USD"] {
                            coin.price = price
                        }
                    }
                }
                self.delegate?.newPrices?()
            }
        }
    }
} // class CoinData

@objc protocol CoinDataDelegate : class {
    @objc optional func newPrices()
}

class Coin {
    
    var symbol : String = ""
    var image : UIImage = UIImage()
    var price : Double = 0.0
    var amount : Double = 0.0
    var historicalData : [Double] = [Double]()
    
    init( _ symbol : String ) {
        self.symbol = symbol
        if let image = UIImage(named: symbol) {
            self.image = image
        }
    }
    
    func priceAsString() -> String {
        if price == 0.0 {
            return "Loading..."
        }
        
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .currency
        if let formattedPrice = formatter.string(from: NSNumber(floatLiteral: price)) {
            return formattedPrice
        }
        
        return "ERROR"
    }
} // class Coin




