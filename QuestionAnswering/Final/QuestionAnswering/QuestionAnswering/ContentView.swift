//
//  ContentView.swift
//  QuestionAnswering
//
//  Created by ozgur on 7/20/20.
//  Copyright © 2020 com.ozgur. All rights reserved.
//

import SwiftUI
import UIKit
import Speech

private var recognitionTask: SFSpeechRecognitionTask?
private let audioEngine = AVAudioEngine()
private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!


struct ContentView: View {
    
    @State var attributedText = NSMutableAttributedString(string: "Apple Inc. is an American multinational technology company headquartered in Cupertino, California, that designs, develops, and sells consumer electronics, computer software, and online services. It is considered one of the Big Tech technology companies, alongside Amazon, Google, Microsoft and Facebook. The company's hardware products include the iPhone smartphone, the iPad tablet computer, the Mac personal computer, the iPod portable media player, the Apple Watch smartwatch, the Apple TV digital media player, the AirPods wireless earbuds and the HomePod smart speaker. Apple's software includes macOS, iOS, iPadOS, watchOS, and tvOS operating systems, the iTunes media player, the Safari web browser, the Shazam music identifier, and the iLife and iWork creativity and productivity suites, as well as professional applications like Final Cut Pro, Logic Pro, and Xcode. Its online services include the iTunes Store, the iOS App Store, Mac App Store, Apple Music, Apple TV+, iMessage, and iCloud. Other services include Apple Store, Genius Bar, AppleCare, Apple Pay, Apple Pay Cash, and Apple Card.")
    @State var question = "Where is Apple Inc?"
    
    let bert = BERT()
    
    var body: some View {
        VStack
            {
                TextView(attributedText: $attributedText)
                TextField("Enter your question",text:$question)
                
                HStack{
                Button(action: {
                    // Run the search in the background to keep the UI responsive.
                    DispatchQueue.global(qos: .userInitiated).async {
                        // Use the BERT model to search for the answer.
                        let answer = self.bert.findAnswer(for: self.question, in: self.attributedText.string)
                        
                        // Update the UI on the main queue.
                        DispatchQueue.main.async {
                            
                            let mutableAttributedText = NSMutableAttributedString(string: self.attributedText.string)
                            let location = answer.startIndex.utf16Offset(in: self.attributedText.string)
                            let length = answer.endIndex.utf16Offset(in: self.attributedText.string) - location
                            let answerRange = NSRange(location: location, length: length)
                            let fullTextColor = UIColor.red
                            
                            mutableAttributedText.addAttributes([.foregroundColor: fullTextColor, .backgroundColor:UIColor.yellow],
                                                                range: answerRange)
                            self.attributedText = mutableAttributedText
                        }
                        print(String(answer))
                        self.speechToText(text: String(answer))
                        
                    }
                }){Text("Find")}.padding()
                
                Button(action:{
                    self.transcribe { (speechText) in
                        self.question = speechText
                    }
                }){Text("Speak")}
                    
                }
        }.onAppear{
            self.requestTranscribePermissions()
        }
        
    }
    
    func speechToText(text:String)
    {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
    func requestTranscribePermissions() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                if authStatus == .authorized {
                    print("Authorized for transcription")
                } else {
                    print("Transcription permission was declined.")
                }
            }
        }
    }
    
    
    func transcribe(completionHandler: @escaping (String)->()) {
        // Cancel the previous task if it's running.
        recognitionTask?.cancel()
        recognitionTask = nil
        // Configure the audio session for the app.
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try? audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode
        
        // Create and configure the speech recognition request.
        let recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        recognitionRequest.shouldReportPartialResults = true
        // Create a recognition task for the speech recognition session.
        // Keep a reference to the task so that it can be canceled.
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                print("Text \(result.bestTranscription.formattedString)")
                completionHandler(result.bestTranscription.formattedString)
            }
        }
        // Configure the microphone input.
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            recognitionRequest.append(buffer)
        }
        audioEngine.prepare()
        try? audioEngine.start()
        print("Raady to transcribe")
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
