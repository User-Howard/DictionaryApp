//
//  QuizView.swift
//  CambridgeDictionary
//
//  Created by 吳浩瑋 on 2023/1/23.
//

import SwiftUI


struct ProblemView: View {
    var problem: String
    var body: some View {
        VStack {
            Text(problem)
            Color.accentColor
        }
    }
}
struct QuizView: View {
    let apiKey = "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"
    let model = "text-davinci-003"
    @State private var selected = 0
    @State private var waitingResult: Bool = false
    @State private var generatedText: String = "."
    @StateObject var collections = DataSource()
    var body: some View {
        
        ZStack {
            Text(generatedText)
            /*
            TabView(selection: $selected) {
                TextGenerator.ProblemView(problem: "A")
                    .tag(0)
                TextGenerator.ProblemView(problem: "B")
                    .tag(1)
            }.tabViewStyle(.page(indexDisplayMode: .never))*/
        }.onAppear {
            generateQuiz()
        }
    }
    func generateQuiz() {
        self.waitingResult = true
        
        let url = URL(string: "https://api.openai.com/v1/completions")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        var prompt = "用以下單字作為英文單字克漏字的答案。一個單字一題，多用片語。\n請提供題目和答案的json格式檔案，並且不要回其他多餘的回答。\n回傳要類似這一種結構：\n{\"problems\":[{\"problem\":\"\", \"answer\":\"\"}, {\"problem\":\"\", \"answer\":\"\"}\n]}\n"
        for i in collections.words {
            prompt = prompt + i + "\n"
        }
//        prompt += "Apple\nBanana\nWord\nList\nAnticipate"
        let openAIBody = OpenAIBody(model: model, prompt: prompt)
        request.httpBody = try? JSONEncoder().encode(openAIBody)
        request.httpMethod = "post"
        
        print(prompt)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            if let data = data {
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    let choices = responseJSON["choices"] as! [[String: Any]]
                    let firstChoice = choices[0]
                    let generatedText = firstChoice["text"] as! String
                    print(choices)
                    self.generatedText = generatedText.trimmingCharacters( in : .whitespacesAndNewlines)
                    self.waitingResult = false
                }
            }
        }.resume()
    }
}


struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        QuizView()
    }
}
