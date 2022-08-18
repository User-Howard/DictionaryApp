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
    var Word: String
    
    
    var body: some View {
        VStack {
            Spacer(minLength: 80)
            ZStack {
                // Color.green
                VStack {
                    IntroduuctionView(Title: result.word, Phonetics: "result.phonetics.text")
                        .padding([.top, .horizontal])
                    
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
                .task {
                    await fetchData()
                }
            }.cornerRadius(15)
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
    
    func fetchData() async {
        let urlString: String = "https://api.dictionaryapi.dev/api/v2/entries/en/" + Word

        print("Fetching ... ", urlString)
        guard let url = URL(string: urlString) else {
            print("Invalid url.")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodeResponse = try? JSONDecoder().decode([Dat].self, from: data) {
                result = decodeResponse[0]
            }
        } catch {
            print("data isn't vaild")
        }
        print("Data", result)
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(Word: "word")
            .previewDevice("iPhone 11")
    }
}

struct IntroduuctionView: View {
    
    @ObservedObject private var volObserver = VolumeObserver()
    var Title: String
    var Phonetics: String
    
    
    var body: some View {
        ZStack {
            Color("ResultView.BackgroundColor")
            VStack {
                HStack {
                    Text(Title)
                        .lineLimit(1)
                        .minimumScaleFactor(0.3)
                        .font(.system(size: 30, weight: .bold, design: .default))
                    Spacer()
                }
                .padding(.bottom, 1)
                HStack {
                    Text(Phonetics)
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
            .padding(.horizontal)
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
