//
//  TextClassificationWithGRUTests.swift
//  TextClassificationWithGRUTests
//
//  Created by ozgur on 8/9/20.
//  Copyright © 2020 com.ozgur. All rights reserved.
//

import XCTest
import TextClassificationWithGRU
import CoreML

class TextClassificationWithGRUTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testModel() throws {
        let model = imdbGRU()
        let maxLength = 300
        guard let input_data = try? MLMultiArray(shape:[NSNumber(value: maxLength),1,1], dataType:.double) else {
            fatalError("Unexpected runtime error: input_data")
        }

        input_data[0] = NSNumber(value: 1162)
        input_data[1] = NSNumber(value: 643)
        
        //padding rest with 0s
        for i in 2..<maxLength {
            input_data[i] = NSNumber(value: 0.0)
        }
        let input =  imdbGRUInput(input: input_data, gru_2_h_in: nil)
        //prediction
        guard let prediction = try? model.prediction(input: input) else {
            fatalError("Unexpected runtime error: prediction")
        }
        
        print(prediction)
        print(prediction.output[0])
        XCTAssert(0.6204904317855835 == prediction.output[0])
    }
}




