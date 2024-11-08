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
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    let tweetCount = 100
    
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
        
        //        print("api key: \(apiKey)")
        //        print("api secret: \(apiSecret)")
    }
    
    
    @IBAction func predictPressed(_ sender: Any) {
        
        fetchTweets()
    }
    
    
    func fetchTweets() {
        
        if let searchText = textField.text {
            
            let prediction = try! sentimentClassier.prediction(text: "@Apple is the best company")
            print("Prediction: \(prediction.label)")
            let prediction2 = try! sentimentClassier.prediction(text: "@Apple is a terrible company")
            print("Prediction: \(prediction2.label)")
            let prediction3 = try! sentimentClassier.prediction(text: "#blessed ")
            print("Prediction: \(prediction3.label)")
            // let predictions = [prediction, prediction2]
            
            // does not work with free twitter dev account
            swifter.searchTweet(using: searchText, lang: "en", count: tweetCount, tweetMode: .extended, success: { (results, metadata) in
                // print("results: \(results)")
                
                var tweets = [TweetSentimentClassifierInput]()
                
                for i in 0..<self.tweetCount {
                    if let tweet = results[i]["full_text"].string {
                        print(tweet)
                        let tweetForClassification = TweetSentimentClassifierInput(text: tweet)
                        tweets.append(tweetForClassification)
                    }
                }
                
                self.makePrediction(with: tweets)
                
                // print(tweets)
            }) { error in
                print("There was an error with the Twitter API request: \(error)")
            }
        }
        
    }
    
    func makePrediction(with tweets: [TweetSentimentClassifierInput]) {
        
        do {
            let predictions = try self.sentimentClassier.predictions(inputs: tweets)
            
            var sentimentScore = 0
            
            for prediction in predictions {
                // print(prediction.label)
                let sentiment = prediction.label
                
                if sentiment == "Pos" {
                    sentimentScore += 1
                } else if sentiment == "Neg" {
                    sentimentScore -= 1
                }
            }
            
            //print("SentimentScore: \(sentimentScore)")
            updateUI(with: sentimentScore)
            
            
        } catch {
            print("There was an error with making a prediction: \(error)")
        }
        
        
    }
    
    func updateUI(with sentimentScore: Int) {
        
        if sentimentScore > 20 {
            self.sentimentLabel.text = "😍"
        } else if sentimentScore > 10 {
            self.sentimentLabel.text = "😀"
        } else if sentimentScore > 0 {
            self.sentimentLabel.text = "🙂"
        } else if sentimentScore == 0 {
            self.sentimentLabel.text = "😐"
        } else if sentimentScore > -10 {
            self.sentimentLabel.text = "😕"
        } else if sentimentScore > -20 {
            self.sentimentLabel.text = "😡"
        } else {
            self.sentimentLabel.text = "🤮"
        }
        
    }
    
}

