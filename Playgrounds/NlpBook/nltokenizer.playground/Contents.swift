import NaturalLanguage

let text = "A colourful image of blood vessel cells has won this year's Reflections of Research competition, run by the British Heart Foundation"

let tokenizer = NLTokenizer(unit: .word)
tokenizer.string = text

tokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { tokenRange, _ in
    print(text[tokenRange])
    return true
}
