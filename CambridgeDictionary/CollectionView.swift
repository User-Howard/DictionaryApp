//
//  CollectionView.swift
//  CambridgeDictionary
//
//  Created by 吳浩瑋 on 2022/7/17.
//

import SwiftUI


struct CollectionView: View {
    
    @State private var showDefinition: Bool = false
    /*
    @Environment(\.managedObjectContext) var context
    @FetchRequest(entity: Collections.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Collections.collections, ascending: false)])
    var products: FetchedResults<Product>
    */
    
    var body: some View {
        VStack {
            List {
                Text("A")
                Text("B")
            }.cornerRadius(8)
            if #available(iOS 16.0, *) {
                Button("Show") {
                    showDefinition.toggle()
                }
                .buttonStyle(.bordered)
                .sheet(isPresented: $showDefinition) {
                    SearchingView(Word: "Apple")
                        .padding(.top)
                        .presentationDetents([.fraction(0.4), .large])
                }
                
            } else {
                Button("Show") {
                    showDefinition.toggle()
                }
                .buttonStyle(.bordered)
                .sheet(isPresented: $showDefinition) {
                    SearchingView(Word: "Apple", StaticMode: true)
                        .padding(.top)
                }
            }
        }.edgesIgnoringSafeArea([.top])
        
    }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView()
            
    }
}
