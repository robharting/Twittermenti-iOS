//
//  ViewController.swift
//  Twittermenti
//
//  Created by Angela Yu on 17/07/2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import Swifter
import CoreML

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    let sentimentClassier = TweetSentimentClassifier()
    
    private var apiKey: String {
      get {
        // 1
        guard let filePath = Bundle.main.path(forResource: "Secrets", ofType: "plist") else {
          fatalError("Couldn't find file 'Secrets.plist'.")
        }
        // 2
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "API_KEY") as? String else {
          fatalError("Couldn't find key 'API_KEY' in 'Secrets.plist'.")
        }
          return value
      }
    }
    
    
    private var apiSecret: String {
      get {
        // 1
        guard let filePath = Bundle.main.path(forResource: "Secrets", ofType: "plist") else {
          fatalError("Couldn't find file 'Secrets.plist'.")
        }
        // 2
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "API_SECRET") as? String else {
          fatalError("Couldn't find key 'API_SECRET' in 'Secrets.plist'.")
        }
          return value
      }
    }
    
    
    lazy var swifter = Swifter(consumerKey: apiKey, consumerSecret: apiSecret)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("api key: \(apiKey)")
        print("api secret: \(apiSecret)")
        
        
        let prediction = try! sentimentClassier.prediction(text: "@Apple is the best company")
        print("Prediction: \(prediction.label)")
        let prediction2 = try! sentimentClassier.prediction(text: "@Apple is a terrible company")
        print("Prediction: \(prediction2.label)")
        
        // does not work woth free twitter dev account
//        swifter.searchTweet(using: "@Apple", lang: "en", count: 100, tweetMode: .extended, success: { (results, metadata) in
//            print("results: \(results)")
//        }) { error in
//            print("There was an error with the Twitter API request: \(error)")
//        }
    
        
    }

    @IBAction func predictPressed(_ sender: Any) {
    
    
    }
    
}

