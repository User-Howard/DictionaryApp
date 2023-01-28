//
//  CollectionView.swift
//  CambridgeDictionary
//
//  Created by 吳浩瑋 on 2022/7/17.
//

import SwiftUI



class DataSource: ObservableObject {
    @Published var words: [String]
    init() {
        // self.words = ["Apple", "Banana", "Word", "Last", "Anticipate"]
        self.words = ["Apple", "Barrier", "Fare", "Court", "Reception", "Flat", "Pharmacy", "Placement", "Participate", "Ocean", "Evanescent", "Observation", "Recondite", "Attention"]
    }
    
}

struct CollectionView: View {
    
    @State private var showDefinition: Bool = false
    @StateObject var collections = DataSource()
    @State var showingWord: String = ""
    @State var dragAmount = CGSize.zero
    var body: some View {
        List(collections.words, id: \.self) { word in
            Button(action: {
                showingWord = word
                print(showingWord)
                showDefinition = true
                
            }, label: {
                Text(word)
                    .foregroundColor(.primary)
            })
            .sheet(isPresented: $showDefinition) {
                SearchingView(Word: showingWord, StaticMode: true)
                    .padding(.top)
            }
        }
    }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView()
            .previewDevice("iPhone 14 pro")
        
    }
}
