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
    func addWord(word: String) {
        print("add to list")
        self.words.append(word)
    }
    func removeWord(word: String) {
        print("remove from list")
        print(self.words.firstIndex(of: word)!)
        self.words.remove(at: self.words.firstIndex(of: word)!)
    }
}

struct CollectionView: View {
    
    @State private var showDefinition: Bool = false
    @EnvironmentObject var collections : DataSource
    @State var showingWord: String = ""
    @State var dragAmount = CGSize.zero
    @State private var onEdit: Bool = false
    var body: some View {
        NavigationStack {
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
            .navigationTitle("單字庫")
            .toolbar {
                if onEdit {
                    
                    Button("Cancel", action: {
                        onEdit = false
                    })
                }
                else {
                    Button("Edit", action: {
                        onEdit = true
                    })
                }
                
            }
        }
    }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
//        CollectionView()
//            .previewDevice("iPhone 14 pro")
        ContentView()
            .previewDevice("iPhone 14 pro")
        
    }
}
