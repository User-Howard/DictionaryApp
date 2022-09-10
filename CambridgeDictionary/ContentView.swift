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
        ZStack {
            SearchingView()
                .offset(x: selection==0 ? 0 : -UIScreen.main.bounds.width)
                .animation(.default.speed(1.2), value: selection)
            CollectionView()
                .offset(x: selection==0 ? UIScreen.main.bounds.width : 0)
                .animation(.default.speed(1.2), value: selection)
            VStack {
                Picker("Nav", selection: $selection) {
                    Text("查詢").tag(0)
                    Text("收藏").tag(1)
                }.pickerStyle(.segmented)
                Spacer()
            }.padding(.horizontal)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 11")
    }
}
