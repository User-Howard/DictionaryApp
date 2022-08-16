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
    
    
    var body: some View {
        VStack {
            Spacer(minLength: 80)
            ZStack {
                // Color.green
                VStack {
                    IntroduuctionView()
                        .padding([.top, .horizontal])
                    
                    ZStack{
                        // Color.blue
                        ScrollView {
                            VStack(alignment: .leading) {
                                DetailsView(Title_: "Verb")
                                DetailsView2(Title_: "Verb")
                                
                                DetailsView2(Title_: "Noun")
                            }
                        }
                    }
                    .cornerRadius(8)
                    .padding(.horizontal)
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
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView()
            .previewDevice("iPhone 11")
    }
}

struct IntroduuctionView: View {
    
    @ObservedObject private var volObserver = VolumeObserver()
    
    
    var body: some View {
        GroupBox(label:
            HStack {
            Label("apple", systemImage: "building.columns")
            Spacer()
            
            Button() {
                let utterance = AVSpeechUtterance(string: "apple")
                utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
                let synthesizer = AVSpeechSynthesizer()
                synthesizer.speak(utterance)
            }label: {
                Image(systemName: "speaker.wave.3.fill")
                    .foregroundColor(Color.secondary)
                /*
                if #available(iOS 16.0, *) {
                    Image(systemName: "speaker.wave.3.fill", variableValue: Double(volObserver.volume))
                        .foregroundColor(Color.secondary)
                } else {
                    Image(systemName: "speaker.wave.3.fill")
                        .foregroundColor(Color.secondary)
                }*/
            }
        }
        ) {
            VStack {
                Text("")
                Spacer()
            }
            .frame(minWidth: 0, idealWidth: 100, maxWidth: .infinity, minHeight: 0, idealHeight: 20, maxHeight: 20, alignment: .leading)
            
        }
    }
}

struct DetailsView: View {
    
    var Title_: String
    
    
    var body: some View {
        GroupBox(label:
            Label(Title_, systemImage: "sun.min.fill")
        ) {
            VStack {
                Color.pink
                    .frame(height: 1)
                Divider()
                VStack {
                    Text("A common, round fruit produced by the tree Malus domestica, cultivated in temperate climates.")
                }

            }.padding(1)
            
        }
    }
}

struct DetailsView2: View {
    
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
                    ZStack {
                        Text("Any of various tree-borne fruits or vegetables especially considered as resembling an apple; also (with qualifying words) used to form the names of other specific fruits such as custard apple, rose apple, thorn apple etc.")
                            .padding([.horizontal], 10)
                    }
                    .padding(5)
                    Divider()
                        .padding(.horizontal)
                    ZStack {
                        Text("Any of various tree-borne fruits or vegetables especially considered as resembling an apple; also (with qualifying words) used to form the names of other specific fruits such as custard apple, rose apple, thorn apple etc.")
                            .padding([.horizontal], 10)
                    }
                    .padding(5)
                }
            }
        }.cornerRadius(8)
    }
}
