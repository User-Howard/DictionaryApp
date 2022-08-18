//
//  DictionaryView.swift
//  CambridgeDictionary
//
//  Created by 吳浩瑋 on 2022/7/17.
//

import SwiftUI
import AVFoundation


struct DictionaryView: View {
    
    var body: some View {
        VStack {
            Spacer(minLength: 40)
        }.edgesIgnoringSafeArea([.top])

    }
}

struct DictionaryView_Previews: PreviewProvider {
    static var previews: some View {
        DictionaryView()
            .previewDevice("iPhone 11")
    }
}
