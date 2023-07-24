import Cocoa
import CreateML

let datasetURL = URL(fileURLWithPath: "/Users/ozgur/Desktop/NLP book REFS/dataset/spamCleaned.csv")
var table = try MLDataTable(contentsOf: datasetURL)

func createFiles(from rows:MLDataTable.Rows) {
    for (index,row) in rows.enumerated() {
        if let text = row["v2"]?.debugDescription,
              let label = row["v1"]?.debugDescription
        {
            do {

                var folder = "spam"
                if label == "ham"
                {
                   folder = "ham"
                }
                let fileURL = URL(fileURLWithPath: "/Users/ozgur/Desktop/NLP book REFS/dataset/spamsetInFolders/\(folder)/\(index).csv")
                    
                try text.write(to: fileURL, atomically: true, encoding: .utf8)
            } catch {
                print("error creating file")
            }
        }

    }
}

createFiles(from: table.rows)
