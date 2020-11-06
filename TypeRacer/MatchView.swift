//
//  MatchView.swift
//  TypeRacer
//
//  Created by Luca Gasparetto on 08/06/2020.
//  Copyright © 2020 Luca Gasparetto. All rights reserved.
//

import SwiftUI

extension AnyTransition {
    static var bottomToTop: AnyTransition {
        let insertion = AnyTransition.move(edge: .bottom)
        let removal = AnyTransition.move(edge: .top)
        return .asymmetric(insertion: insertion, removal: removal)
    }
}

struct MatchView: View {
    @State private var timeRemaining = 20

    @State private var text = ""
    @State private var timerFired = false
    @State private var isSmiling = false
    @State private var currentBackground = Color.white
    @State private var currentWord = 0
    
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var strobe = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    static let words = ["My", "awesome", "job", "let", "me", "do", "this", "unbelievable", "stuff"]
    let colors: [Color] = [.black, .orange, .blue, .green, .purple, .pink, .white]
    
    var body: some View {
        VStack() {
            Spacer().frame(height: 20)
            Text("Timer")
            Text("\(timeRemaining)")
                .font(.system(size: 25))
                .onReceive(timer) { input in
                    if self.timeRemaining > 0 {
                        self.timeRemaining -= 1
                    }else{
                        self.timer.upstream.connect().cancel()
                        self.timerFired = true
                    }
                }
            
            Spacer().frame(height: 30)
            
            if !timerFired {
                if self.timeRemaining < 10 {
                    Text("Mooore difficult, sono simpy").padding()
                }else if self.timeRemaining < 15 {
                    Text("Leggi sempre qui sotto, ma aguzza la vista...").padding()
                }else{
                    Text("Scrivi la parola sotto e premi invio...").padding()
                }
            }else{
                Text("Looser :(").padding()
            }
            
            if !timerFired { // TODO: check current word > words.count
                Text("--> \(MatchView.words[currentWord]) <--")
                    .font(self.timeRemaining < 15 ? .system(size: 7) : .system(size: 25))
                    .padding()
                TextField("Let's go...", text: $text,
                          onEditingChanged: { (changed) in
                            print("focus")
                }) {
                    if self.text.lowercased() == MatchView.words[self.currentWord].lowercased() {
                        self.text = ""
                        self.currentWord += 1
                    }
                }.padding()
            }else{
                ZStack() {
                    Image("boss-face")
                    .resizable()
                    .frame(width: 300, height: 300, alignment: .center)
                    VStack() {
                        Spacer()
                        HStack() {
                            Spacer()
                            Image("morale")
                                .resizable()
                                .frame(width: 100, height: 100, alignment: .trailing)
                                .animation(.easeIn)
                                .transition(.bottomToTop)
                                .padding()
                        }
                    }
                }.animation(.easeIn)
                .transition(.bottomToTop)
            }
            Spacer()
        }.navigationBarTitle("Match")
        .background(currentBackground)
        .onReceive(strobe, perform: { (input) in
            if !self.timerFired {
                if self.timeRemaining < 10 {
                    self.currentBackground = self.colors.randomElement() ?? .white
                }
            }else{
                self.currentBackground = .red
            }
        }).onAppear(perform: config)
        .onDisappear(perform: unconfig)
    }
    
    func config(){
        self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        self.strobe = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    }
    
    func unconfig(){
        self.timer.upstream.connect().cancel()
        self.strobe.upstream.connect().cancel()
    }
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ss"
        
        return dateFormatter.string(from: date)
    }
}

struct MatchView_Previews: PreviewProvider {
    static var previews: some View {
        MatchView()
    }
}
