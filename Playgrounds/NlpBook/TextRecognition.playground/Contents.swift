import UIKit
import Vision

let uiImage = UIImage(named: "text2")!
var image = uiImage.cgImage!

var textResults = ""

let textRecognitionRequest = VNRecognizeTextRequest { (request, error) in
    guard let observations = request.results as? [VNRecognizedTextObservation] else {
        print("The observations are of an unexpected type.")
        return
    }
    let maximumCandidates = 1
    for observation in observations {
        guard let candidate = observation.topCandidates(maximumCandidates).first else { continue }
        textResults += candidate.string + "\n"
    }
}

textRecognitionRequest.recognitionLevel = .accurate

let requestHandler = VNImageRequestHandler(cgImage: image, options: [:])

do {
    try requestHandler.perform([textRecognitionRequest])
} catch {
    print(error)
}


textResults

print(textResults)
