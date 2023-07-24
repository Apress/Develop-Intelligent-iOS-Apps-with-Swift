
//SPAM SMS Classifier

import CreateML
import Foundation

let datasetURL = URL(fileURLWithPath: "/Users/ozgur/Desktop/NLP book REFS/dataset/spamCleaned.csv")
var table = try MLDataTable(contentsOf: datasetURL)

let classifier = try MLTextClassifier(trainingData: table, textColumn: "v2", labelColumn: "v1")


let (trainingData, testingData) = table.randomSplit(by: 0.8)

let spamClassifier = try MLTextClassifier(trainingData: trainingData,
textColumn: "v2",
labelColumn: "v1")


spamClassifier.trainingMetrics
spamClassifier.validationMetrics
let evaluationMetrics = spamClassifier.evaluation(on: testingData, textColumn: "v2", labelColumn: "v1")


try spamClassifier.prediction(from: "We are trying to contact you. Last weekends draw shows that you won a £1000 prize GUARANTEED. Call 09064012160.")
//spam

try spamClassifier.prediction(from: "We are trying to contact you. Have you arrived to your house?")
//ham


let metadata = MLModelMetadata(author: "Ozgur Sahin", shortDescription: "Spam Classifier", license: "MIT", version: "1.0")


try? classifier.write(to: URL(fileURLWithPath: "users/ozgur/Desktop/SpamClassifier.mlmodel"))



//import NaturalLanguage
//
//let modelParameter = MLTextClassifier.ModelParameters(validationData: nil, algorithm:MLTextClassifier.ModelAlgorithmType.maxEnt(revision:1), language:NLLanguage.turkish)



//let classifier2 = try MLTextClassifier(trainingData: table, textColumn: "text", labelColumn: "label",parameters:modelParameter)

