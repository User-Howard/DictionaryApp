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
    @State private var generatedText = "Loading..."
    @State private var inputText = "Enter some text here..."
    
    let apiKey = "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"
    let model = "text-davinci-003"
    let prompt = "Correct this to standard English:\n\nShe no went to the market."
    
    var body: some View {
        VStack {
            if #available(iOS 16.0, *) {
                TextField("Enter some text here...", text: $inputText, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .padding()
            } else {
                TextField("Enter some text here...", text: $inputText)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                // Fallback on earlier versions
            }
            Button(action: generateText) {
                Text("Generate Text")
            }
            .padding()
            Text(generatedText)
                .padding()
        }
    }
    
    func generateText() {
        let url = URL(string: "https://api.openai.com/v1/completions")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
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
                    self.generatedText = generatedText
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
