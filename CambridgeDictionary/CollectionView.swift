//
//  CollectionView.swift
//  CambridgeDictionary
//
//  Created by 吳浩瑋 on 2022/7/17.
//

import SwiftUI



struct CollectionView: View {
    
    @State private var showDefinition: Bool = false
    @State var collections: [String] = ["Apple", "Word", "Last"]
    @State var showingWord: String = ""
    @State var dragAmount = CGSize.zero
    var body: some View {
        List(collections, id: \.self) { collection in
            Button(action: {
                showingWord = collection
                print(showingWord)
                showDefinition = true
                
            }, label: {
                Text(collection)
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
