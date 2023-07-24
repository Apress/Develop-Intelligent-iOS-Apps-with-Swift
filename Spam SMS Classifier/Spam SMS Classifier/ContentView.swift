//
//  ContentView.swift
//  Spam SMS Classifier
//
//  Created by ozgur on 6/25/20.
//  Copyright © 2020 com.ozgur. All rights reserved.
//

import SwiftUI

struct ContentView: View {
   @State var textInput:String
     @State var classificationResult:String?
     
    var body: some View {
        VStack{
            Text("Spam SMS Classifier!").font(.title).foregroundColor(.blue)
            Spacer()
            TextField("Enter SMS Message", text: $textInput).multilineTextAlignment(.center).font(.title).textFieldStyle(RoundedBorderTextFieldStyle())
            Button(action: {
                self.classificationResult = Classifier.shared.predict(text: self.textInput)
            }) {
                Text("Classify").font(.title)
            }.frame(width:120, height:40).foregroundColor(.white).background(Color.blue).cornerRadius(10)
            
            Text("Result:\(classificationResult ?? "")").foregroundColor(.red).font(.title)

            Spacer()
        }
    }
    
  
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(textInput: "")
    }
}
