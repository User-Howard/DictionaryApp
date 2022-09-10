//
//  CollectionView.swift
//  CambridgeDictionary
//
//  Created by 吳浩瑋 on 2022/7/17.
//

import SwiftUI


struct CollectionView: View {
    
    var body: some View {
        VStack {
            Spacer(minLength: 80)
            List {
                Text("A")
                Text("B")
            }.cornerRadius(8)
        }.edgesIgnoringSafeArea([.top])

    }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView()
            .previewDevice("iPhone 11")
            
    }
}
