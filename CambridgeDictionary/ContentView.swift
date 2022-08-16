//
//  ContentView.swift
//  CambridgeDictionary
//
//  Created by 吳浩瑋 on 2022/7/17.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selection = 1
    
    
    var body: some View {
        
        NavigationView {
            TabView(selection: $selection) {
                DictionaryView()
                    .tabItem{
                        Image(systemName: "doc.richtext.fill")
                    }
                    .tag(0)
                CollectionView()
                    .tabItem{
                        Image(systemName: "bookmark.fill")
                    }
                    .tag(1)
            }
        }.navigationBarTitleDisplayMode(.inline)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 11")
    }
}
