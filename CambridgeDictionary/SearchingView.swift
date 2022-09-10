//
//  ResultView.swift
//  CambridgeDictionary
//
//  Created by 吳浩瑋 on 2022/7/17.
//

import SwiftUI
import AVFoundation
import MediaPlayer



struct SearchingView: View {
    
    
    @Environment(\.presentationMode) var presentationMode
    @State private var result = Dat()
    @State var Word: String = ""
    @State var showed: Bool = false
    @State var ErrorMessage: String = ""
    
    var body: some View {
        VStack {
            Spacer(minLength: 70) // 40
            VStack {
                ZStack {
                    IntroduuctionView(Title: result.word, Phonetics: result.phonetics, Showed: showed, ErrorMessage: ErrorMessage)
                        .padding([.top, .horizontal])
                    VStack {
                        HStack {
                            TextField("Type a word", text: $Word, onEditingChanged: getFocus, onCommit: fetchData)
                                .font(.system(size: 30, weight: .bold, design: .default))
                                .padding()
                        }
                        Spacer()
                    }.frame(width: .infinity, height: 70)
                        .padding()
                }
                ZStack{
                    // Color.blue
                    ScrollView(showsIndicators: false) {
                        ForEach(result.meanings, id: \.partOfSpeech) { meaning in
                            DetailsView(PartOfSpeech: meaning.partOfSpeech, Definitions: meaning.definitions)

                        }
                        Spacer(minLength: 100)
                    }.offset(y: showed ? 0 : 700)
                        .opacity(showed ? 1 : 0)
                        .scaleEffect(showed ? 1 : 0.7)
                        .animation(.easeIn, value: showed)
                }
                .cornerRadius(8)
                .padding(.horizontal)
            }.onAppear(perform: fetchData)
            
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
    func getFocus(focused:Bool) {
        if focused {
            showed = false
        }
    }
    func fetchData() {
        let urlString: String = "https://api.dictionaryapi.dev/api/v2/entries/en/" + Word.trimmingCharacters(in: .whitespaces)

        print("Fetch ... ", urlString)
        guard let url = URL(string: urlString) else {
            print("Invalid url.")
            ErrorMessage = "Invalid Word"
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
            ErrorMessage = ""
            showed = true
        }.resume()
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        SearchingView()
            .previewDevice("iPhone 11")
    }
}

struct IntroduuctionView: View {
    
    var Title: String
    var Phonetics: [Phonetic]
    var Showed: Bool
    var ErrorMessage: String
    @State private var astr: String = ""
    
    
    
    @State var d :Bool = true
    
    
    var body: some View {
        ZStack {
            Color("ResultView.BackgroundColor")
            VStack {
                Spacer()
                HStack {
                    if Phonetics.count > 0 && Phonetics[0].text != "" && Phonetics[0].text != nil {
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
                        Image(systemName: d ? "bookmark" : "bookmark.fill")
                            .onTapGesture {
                                d.toggle()
                            }
                    }
                }
            }
            .padding()
            VStack {
                HStack {
                    Spacer()
                    Text(ErrorMessage)
                        .font(.system(size: 10, design: .monospaced))
                        .animation(.easeOut, value: ErrorMessage)
                    Circle()
                        .foregroundColor(Showed ? .green : .red)
                        .animation(.easeOut, value: Showed)
                        .frame(width: 5, height: 5)
                        .padding(3)
                }
                Spacer()
            }
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
                        .padding(.horizontal, 5)
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


