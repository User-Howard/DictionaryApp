//
//  IntelligentView.swift
//  CambridgeDictionary
//
//  Created by 吳浩瑋 on 2023/1/2.
//

import Foundation
import SwiftUI

struct OpenAIBody: Encodable {
    let model: String
    let prompt: String
    let temperature = 0
    let max_tokens = 512
    let top_p = 1
    let frequency_penalty = 0
    let presence_penalty = 0
}


struct TextGenerator: View {
    @State private var generatedText = ""
    @State private var inputText = ""
    @State var waitingResult: Bool = false
    
    let apiKey = "sk-"
    let model = "text-davinci-003"
    @FocusState private var isFocused: Bool
    
    let modes = ["文法修正", "創造例句", "克漏字測驗", ""]
    let preprompt = ["將以下英文以標準美式英文修正，並說明原因：\n",
                     "用以下提供的英文單字造句，每一列造一句，以列表呈現。盡量多樣化一些，可以多用片語和困難的單字。如果沒有提供給你任何英文單字的話就不用輸出。\n",
                     "用以下單字作為英文單字克漏字的答案。一個單字一題，多用片語。\n請提供題目和答案的json格式檔案，並且不要回其他多餘的回答。\n回傳要類似這一種結構：\n{\"problems\":[{\"problem\":\"\", \"answer\":\"\"}, {\"problem\":\"\", \"answer\":\"\"}\n]}\n"
    ]
    @State var selectedMode = 0
    
    
    @ViewBuilder var InputBoxView: some View {
        ZStack {
            Color("ResultView.BackgroundColor")
            TextField("", text: $inputText, prompt: Text("Enter some text here..."), axis: .vertical)
                .font(.system(size: 20, weight: .medium, design: .default))
                .focused($isFocused)
                .padding()
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Image(systemName: "keyboard.chevron.compact.down.fill")
                            .onTapGesture {
                                isFocused = false
                            }
                            .padding()
                        Image(systemName: "arrowshape.turn.up.right.fill")
                            .onTapGesture {
                                isFocused = false
                                generateText()
                            }
                    }
                }
            HStack {
                Spacer()
                VStack {
                    Button(action: {
                        inputText = ""
                        isFocused = true
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    })
                    .padding()
                    Spacer()
                }
            }
        }
        .frame(height: 200)
        .contextMenu {
            Button(action: {
                UIPasteboard.general.string = inputText
            }, label: {
                Label("複製到剪貼板", systemImage: "doc.on.clipboard")
            })
            
        }
        .cornerRadius(8)
        .padding(.horizontal)
    }
    @ViewBuilder var PickModePicker: some View {
        ZStack {
            Color("ResultView.BackgroundColor")
            Picker(selection: $selectedMode, label: Text("Prompts")) {
                Text(modes[0]).tag(0)
                Text(modes[1]).tag(1)
                Text(modes[2]).tag(2)
            }
            .onSubmit {
                generateText()
            }
        }
        .frame(height: 45)
        .cornerRadius(8)
    }
    @ViewBuilder var ResultView: some View {
        ZStack {
            Color("ResultView.BackgroundColor")
            HStack {
                VStack {
                    Text(generatedText)
                    Spacer()
                }
                .padding()
                Spacer()
            }
        }
        .contextMenu {
            Button(action: {
                UIPasteboard.general.string = generatedText
            }, label: {
                Label("複製到剪貼板", systemImage: "doc.on.clipboard")
            })
            
        }
        .cornerRadius(8)
        .padding(.horizontal)
    }
    var body: some View {
        VStack {
            // Label("Enter some text here...", systemImage: "square.and.pencil")
            PickModePicker
                .padding(.horizontal)
            if (selectedMode != 2) {
                InputBoxView
            }
            
            if (selectedMode == 2) {
                QuizView()
            }
            ZStack {
                if (selectedMode != 2) {
                    ResultView
                        .cornerRadius(8)
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(.gray.opacity(waitingResult ? 0.4 : 0))
                            .padding(.horizontal)
                            .animation(.easeOut, value: waitingResult)
                        ProgressView()
                            .scaleEffect(waitingResult ? 1: 0)
                            .animation(.easeOut, value: waitingResult)
                    }
                }
            }
            Spacer()
        }
    }
    
    func generateText() {
        if (inputText.trimmingCharacters( in : .whitespacesAndNewlines)=="") {
            return
        }
        self.generatedText = "Loading..."
        self.waitingResult = true
        
        let url = URL(string: "https://api.openai.com/v1/completions")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let prompt = preprompt[selectedMode] + "\n" + inputText
        let openAIBody = OpenAIBody(model: model, prompt: prompt)
        request.httpBody = try? JSONEncoder().encode(openAIBody)
        request.httpMethod = "post"
        
        
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


struct IntelligentView_Previews: PreviewProvider {
    static var previews: some View {
        TextGenerator()
    }
}
