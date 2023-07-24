import UIKit
import Vision

func featureprintObservationForImage(atURL url: URL) -> VNFeaturePrintObservation? {
       let requestHandler = VNImageRequestHandler(url: url, options: [:])
       let request = VNGenerateImageFeaturePrintRequest()
       do {
           try requestHandler.perform([request])
           return request.results?.first as? VNFeaturePrintObservation
       } catch {
           print("Vision error: \(error)")
           return nil
       }
   }




let apple1 = featureprintObservationForImage(atURL: Bundle.main.url(forResource:"apple1", withExtension: "jpg")!)

let apple2 = featureprintObservationForImage(atURL: Bundle.main.url(forResource:"apple2", withExtension: "jpg")!)

let pear = featureprintObservationForImage(atURL: Bundle.main.url(forResource:"pear", withExtension: "jpg")!)

var distance = Float(0)
try apple1!.computeDistance(&distance, to: apple2!)
distance
var distance2 = Float(0)
try apple1!.computeDistance(&distance2, to: pear!)
distance2
