import CreateML
import Foundation

if let textData = try? MLDataTable(contentsOf: URL(fileURLWithPath: "/Users/quangkhatran/Desktop/iPhone/headlines.json")) {
    let (training, testing) = textData.randomSplit(by: 0.8, seed: 2)
    if let classifier = try? MLTextClassifier(trainingData: training, textColumn: "title", labelColumn: "category") {
        print(classifier.evaluation(on: testing).classificationError)
        let metaData = MLModelMetadata(author: "Quang Kha Tran" , shortDescription: "News classifier", license: "Unknown", version: "1.0", additional: nil)
        try? classifier.write(to: URL(fileURLWithPath: "/Users/quangkhatran/Desktop/iPhone/Headlines.mlmodel"), metadata: metaData)
    }
}

