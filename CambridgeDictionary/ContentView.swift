//
//  ContentView.swift
//  CambridgeDictionary
//
//  Created by 吳浩瑋 on 2022/7/17.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selection = 0
    @StateObject var collections = DataSource()
    
    var body: some View{
        VStack {
            TabView(selection: $selection) {
                SearchingView(Word: "Apple")
                    .tabItem{
                        Image(systemName: "magnifyingglass")
                        Text("搜尋")
                    }
                    .tag(0)
                CollectionView()
                    .tabItem{
                        Image(systemName: "bookmark")
                        Text("收藏")
                    }
                    .tag(1)
                TextGenerator()
                    .tabItem{
                        Image(systemName: "cube")
                        Text("智能")
                    }
                    .tag(2)
            }
            .onAppear {
                let appearance = UITabBarAppearance()
                appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
                appearance.backgroundColor = UIColor(Color.white.opacity(0.1))
                
                // Use this appearance when scrolling behind the TabView:
                UITabBar.appearance().standardAppearance = appearance
                // Use this appearance when scrolled all the way up:
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        }.environmentObject(collections)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 14 pro")
    }
}
