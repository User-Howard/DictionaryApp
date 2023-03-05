//
//  QuizView.swift
//  CambridgeDictionary
//
//  Created by 吳浩瑋 on 2023/1/23.
//

import SwiftUI

struct SinglePage: View {
    @State var Title_: String
    @State var Body_: String
    var body: some View {
        ZStack {
            ZStack {
                Color("ResultView.BackgroundColor")
                
                ZStack {
                    VStack {
                        Text(Title_)
                            .font(.title.bold())
                            .padding()
                        Text("按下這一個頁面以切換答案/題目")
                            .font(.subheadline)
                            .opacity(0.5)
                        Spacer()
                    }
                    Text(Body_)
                        .font(.body)
                        .padding()
                        .border(.secondary)
                        .padding()
                }
            }.cornerRadius(8)
        }
    }
}
struct ProblemView: View {
    var problem: String
    var answer: String
    var idx: Int
    @State var showAnswer: Bool = false
    var body: some View {
        
        
        ZStack {
            SinglePage(Title_: "Cloze Test \(idx+1)", Body_: problem)
                .rotation3DEffect(.degrees(showAnswer ? 180 : 0), axis: (x: 1, y: 0, z: 0))
                .opacity(showAnswer ? 0 : 1)
                .animation(.easeInOut, value: showAnswer)
            SinglePage(Title_: "Answer", Body_: answer)
                .rotation3DEffect(.degrees(showAnswer ? 0 : 180), axis: (x: 1, y: 0, z: 0))
                .opacity(showAnswer ? 1 : 0)
                .animation(.easeInOut, value: showAnswer)
        }.onTapGesture {
            showAnswer.toggle()
        }
    }
}
struct QuizView: View {
    let apiKey = "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"
    let model = "text-davinci-003"
    @State private var selected = 0
    @State private var waitingResult: Bool = false
    @State private var generatedText: String = "."
    @State private var Problems: Quiz = [QuizElement()]
    @StateObject var collections = DataSource()
    var body: some View {
        
        ZStack {
            TabView() {
                ForEach(Problems.indices, id: \.self) { idx in
                    ProblemView(problem: Problems[idx].problem, answer: Problems[idx].answer, idx: idx)
                        .padding(.horizontal)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(.gray.opacity(waitingResult ? 0.4 : 0))
                .padding(.horizontal)
                .animation(.easeOut, value: waitingResult)
            ProgressView()
                .scaleEffect(waitingResult ? 1: 0)
                .animation(.easeOut, value: waitingResult)
            
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
        var prompt = "用以下單字作為英文單字填充題的答案。一個單字一題，多用片語。\n填空題又稱填充題、完形填空、克漏字（英語：cloze）、克漏字測驗或填空測驗，是在功課、測驗、考試中的其中一種題型，題目會有一段句子，會把當中的部分字詞留空，作答者需要填上合適的文字或標點符號。請提供題目和答案的json格式檔案，並且不要回其他多餘的回答。回傳要類似這一種結構：[{\"problem\":\"\", \"answer\":\"\"},\n{\"problem\":\"\", \"answer\":\"\"}\n]"
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
                do {
                    let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                    if let responseJSON = responseJSON as? [String: Any] {
                        let choices = responseJSON["choices"] as! [[String: Any]]
                        let firstChoice = choices[0]
                        let generatedText = firstChoice["text"] as! String
                        
                        self.generatedText = generatedText.trimmingCharacters( in : .whitespacesAndNewlines)
                        print(self.generatedText)
                        let decodedData = try? JSONDecoder().decode([QuizElement].self, from: Data(self.generatedText.utf8))
                        print(decodedData)
                        self.Problems = decodedData!
                        self.waitingResult = false
                    }
                } catch {
                    print(error)
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
