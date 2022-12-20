//
//  ContentView.swift
//  CambridgeDictionary
//
//  Created by 吳浩瑋 on 2022/7/17.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selection = 0
    
    var body: some View{
        /*ZStack {*/
        VStack {
            TabView(selection: $selection) {
                SearchingView()
                    .tag(0)
                CollectionView()
                    .tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        
        /*
         VStack {
         Picker("Nav", selection: $selection) {
         Text("查詢").tag(0)
         Text("收藏").tag(1)
         }.pickerStyle(.segmented)
         Spacer()
         }.padding(.horizontal)
         
         }*/
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 14 pro")
    }
}
