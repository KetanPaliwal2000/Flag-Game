//
//  ContentView.swift
//  Flag Game
//
//  Created by Ketan Paliwal on 2025-02-15.
//

import SwiftUI

struct ContentView: View {
    
    @State var numQuestions: Int = 5
    @State private var goToGame: Bool = false
    
    @State private var highscore:[Int] = Array(repeating: 0, count: 10)
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.opacity(0.1)
                VStack {
                    Spacer()
                    Text("Flag Guessing Game")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                    Button(action: {
                        goToGame = true
                    }){
                        Text("Start Game")
                            .font(.title3)
                            .padding(10)
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle(radius: 20))
                    HStack{
                        Text("Number of Questions: ")
                        Picker("Number of Questions", selection: $numQuestions){
                            ForEach(5..<16, id: \.self){
                                Text("\($0)")
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.gray)
                    }
                    .padding(10)
                    Text("🏆Highscore: \(highscore[numQuestions-5]) ")
                    NavigationLink(destination: GameView(numQuestions: numQuestions, highscore: $highscore), isActive: $goToGame) {
                        EmptyView()
                    }
                    Spacer()
                    Spacer()
                }
                .navigationTitle(Text("Home"))
                .navigationBarTitleDisplayMode(.inline)
            }
            .ignoresSafeArea()
        }
        .navigationBarBackButtonHidden(true)
        .onAppear() {
            loadHighscore()
        }
        .onChange(of: highscore) {
            saveHighscore()
        }
    }
    
    func loadHighscore() {
        if let retrievedArray = UserDefaults.standard.array(forKey: "highscore") as? [Int] {
            self.highscore = retrievedArray
        } else {
            self.highscore = Array(repeating: 0, count: 10)
        }
    }

    func saveHighscore() {
        UserDefaults.standard.set(self.highscore, forKey: "highscore")
    }
    
}

#Preview {
    ContentView()
}
