//
//  ContentView.swift
//  TypeRacer
//
//  Created by Luca Gasparetto on 01/06/2020.
//  Copyright © 2020 Luca Gasparetto. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack() {
                Image("type-writer")
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color.blue,
                                        lineWidth: 5)
                    )
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                
                Spacer().frame(height: 30)
                
                NavigationLink(destination: MatchView()) {
                    Text("START")
                        .fontWeight(.bold)
                        .font(.title)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(40)
                        .foregroundColor(.white)
                        .padding(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 40)
                                .stroke(Color.blue, lineWidth: 5)
                    )
                }
            }.navigationBarTitle(Text("TypeRacer"), displayMode: .inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


