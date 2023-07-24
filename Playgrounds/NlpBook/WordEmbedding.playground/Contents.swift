import NaturalLanguage
//calculate distance between words
let embedding = NLEmbedding.wordEmbedding(for: .english)
let distance1 = embedding?.distance(between: "movie", and: "film")
let distance2 = embedding?.distance(between: "movie", and: "car")
