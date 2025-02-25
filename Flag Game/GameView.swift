//
//  GameView.swift
//  Flag Game
//
//  Created by Ketan Paliwal on 2025-02-16.
//

import SwiftUI

struct GameView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var numQuestions: Int
    @State var numQuestionsPersist: Int = -1
    
    let countries: [String] = ["China", "India", "Europe", "Arab League", "USA", "Indonesia", "Brazil", "Pakistan", "Nigeria", "Bangladesh", "Russia", "Japan", "Mexico", "Ethiopia", "Philippines", "Egypt", "Vietnam", "Congo", "Iran", "Turkey", "Germany", "Thailand", "United Kingdom", "France", "Italy", "Myanmar", "England", "South Africa", "Tanzania", "South Korea", "Spain", "Colombia", "Kenya", "Argentina", "Ukraine", "Algeria", "Uganda", "Iraq", "Poland", "Sudan", "Canada", "Afghanistan", "Morocco", "Malaysia", "Venezuela", "Peru", "Uzbekistan", "Nepal"]
//    I have not added all the countries here. For reference check out https://www.countryflags.com/. I have added the countries in order from this website.
    
    @State private var country: Int = 0
    @State private var options: [Int] = [0,1,2,3]
    
    @State private var showAlert: Bool = false
    @State private var showAlert2: Bool = false
    @State private var alertMessage: String = ""
    
    @State private var score: Int = 0
    @State private var gameover: Bool = false
    
    @Binding var highscore: [Int]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.opacity(0.1)
                VStack {
                    if(numQuestions>1){
                        Text("\(numQuestions) questions left")
                    }
                    else if(numQuestions==1){
                        Text("\(numQuestions) question left")
                    }
                    else{
                        Text("")
                    }
                    Text("Choose the flag of \(countries[country])")
                        .font(.title2)
                        .fontWeight(.bold)
                    VStack{
                        ForEach(options, id: \.self){op in
                            Button(action: {
                                checkAnswer(key: op)
                            }) {
                                Image("\(countries[op])".lowercased())
                                    .resizable()
                                    .frame(width: 150.0, height: 100.0, alignment: .center)
                                    .padding(10)
                            }
                        }
                    }
                    //                Text("Score: \(score)")
                }
                .alert(alertMessage, isPresented: $showAlert){
                    Button("Continue", action: setQuestion)
                } message: {
                    
                }
                .alert("Game Over", isPresented: $showAlert2) {
                    Button("Home", action: finishGame)
                } message: {
                    Text("Your Score is \(score) points")
                }
                .navigationTitle(Text("Score: \(score)"))
                .navigationBarTitleDisplayMode(.inline)
                
                NavigationLink(destination: ContentView(numQuestions: numQuestionsPersist), isActive: $gameover) {
                    EmptyView()
                }
            }
            .ignoresSafeArea()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .buttonStyle(BorderedProminentButtonStyle())
                    .tint(.black)
                    .shadow(radius: 5)
                }
            }
        }
        .onAppear {
            numQuestionsPersist = numQuestions
            setQuestion()
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func setQuestion() {
        if gameOver() {
            country = Int.random(in: 0..<countries.count)
            let indices = countries.indices.filter { $0 != country }
            var randomIndices: [Int] = Array(indices.shuffled().prefix(3))
            randomIndices.append(country)
            randomIndices.shuffle()
            options = randomIndices
        }
    }
    func checkAnswer(key: Int) {
        if key == country {
            showAlert = true
            alertMessage = "Correct"
            score+=50
        } else {
            showAlert = true
            alertMessage = "Wrong"
        }
        numQuestions-=1
    }
    func gameOver()->Bool {
        if(numQuestions<=0){
            showAlert2 = true
            return false
        }
        else{
            return true
        }
    }
    func finishGame() {
        if(score>highscore[numQuestionsPersist-5]){
            highscore[numQuestionsPersist-5] = score
        }
        gameover = true
    }
}

#Preview {
    GameView(numQuestions: 5, highscore: Binding.constant(Array(repeating: 0, count: 10)))
}
