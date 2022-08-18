//
//  ResultView.swift
//  CambridgeDictionary
//
//  Created by 吳浩瑋 on 2022/7/17.
//

import SwiftUI
import AVFoundation
import MediaPlayer



struct ResultView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var result = Dat()
    @State var Word: String = "apple"
    
    
    var body: some View {
        VStack {
            Spacer(minLength: 80)
            VStack {
                ZStack {
                    IntroduuctionView(Title: result.word, Phonetics: result.phonetics)
                        .padding([.top, .horizontal])
                    VStack {
                        TextField("apple", text: $Word, onCommit: fetchData)
                            .font(.system(size: 30, weight: .bold, design: .default))
                            .padding()
                        Spacer()
                    }.frame(minWidth: 0, idealWidth: 100, maxWidth: .infinity, minHeight: 0, idealHeight: 20, maxHeight: 90, alignment: .leading)
                        .padding()
                }
                
                ZStack{
                    // Color.blue
                    ScrollView {
                        ForEach(result.meanings, id: \.partOfSpeech) { meaning in
                            DetailsView(PartOfSpeech: meaning.partOfSpeech, Definitions: meaning.definitions)
                        }
                        Spacer(minLength: 200)
                    }
                }
                .cornerRadius(8)
                .padding(.horizontal)
                
            }
            
        }.edgesIgnoringSafeArea([.top, .bottom])
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading:
                                    Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "arrow.turn.up.left")
                    .foregroundColor(.secondary)
            })
            )
        
    }
    
    func fetchData() {
        let urlString: String = "https://api.dictionaryapi.dev/api/v2/entries/en/" + Word

        print("Fetching ... ", urlString)
        guard let url = URL(string: urlString) else {
            print("Invalid url.")
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let decodedData = try decoder.decode([Dat].self, from: data)
                        self.result = decodedData[0]
                    } catch {
                        print(error)
                    }
                }
            }
        }.resume()
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(Word: "word")
            .previewDevice("iPhone 11")
    }
}

struct IntroduuctionView: View {
    
    var Title: String
    var Phonetics: [Phonetic]
    @State private var astr = ""
    
    
    var body: some View {
        ZStack {
            Color("ResultView.BackgroundColor")
            VStack {
                Spacer()
                HStack {
                    Text(Phonetics[0].text!)
                        .font(.system(size: 16, weight: .regular, design: .monospaced))
                        .foregroundColor(.secondary)
                    Button() {
                        let utterance = AVSpeechUtterance(string: Title)
                        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
                        let synthesizer = AVSpeechSynthesizer()
                        synthesizer.speak(utterance)
                    }label: {
                        Image(systemName: "speaker.wave.3.fill")
                            .foregroundColor(Color.secondary)
                    }
                    Spacer()
                }
            }
            .padding()
        }.frame(minWidth: 0, idealWidth: 100, maxWidth: .infinity, minHeight: 0, idealHeight: 20, maxHeight: 90, alignment: .leading)
            .cornerRadius(8)
    }
}

struct DetailsView: View {
    
    var PartOfSpeech: String
    var Definitions: [Definition]
    
    
    var body: some View {
        ZStack {
            Color("ResultView.BackgroundColor")
            VStack {
                HStack {
                    Label(PartOfSpeech, systemImage: "sun.min.fill")
                        .font(.system(size: 17, weight: .bold))
                    Spacer()
                }
                .padding([.top, .horizontal])
                ForEach(Definitions, id:\.definition) { definition in
                    Divider()
                        .padding(.horizontal)
                    VStack {
                        HStack {
                            Text(definition.definition)
                                .padding([.horizontal])
                            Spacer()
                        }
                        if definition.example != nil {
                            Text("")
                            HStack {
                                Text(definition.example!)
                                    .font(.system(size: 16, design: .default))
                                    .italic()
                                    .padding([.horizontal])
                                Spacer()
                            }
                        }
                    }.padding(5)
                }
                Text("")
            }
        }.cornerRadius(8)
    }
}
