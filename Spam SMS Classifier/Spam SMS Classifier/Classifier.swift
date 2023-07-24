//
//  Classifier.swift
//  Spam SMS Classifier
//
//  Created by ozgur on 6/25/20.
//  Copyright © 2020 com.ozgur. All rights reserved.
//

import Foundation
class Classifier
{
    static let shared = Classifier()
    func predict(text:String)->String?
    {
        let spamClassifier = SpamClassifier()
        let result = try? spamClassifier.prediction(text: text)
        return result?.label
    }
}
