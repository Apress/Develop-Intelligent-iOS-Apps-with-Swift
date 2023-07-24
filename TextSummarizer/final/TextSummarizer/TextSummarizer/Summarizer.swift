
import NaturalLanguage


struct SentenceAndRank
{
    var sentence:String
    var rank:Int
    var index:Int
}


class Summarizer
{
    
    let stopWords = ["a", "about", "above", "across", "after", "afterwards", "again", "against", "all", "almost", "alone", "along", "already", "also", "although", "always", "am", "among", "amongst", "amoungst", "amount", "an", "and", "another", "any", " anyhow", "anyone", "anything", "anyway", "anywhere", "are", "around", "as", "at", "back", "be", "became", "because", "become", "becomes", "becoming", "been", "before", "beforehand", "behind", "being", "below", "beside", "besides", "between", "beyond", "bill", "both", "bottom", "but", "by", "call", "can", "cannot", "cant", "co", "con", "could", "couldnt", "cry", "de", "describe", "detail", "do", "done", "down", "due", "during", "each", "eg", "eight", "either", "eleven", "else", "elsewhere", "empty", "enough", "etc", "even", "ever", "every", "everyone", "everything", "everywhere", "except", "few", "fifteen", "fify", "fill", "find", "fire", "first", "five", "for", "former", "formerly", "forty", "found", "four", "from", "front", "full", "further", "get", "give", "go", "had", "has", "hasnt", "have", "he", "hence", "her", "here", "hereafter", "hereby", "herein", "hereupon", "hers", "herself", "him", "himself", "his", "how", "however", "hundred", "ie", "if", "in", "inc", "indeed", "interest", "into", "is", "it", "its", "itself", "keep", "last", "latter", "latterly", "least", "less", "ltd", "made", "many", "may", "me", "meanwhile", "might", "mill", "mine", "more", "moreover", "most", "mostly", "move", "much", "must", "my", "myself", "name", "namely", "neither", "never", "nevertheless", "next", "nine", "no", "nobody", "none", "noone", "nor", "not", "nothing", "now", "nowhere", "of", "off", "often", "on", "once", "one", "only", "onto", "or", "other", "others", "otherwise", "our", "ours", "ourselves", "out", "over", "own", "part", "per", "perhaps", "please", "put", "rather", "re", "same", "see", "seem", "seemed", "seeming", "seems", "serious", "several", "she", "should", "show", "side", "since", "sincere", "six", "sixty", "so", "some", "somehow", "someone", "something", "sometime", "sometimes", "somewhere", "still", "such", "system", "take", "ten", "than", "that", "the", "their", "them", "themselves", "then", "thence", "there", "thereafter", "thereby", "therefore", "therein", "thereupon", "these", "they", "thickv", "thin", "third", "this", "those", "though", "three", "through", "throughout", "thru", "thus", "to", "together", "too", "top", "toward", "towards", "twelve", "twenty", "two", "un", "under", "until", "up", "upon", "us", "very", "via", "was", "we", "well", "were", "what", "whatever", "when", "whence", "whenever", "where", "whereafter", "whereas", "whereby", "wherein", "whereupon", "wherever", "whether", "which", "while", "whither", "who", "whoever", "whole", "whom", "whose", "why", "will", "with", "within", "without", "would", "yet", "you", "your", "yours", "yourself", "yourselves"]
    
    private func splitTo(text:String, unit:NLTokenUnit) -> [String]
    {
        let tokenizer = NLTokenizer(unit: unit)
        tokenizer.string = text
        var tokens = [String]()
        tokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { range, _ in
            tokens.append(String(text[range]))
            return true
        }
        return tokens
    }
    
    private func calculateWordFrequencies(text: String) -> [String: Int] {
        var frequencyList = [String: Int]()
        let tagger = NSLinguisticTagger(tagSchemes: [.tokenType], options: 0)
        let range = NSRange(location: 0, length: text.utf16.count)
        let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace]
        tagger.string = text.lowercased()
        
        tagger.enumerateTags(in: range, unit: .word, scheme: .tokenType, options: options) { _, tokenRange, _ in
            let word = (text as NSString).substring(with: tokenRange)
            if frequencyList[word] != nil {
                frequencyList[word]! += 1
            } else {
                frequencyList[word] = 1
            }
        }
        return frequencyList
    }
    
    private func getWordFrequencySum(sentence:String, frequencies:[String:Int])->Int
    {
        let wordList = splitTo(text: sentence, unit: .word)
        
        var rank = 0
        for word in wordList
        {
            if !stopWords.contains(word)
            {
                rank += frequencies[word, default: 0]
            }
        }
        return rank
    }
    
    func summarize(text:String)->String
    {
        let wordFrequencies = calculateWordFrequencies(text: text)
        let sentences = splitTo(text: text, unit: .sentence)
        var sentenceAndRank:[SentenceAndRank] = []
        for (index, sentence) in sentences.enumerated()
        {
            let rank = getWordFrequencySum(sentence: sentence,frequencies: wordFrequencies)
            sentenceAndRank.append(SentenceAndRank(sentence: sentence, rank: rank, index:index))
        }
        // Sort Sentences by ranking
        let sentencesByRanking = sentenceAndRank.sorted { $0.rank > $1.rank }
        // Select the most important 3 sentences
        let keySentences = sentencesByRanking.prefix(3)
        //return in sentence order and merge all sentences into one sentence
        return keySentences.sorted {$0.index < $1.index }.map{$0.sentence}.joined()
    }

}
