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
    @StateObject var collections = DataSource()
    @State private var result = Dat()
    @State var Word: String = ""
    @State var showed: Bool = false
    @State var ErrorMessage: String = ""
    var StaticMode: Bool = false
    
    
    var body: some View {
        VStack {
            // Spacer(minLength: 70) // 40
            VStack {
                ZStack {
                    IntroduuctionView(Title: result.word, Phonetics: result.phonetics, Showed: showed, ErrorMessage: ErrorMessage, StaticMode: StaticMode)
                    VStack {
                        HStack {
                            if StaticMode {
                                Text(Word.capitalized)
                                    .font(.system(size: 35, weight: .bold, design: .default))
                                    .padding()
                                    .shadow(radius: 0.2)
                            }
                            else {
                                TextField("Type a word", text: $Word, onEditingChanged: getFocus, onCommit: fetchData)
                                    .keyboardType(.asciiCapable)
                                    .font(.system(size: 30, weight: .bold, design: .default))
                                    .padding()
                                    .shadow(radius: 0.2)
                            }
                            
                        }
                        Spacer()
                    }
                    .frame(height: 60)
                    .offset(y: -10)
                }
                ScrollView(showsIndicators: false) {
                    ForEach(result.meanings, id: \.partOfSpeech) { meaning in
                        DetailsView(PartOfSpeech: meaning.partOfSpeech, Definitions: meaning.definitions, StaticMode: StaticMode)
                            .coordinateSpace(name: meaning.partOfSpeech)
                        Spacer()
                    }
                    Spacer(minLength: 300)
                    
                }
                .offset(y: showed ? 0 : 700)
                .opacity(showed ? 1 : 0)
                .scaleEffect(showed ? 1 : 0.3)
                .animation(.spring().speed(1), value: showed)
                .cornerRadius(0)
                
            }
            .onAppear(perform: fetchData)
            .padding(.horizontal)
        }
        .environmentObject(collections)
        
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
            showed = false
            ErrorMessage = "Invalid Words"
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
                        showed = false
                        ErrorMessage = "Invalid Word"
                        return
                    }
                }
            }
            
            showed = true
            ErrorMessage = ""
        }.resume()
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        SearchingView(Word: "Apple")
            .previewDevice("iPhone 14 Pro Max")
    }
}
struct SearchingBoxView: View {
    var body: some View {
        VStack {}
    }
}

struct IntroduuctionView: View {
    @EnvironmentObject var collections: DataSource
    @Environment(\.presentationMode) var presentationMode
    var Title: String
    var Phonetics: [Phonetic]
    var Showed: Bool
    var ErrorMessage: String
    let StaticMode: Bool
    @State private var astr: String = ""
    
    
    
    @State var d :Bool = true
    
    
    var body: some View {
        ZStack {
            if !StaticMode {
                Color("ResultView.BackgroundColor")
            }
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
                        Image(systemName: collections.words.contains(Title.capitalized) ? "bookmark.fill" : "bookmark")
                            .animation(.default, value: d)
                            .onTapGesture {
                                if collections.words.contains(Title.capitalized) {
                                    collections.words.remove(at: collections.words.firstIndex(of: Title.capitalized)!)
                                }
                                else {
                                    collections.words.append(Title.capitalized)
                                }
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
    let StaticMode: Bool
    
    var body: some View {
        
        ZStack {
            if !StaticMode {
                Color("ResultView.BackgroundColor")
            }
            VStack {
                HStack {
                    Label(PartOfSpeech.capitalized, systemImage: "sun.min.fill")
                        .font(.system(size: 17, weight: .bold))
                    Spacer()
                }
                .padding([.top, .horizontal])
                
                Divider()
                
                ZStack {
                    VStack {
                        let enumerated = Array(zip(Definitions.indices, Definitions))
                        ForEach(enumerated, id:\.0) { index, definition in
                            if index != 0 {
                                Divider()
                                    .padding(.horizontal)
                            }
                            VStack(alignment: .leading) {
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
                            
                            Text("")
                        }
                    }

                }
            }

        }.cornerRadius(8)
        
    }
}
