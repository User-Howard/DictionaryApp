//
//  DictionaryView.swift
//  CambridgeDictionary
//
//  Created by 吳浩瑋 on 2022/7/17.
//

import SwiftUI
/*
class Api: ObservableObject {
    
    func fetch() {
        guard let url = URL(string: "https://api.dictionaryapi.dev/api/v2/entries/en/hello") else { return }
        URLSession.shared.dataTask(with: url) { {data, , } in
            let meanings = try! JSONDecoder.decode()
        }
            
    }
}*/
struct DictionaryView: View {
    
    var body: some View {
        VStack {
            Spacer(minLength: 40)
            ZStack {
                // Color.accentColor
            }
            Spacer(minLength: 1)
        }.edgesIgnoringSafeArea([.top])

    }
}

struct DictionaryView_Previews: PreviewProvider {
    static var previews: some View {
        DictionaryView()
            .previewDevice("iPhone 11")
    }
}
