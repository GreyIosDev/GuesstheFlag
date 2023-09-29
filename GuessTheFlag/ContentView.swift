//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Grey  on 25.05.2023.
//

import SwiftUI

struct FlagImage: View { // What we did here was replace the Image view used for flags with a new FlagImage() view that renders one flag image using the specific set of modifiers we had
    var imageName: String
    @State private var isSpinning = false // Track the spinning state
    @State private var isScaling = false // Track the scaling state
    var isCorrectAnswer: Bool // Binding to determine if this is the correct answer
    
    var body: some View {
        Image(imageName)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
            .rotation3DEffect(.degrees(isSpinning ? 360 : 0), axis: (x: 0, y: 1, z: 0)) // Apply rotation effect
            .scaleEffect(isScaling ? 0.5 : 1.0) // Apply scaling effect
            .opacity(isCorrectAnswer ? 1.0 : 0.25) // Adjust opacity based on the correct answer
        
        
            .onTapGesture {
                withAnimation {
                    isSpinning.toggle() // Toggle the spinning state when tapped
                    if !isCorrectAnswer {
                        isScaling.toggle() // Toggle the scaling state for incorrect flags
                    }
                }
            }
    }
}


struct ContentView: View {
    @State private var showingScore = false// This is what we used to link the alert to make it show
    @State private var scoreTitle = ""
    
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled() // note that this is what we do to make sure that once the game starts it is shuffled or randomise.
    
    @State private var correctAnswer = Int.random(in: 0...2)
    
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack (spacing:30){
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack(spacing:15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundColor(.white)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .foregroundColor(.white)
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                            
                        } label: {
                            FlagImage(imageName: countries[number], isCorrectAnswer: number == correctAnswer)
                        }
                    }
                }
                Spacer()
                Spacer()
            }
            .padding()
        }
        .alert( scoreTitle, isPresented: $showingScore){
            Button("Continue", action: askQuestion)// This is how the buttons are set. note that there are other ways but this is the how this was done
        } message: {
            Text("Your score is 10")
        }
    }
    func flagTapped(_ number: Int){
        if number == correctAnswer{
            scoreTitle = "Correct"
        } else {
            scoreTitle = "Wrong"
        }
        showingScore = true
    }
    func askQuestion(){
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
