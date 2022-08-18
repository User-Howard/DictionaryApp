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
                    IntroduuctionView(Title: result.word, Phonetics: "dsf")
                        .padding([.top, .horizontal])
                    
                    ZStack{
                        // Color.blue
                        ScrollView {
                            VStack(alignment: .leading) {
                                DetailsView(PartOfSpeech: "Verb")
                                DetailsFINALView(Title_: "Interjection")
                                Spacer(minLength: 200)
                            }
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
        print("A")
        let urlString: String = "https://api.dictionaryapi.dev/api/v2/entries/en/" + Word
        // let urlString:String = "https://raw.githubusercontent.com/User-Howard/Howard-OJ/master/T.json"

        print(urlString)
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
        print("S", result)
    }
}
struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(Word: "hello")
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
                Divider()
                    .padding(.horizontal)
                VStack {
                    VStack {
                        HStack {
                            Text("A greeting (salutation) said when meeting someone or acknowledging someone’s arrival or presence.")
                            // .font(.system(size: 16, design: .monospaced))
                                .padding([.horizontal])
                            Spacer()
                        }
                        Text("")
                        HStack {
                            Text("Hello, everyone.")
                                .font(.system(size: 16, design: .default))
                                .italic()
                                .padding([.horizontal])
                            Spacer()
                        }
                    }.padding(5)
                    Divider()
                    VStack {
                        HStack {
                            Text("A greeting used when answering the telephone.")
                            // .font(.system(size: 16, design: .monospaced))
                                .padding([.horizontal])
                            Spacer()
                        }
                        Text("")
                        HStack {
                            Text("Hello? How may I help you?")
                                .font(.system(size: 16, design: .default))
                                .italic()
                                .padding([.horizontal])
                            Spacer()
                        }
                    }.padding(5)
                    Divider()
                    VStack {
                        HStack {
                            Text("A call for response if it is not clear if anyone is present or listening, or if a telephone conversation may have been disconnected.")
                            // .font(.system(size: 16, design: .monospaced))
                                .padding([.horizontal])
                            Spacer()
                        }
                        Text("")
                        HStack {
                            Text("Hello? Is anyone there?")
                                .font(.system(size: 16, design: .default))
                                .italic()
                                .padding([.horizontal])
                            Spacer()
                        }
                    }.padding(5)
                }
            }
        }.cornerRadius(8)
    }
}

struct DetailsFINALView: View {
    
    var Title_: String
    
    
    var body: some View {
        ZStack {
            Color("ResultView.BackgroundColor")
            VStack {
                HStack {
                    Label(Title_, systemImage: "sun.min.fill")
                        .font(.system(size: 17, weight: .bold))
                    Spacer()
                }
                .padding([.top, .horizontal])
                Divider()
                    .padding(.horizontal)
                VStack {
                    VStack {
                        HStack {
                            Text("A greeting (salutation) said when meeting someone or acknowledging someone’s arrival or presence.")
                                // .font(.system(size: 16, design: .monospaced))
                                .padding([.horizontal])
                            Spacer()
                        }
                        Text("")
                        HStack {
                            Text("Hello, everyone.")
                                .font(.system(size: 16, design: .default))
                                .italic()
                                .padding([.horizontal])
                            Spacer()
                        }
                    }.padding(5)
                    Divider()
                    VStack {
                        HStack {
                            Text("A greeting used when answering the telephone.")
                                // .font(.system(size: 16, design: .monospaced))
                                .padding([.horizontal])
                            Spacer()
                        }
                        Text("")
                        HStack {
                            Text("Hello? How may I help you?")
                                .font(.system(size: 16, design: .default))
                                .italic()
                                .padding([.horizontal])
                            Spacer()
                        }
                    }.padding(5)
                    Divider()
                    VStack {
                        HStack {
                            Text("A call for response if it is not clear if anyone is present or listening, or if a telephone conversation may have been disconnected.")
                                // .font(.system(size: 16, design: .monospaced))
                                .padding([.horizontal])
                            Spacer()
                        }
                        Text("")
                        HStack {
                            Text("Hello? Is anyone there?")
                                .font(.system(size: 16, design: .default))
                                .italic()
                                .padding([.horizontal])
                            Spacer()
                        }
                    }.padding(5)
                }
            }
        }.cornerRadius(8)
    }
}
