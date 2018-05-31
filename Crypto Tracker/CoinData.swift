//
//  CoinData.swift
//  Crypto Tracker
//
//  Created by William Lund on 5/20/18.
//  Copyright © 2018 Bill Lund. All rights reserved.
//

import UIKit        // Includes Foundation code
import Alamofire    // HTTP access to network resources

// MARK: - Constants

// TODO: Should these constants be here or in the Constants file?

private let SYMBOLS = [     // Cryptocurrency symbols to be used in code
     "BTC"
    ,"BCH"
    ,"ETH"
    ,"LTC"
]

private let CURRENCY : String = "USD"   // The currency to show values in
                                        // Defined in Alamofire
private let LOCALE_IDENTIFIER : String = "en_US"
                                        // Identifier of the country for formatting numbers

// MARK: - Code

/*
 
 *****
 * 1 *
 *****
 
 This creates a protocol that a class would have to obey.
 
 @objc is an indicator that this may be used by Objective C code.
 Stack Overflow says: "many of the frameworks are written in Objective-C,
 sometimes Objective-C features are needed to interact with certain APIs."
*/

@objc protocol CoinDataDelegate : class {
    @objc optional func newPrices()
    @objc optional func newHistory()
} // protocol CoinDataDelegate

/*
 This is a "singleton", there can only be one instance of this class.
 It contains the list of coins to be included in the app. It also contains
 all of the information about the coins as an array of type Coin.
*/

class CoinData {
    
    // Since init() is private, this is the only code that can instantiate this class.
    // As the constant "shared" is static, it can be accessed without instantiating
    // the class, to instantiate the class.
    // Refer to this class as CoinData.shared
    static let shared = CoinData()
    
    // All of the current price and amount held information of Coin.
    var coins = [Coin]()
    
    // "weak" means that it won't be instantiated until used.
    // This becomes the delegate of CoinViewController in CoinViewController.viewDidLoad()
    // CoinData can call methods in CoinViewController.
    weak var delegate : CoinDataDelegate?
    
    // Since init() is private, no other code can instantiate this class.
    // This is what makes it a singleton.
    private init() {
        for symbol in SYMBOLS {
            let coin = Coin(symbol)
            coins.append(coin)
        }
    } // init
    
    /*
     Sum up the worth of all the coins and return the value as a String.
     */
    func netWorthAsString() -> String {
        var netWorth = 0.0
        for coin in coins {
            netWorth += coin.amount * coin.price
        }
        return doubleToMoneyString(money: netWorth)
    } // func netWorthAsString
    
    func getPrices() {
        var listOfSymbols = ""
        for coin in coins {
            listOfSymbols += coin.symbol
            // put commas between symbols
            if coin.symbol != coins.last?.symbol {
                listOfSymbols += ","
            }
        }
        
        // URL request as documented at Alamofire
        Alamofire.request("https://min-api.cryptocompare.com/data/pricemulti?fsyms=\(listOfSymbols)&tsyms=\(CURRENCY)")
            .responseJSON { (response) in
            if let json = response.result.value as? [String:Any] {
                for coin in self.coins {
                    if let coinJSON = json[coin.symbol] as?
                        [String:Double] {
                        if let price = coinJSON[CURRENCY] {
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
    } // func getPrices
    
    /*
     Convert a double to a string formatted as US dollars
    */
    // FIXME: Should this be a static?
    func doubleToMoneyString( money : Double ) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: LOCALE_IDENTIFIER)
        formatter.numberStyle = .currency
        if let formattedPrice = formatter.string(from: NSNumber(floatLiteral: money)) {
            return formattedPrice
        }
        return "ERROR"
    } // func doubleToMoneyString
    
} // class CoinData

/*
 Class to hold information about a single coin type
 */
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
    } // init
    
    /*
     Return the stored price as a string. If it is 0.0, assume it is loading
    */
    // FIXME: We shouldn't assume that 0.0 means loading. Track when a symbol is loaded and until then show "Loading"
    func priceAsString() -> String {
        if price == 0.0 {
            return "Loading..."
        }
        return CoinData.shared.doubleToMoneyString(money: price)
    } // func priceAsString
    
    /*
     Using Alamofire, get thirty days of historical data for the cryptocoin defined in this object.
    */
    func getHistoricalData() {
        // HTTP request as documented at Alamofire
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
    } // func getHistoricalData
    
    func amountAsString() -> String {
        return CoinData.shared.doubleToMoneyString(money: amount * price )
    } // func amountAsString
    
} // class Coin
