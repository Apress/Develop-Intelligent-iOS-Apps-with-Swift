import UIKit
import Vision
//Built in image classify sample
let image =  #imageLiteral(resourceName: "car.jpeg")

let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
let classes = try VNClassifyImageRequest.knownClassifications(forRevision: VNDetectFaceLandmarksRequestRevision1)

let classIdentifiers = classes.map({$0.identifier})

print(classIdentifiers.count)
print(classIdentifiers)

let request = VNClassifyImageRequest()
try? handler.perform([request])

// Process classification results
let observations = request.results as? [VNClassificationObservation]

//Filter high confidence results using recall and precision
let categories = observations?
.filter { $0.hasMinimumRecall(0.01, forPrecision: 0.9) }
.reduce(into: [String: VNConfidence]()) { dict, observation in dict[observation.identifier] = observation.confidence }


