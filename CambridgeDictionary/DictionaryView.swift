//
//  DictionaryView.swift
//  CambridgeDictionary
//
//  Created by 吳浩瑋 on 2022/7/17.
//

import SwiftUI
import AVFoundation
/*
class Api: ObservableObject {
    
    func fetch() {
        guard let url = URL(string: "https://api.dictionaryapi.dev/api/v2/entries/en/hello") else { return }
        URLSession.shared.dataTask(with: url) { {data, , } in
            let meanings = try! JSONDecoder.decode()
        }
            
    }
}*/
struct DictionaryView: View {
    
    var body: some View {
        VStack {
            Spacer(minLength: 40)
            VStack {
                // Color.accentColor
                Button("Play Voice", action: {
                    //需要阅读的文本
                    let utterance = AVSpeechUtterance(string: "你好")
                    //指定发音
                    utterance.voice = AVSpeechSynthesisVoice(language: "zh-CN")
                    //控制速度
                    utterance.rate = 0.4
                    let synthesizer = AVSpeechSynthesizer()
                    synthesizer.speak(utterance)
                })
                Button() {
                    let utterance = AVSpeechUtterance(string: "apple")
                    utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
                    let synthesizer = AVSpeechSynthesizer()
                    synthesizer.speak(utterance)
                }label: {
                    Image(systemName: "speaker.wave.3.fill")
                        .foregroundColor(Color.secondary)
                }
            }
            Spacer(minLength: 1)
        }.edgesIgnoringSafeArea([.top])

    }
}

struct DictionaryView_Previews: PreviewProvider {
    static var previews: some View {
        DictionaryView()
            .previewDevice("iPhone 11")
    }
}
