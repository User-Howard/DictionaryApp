//
//  CollectionView.swift
//  CambridgeDictionary
//
//  Created by 吳浩瑋 on 2022/7/17.
//

import SwiftUI



class DataSource: ObservableObject {
    
    @Published var words: [String]
    @Published var database: [String: Dat]
    init() {
        // self.words = ["Apple", "Banana", "Word", "Last", "Anticipate"]
        self.words = ["Apple", "Barrier", "Fare", "Court", "Reception", "Flat", "Pharmacy", "Placement", "Participate", "Ocean", "Evanescent", "Observation", "Recondite", "Attention"]
        self.database = ["---": Dat()]
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
struct AlertView: View {
    @Binding var showAlert: Bool
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "bookmark.fill")
                .font(.title)
            Text("已新增新單字至「收藏」")
                .fontWeight(.bold)
        }
        .padding()
        .background(.thinMaterial)
        .cornerRadius(8)
        .scaleEffect(showAlert ? 1 : 0.8)
        .opacity(showAlert ? 1 : 0)
        .animation(.spring().speed(2), value: showAlert)
        
    }
}
struct CollectionView: View {
    
    @State private var showDefinition: Bool = false
    @EnvironmentObject var collections : DataSource
    @State private var showingWord: String = ""
    @State var dragAmount = CGSize.zero
    @State private var onEdit: Bool = false
    
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(collections.words, id: \.self) { word in
                    Button(action: {
                        showingWord = word
                        showDefinition = true
                        print(showingWord)
                        
                    }, label: {
                        Text(word)
                            .foregroundColor(.primary)
                    })
                    
                }
                .onDelete { item in
                    print(item)
                    collections.words.remove(atOffsets: item)
                }
            }
            .sheet(isPresented: $showDefinition) {
                SearchingView(Word: $showingWord, StaticMode: true)
                    .padding(.top)
            }
            .navigationTitle("單字庫")
            .navigationBarItems(trailing: EditButton())
            .navigationBarTitleDisplayMode(.inline)
                
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
