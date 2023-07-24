//
//  Process.swift
//  TestLSTM
//
//  Created by ozgur on 8/6/20.
//  Copyright © 2020 com.ozgur. All rights reserved.
//

import Foundation
import CoreML
import NaturalLanguage

class GRUModel {

    var wordDictionary: [String: Int] = {
        return try! JSONDecoder().decode(Dictionary<String, Int>.self, from: Data(contentsOf: Bundle.main.url(forResource:"imdb_word_index", withExtension: "json")!))
    }()
    
    func predict(text:String)->String  {
        let words = splitToWords(text: text)
        var embedding = [Int]()
        for word in words {
            embedding.append(wordDictionary[word] ?? 0)
        }
        let model = imdbGRU()
        let maxLength = 300
        let maxLengthNumber = NSNumber(value: maxLength)
        guard let input_data = try? MLMultiArray(shape:[maxLengthNumber,1,1], dataType:.double) else {
            fatalError("MLMultiArray error: input_data")
        }
        for (index,element) in embedding.enumerated()
        {
            input_data[index] = NSNumber(value: element)
        }
        //padding rest with 0s
        for i in embedding.count..<maxLength {
            input_data[i] = NSNumber(value: 0.0)
        }
        let input =   imdbGRUInput(input: input_data)
        guard let prediction = try? model.prediction(input: input) else {
            fatalError("Prediction error")
        }
        if prediction.output[0].doubleValue > 0.5
        {return "positive"}
        else
        {return "negative"}
    }
    
    private func splitToWords(text:String) -> [String]
    {
        
        let lowerCasedText = text.lowercased()
        let tokenizer = NLTokenizer(unit: .word)
        tokenizer.string = lowerCasedText
        var tokens = [String]()
        tokenizer.enumerateTokens(in: lowerCasedText.startIndex..<lowerCasedText.endIndex) { range, _ in
            tokens.append(String(lowerCasedText[range]))
            return true
        }
        return tokens
    }
}
