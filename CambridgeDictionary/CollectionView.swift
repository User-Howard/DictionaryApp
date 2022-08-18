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
            Spacer(minLength: 40)
            ZStack {
                // Color.accentColor
                NavigationLink {
                    ResultView(Word: "apple")
                }label: {
                    VStack {
                        Text("2")
                            .font(.title)
                    }
                }
            }
            Spacer(minLength: 1)
        }.edgesIgnoringSafeArea([.top])

    }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView()
            .previewDevice("iPhone 11")
            
    }
}
