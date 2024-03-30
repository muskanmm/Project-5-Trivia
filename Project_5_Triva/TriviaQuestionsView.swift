//
//  TriviaQuestionsView.swift
//  Project_5_Triva
//
//  Created by Muskan Mankikar on 3/29/24.
//

import SwiftUI


struct TriviaQuestionsView: View {
    @State private var cards: [Card] = []
    @State private var selectedAnswers: [String?] = []
    @State private var isSubmitDisabled = true
    @State private var isSubmitted = false
    @State private var score = 0
    
    let numQuestions: String
    let sliderValue: Double
    let category: Int
    let type: String
    
    
    init(numQuestions: String, sliderValue: Double, category: Int, type: String) {
            self.numQuestions = numQuestions
            self.sliderValue = sliderValue
            self.category = category
            self.type = type
    }
    
    var body: some View {
        VStack {
            ScrollView{
                LazyVStack {
                    ForEach(Array(zip(cards.indices, cards)), id: \.0) { index, card in
                        CardRow(card: card, selectedAnswer: $selectedAnswers[index], isSubmitted: $isSubmitted)
                            .onChange(of: selectedAnswers[index]) { _ in
                                        updateSubmitButtonState()
                                    }
                    }
                    .padding()
                }
                
                Button(action: {
                    submitAnswers()
                    isSubmitted = true
                }) {
                    Text("Submit")
                        .foregroundColor(.white)
                        .padding()
                        .background(isSubmitDisabled ? Color.gray : Color.blue)
                        .cornerRadius(8)
                }
                .disabled(isSubmitDisabled)
                .padding()
                
            }
            if (isSubmitted) {
                Text("Your score: \(score)/\(cards.count)")
                    .font(.title)
                    .padding()
            }
        }
        .onAppear(perform: {
            fetchQuestions()
            updateSubmitButtonState()
        })
    }
    
    private func fetchQuestions()  {
        
        var baseUrl = "https://opentdb.com/api.php?amount=\(numQuestions)"
        baseUrl = "\(baseUrl)&type=\(type)"
        if (sliderValue < 33.33) {
            baseUrl = "\(baseUrl)&difficulty=easy"
        }
        if (sliderValue < 66.66 && sliderValue > 33.33) {
            baseUrl = "\(baseUrl)&difficulty=medium"
        }
        if (sliderValue > 66.66) {
            baseUrl = "\(baseUrl)&difficulty=hard"
        }
        baseUrl = "\(baseUrl)&category=\(category)"
        print(type)
        print(baseUrl)
        
        guard let url = URL(string: baseUrl) else {
                    return
                }
                
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let data = data {
                do {
                    let cardResponse = try JSONDecoder().decode(CardResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.cards = cardResponse.results
                        self.selectedAnswers = Array(repeating: nil, count: cardResponse.results.count)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }.resume()
//        let url = URL(string: baseUrl)!
//        do {
//            
//            let (data, _) = try await URLSession.shared.data(from: url)
//            
//            let cardResponse = try JSONDecoder().decode(CardResponse.self, from: data)
//            
//            let cards = cardResponse.results
//            
//            self.cards = cards
//            
//        } catch {
//            print(error.localizedDescription)
//        }
    }
    
    private func updateSubmitButtonState() {
        isSubmitDisabled = selectedAnswers.contains(nil)
    }
    
    private func submitAnswers() {
        isSubmitted = true
        print("isSubmitted value: \(isSubmitted)")
        calculateScore()
    }
    
    private func calculateScore() {
        score = 0
        for (index, card) in cards.enumerated() {
            if let selectedAnswer = selectedAnswers[index], card.correct_answer == selectedAnswer {
                score += 1
            }
        }
    }
    
}

struct CardRow: View {
    let card: Card
    @Binding var selectedAnswer: String?
    @Binding var isSubmitted: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(card.question)
                .font(.headline)
                .padding(.bottom, 8)

            ForEach(card.allAnswers, id: \.self) { answer in
                Button(action: {
                    selectedAnswer = answer
//                    updateSubmitButtonState()
                }) {
                    Text(answer)
                        .foregroundColor(.white)
                        .padding()
                        .background(selectedAnswer == answer ? Color.blue : Color.gray)
                        .cornerRadius(8)
                }
                .disabled(isSubmitted || (selectedAnswer != nil && selectedAnswer != answer)) // Disable buttons after an answer is selected
            }
        }

        .padding()
        .background(Color.gray)
        .cornerRadius(8)
        .padding(.vertical, 4)
    }
    
}

#Preview {
    TriviaQuestionsView(numQuestions: "2", sliderValue: 20, category: 1, type: "boolean")
}
