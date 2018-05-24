//
//  CoinData.swift
//  Crypto Tracker
//
//  Created by William Lund on 5/20/18.
//  Copyright © 2018 Bill Lund. All rights reserved.
//

/*
 Utility classes for the application
*/

import UIKit    // Includes Foundation code
import Alamofire

/*
 
 *****
 * 2 *
 *****
 
 This creates a protocol that a class would have to obey.
 
 @objc is some indicator that this may be used by Objective C code.
 
 Stack Overflow says: "many of the frameworks are written in Objective-C,
 sometimes Objective-C features are needed to interact with certain APIs."
*/
@objc protocol CoinDataDelegate : class {
    @objc optional func newPrices()
    @objc optional func newHistory()
}

/*
 This is a "singleton", there can only be one instance of this class.
 It contains the list of coins to be included in the app. It also contains
 all of the information about the coins as an array of type Coin.
 TODO: Use getters instead of referencing code.
*/
class CoinData {
    
    // Refer to this class as CoinData.shared
    static let shared = CoinData()
    
    // All of the current price and amount held information of Coin.
    var coins = [Coin]()
    
    /*
     
    */
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
        
        Alamofire.request("https://min-api.cryptocompare.com/data/pricemulti?fsyms=\(listOfSymbols)&tsyms=USD")
            .responseJSON { (response) in
            if let json = response.result.value as? [String:Any] {
                for coin in self.coins {
                    if let coinJSON = json[coin.symbol] as?
                        [String:Double] {
                        if let price = coinJSON["USD"] {
                            coin.price = price
                        }
                    }
                }
                /*
                 Since self.delegate was assigned the object CryptoTableViewController, and it conforms to
                 the protocol CoinDataDelegate which requires the function newPrices(), you can make this call.
                */
                self.delegate?.newPrices?()
            }
        }
    }
    
    /**
     Convert a double to a string formatted as US dollars
     
     FIXME: Should this be a static?
    */
    func doubleToMoneyString( money : Double ) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .currency
        if let formattedPrice = formatter.string(from: NSNumber(floatLiteral: money)) {
            return formattedPrice
        }
        
        return "ERROR"
    } // func doubleToMoneyString
    
    
    
} // class CoinData



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
        return CoinData.shared.doubleToMoneyString(money: price)
    } // func priceAsString
    
    func getHistoricalData() {
        Alamofire.request("https://min-api.cryptocompare.com/data/histoday?fsym=\(symbol)&tsym=USD&limit=30")
            .responseJSON { (response) in
             if let json = response.result.value as? [String:Any] {
                if let pricesJSON = json["Data"] as? [[String:Double]] {
                    self.historicalData = []
                    for priceJSON in pricesJSON {
                        if let closePrice = priceJSON["close"] {
                            self.historicalData.append(closePrice)
                        }
                    }
                    CoinData.shared.delegate?.newHistory?()
                }
            }
        }
    }
    
    
    
} // class Coin




