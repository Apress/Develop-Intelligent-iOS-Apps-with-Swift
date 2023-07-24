//
//  TextView.swift
//  QuestionAnswering
//
//  Created by ozgur on 7/20/20.
//  Copyright © 2020 com.ozgur. All rights reserved.
//

import SwiftUI
struct TextView: UIViewRepresentable {

    @Binding var text:String
 
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        return textView
    }
 
    func updateUIView(_ uiView: UITextView, context: Context) {

        uiView.text = text
    }
}
