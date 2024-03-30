//
//  ContentView.swift
//  Project_5_Triva
//
//  Created by Muskan Mankikar on 3/29/24.
//

import SwiftUI

struct ContentView: View {
    @State private var cards: [Card] = []
    @State private var numQuestions: String = ""
    @State private var sliderValue: Double = 50
    @State private var category: Int = 1
    @State private var type: Int = 1
    
    init() {
            // Customize navigation bar appearance
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(red: 0.4627, green: 0.8392, blue: 1.0, alpha: 1.0)// Set navigation bar background color here
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
    
    var body: some View {
        NavigationStack {
            VStack {
//                Color(white: 0.9, opacity: 0.7)
                Form {
                    Section(header: Text("Game Choices")) {
                        TextField("Number of Questions", text: $numQuestions)
                        HStack{
                            Picker(selection: $category, label: Text("Category")) {
                                Text("General Knowledge").tag(9)
                                Text("Entertainment: Books").tag(10)
                                Text("Entertainment: Film").tag(11)
                                Text("Entertainment: Music").tag(12)
                                Text("Entertainment: Musicals & Theatres").tag(13)
                                Text("Entertainment: Television").tag(14)
                                Text("Entertainment: Video Games").tag(15)
                                Text("Entertainment: Board Games").tag(16)
                                Text("Science and Nature").tag(17)
                                Text("Science: Computers").tag(18)
                                Text("Science: Mathematics").tag(19)
                                Text("Mythology").tag(20)
                                Text("Sports").tag(21)
                                Text("Geography").tag(22)
                                Text("History").tag(23)
                                Text("Politics").tag(24)
                                Text("Art").tag(25)
                                Text("Celebrities").tag(26)
                                Text("Animals").tag(27)
                                Text("Vehicles").tag(28)
                                Text("Entertainment: Comics").tag(29)
                                Text("Science: Gadgeets").tag(30)
                            }
                        }
                        HStack{
                            if (sliderValue < 33.33) {
                                Text("Difficulty: Easy")
                            }
                            if (sliderValue < 66.66 && sliderValue > 33.33) {
                                Text("Difficulty: Medium")
                            }
                            if (sliderValue > 66.66) {
                                Text("Difficulty: Hard")
                            }
                            
                            Spacer()
                            Slider(value:  $sliderValue, in: 0...100, step: 1)
                                .frame(width: 150)
                        }
                        HStack{
                            Picker(selection: $type, label: Text("Question Type")) {
                                Text("True and False").tag(1)
                                Text("Multiple Choice").tag(2)
                            }
                        }
                    }
                    
                    Section {
                        
                        NavigationLink(destination: TriviaQuestionsView(numQuestions: numQuestions, sliderValue: sliderValue, category: category, type: type == 1 ? "boolean" : "multiple")) {
                            Text("Start Game")
                                                }
                    }
                }

                
            }
            .navigationTitle("Trivia!")
            

        }
    }
    
    private func fetchQuestions() async {
        // URL for the API endpoint
        // 👋👋👋 Make sure to replace {YOUR_API_KEY} in the URL with your actual NPS API Key
        var baseUrl = "https://opentdb.com/api.php?amount=\(numQuestions)"
        if (sliderValue < 33.33) {
            baseUrl = "\(baseUrl)&difficulty=easy"
        }
        if (sliderValue < 66.66 && sliderValue > 33.33) {
            baseUrl = "\(baseUrl)&difficulty=medium"
        }
        if (sliderValue > 66.66) {
            baseUrl = "\(baseUrl)&difficulty=hard"
        }
        
        let url = URL(string: baseUrl)!
        do {
            
            // Perform an asynchronous data request
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // Decode json data into ParksResponse type
            let cardResponse = try JSONDecoder().decode(CardResponse.self, from: data)
            
            // Get the array of parks from the response
            let cards = cardResponse.results
            
            // Print the full name of each park in the array
            
            
            // Set the parks state property
            self.cards = cards
            
        } catch {
            print(error.localizedDescription)
        }
    }
}

#Preview {
    ContentView()
}
