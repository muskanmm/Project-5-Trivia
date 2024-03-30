//
//  CardResponse.swift
//  Project_5_Triva
//
//  Created by Muskan Mankikar on 3/29/24.
//

import SwiftUI

struct CardResponse: Codable {
    let results: [Card]
}

struct Card: Codable, Hashable, Equatable {
    let difficulty: String
    let type: String
    let category: String
    let question: String
    let correct_answer: String
    let incorrect_answers: [String]
    
    var allAnswers: [String] {
        return [correct_answer] + incorrect_answers
    }
}


extension Card {
    static var mocked: Card {
        let jsonUrl = Bundle.main.url(forResource: "card_mock", withExtension: "json")!
        let data = try! Data(contentsOf: jsonUrl)
        let card = try! JSONDecoder().decode(Card.self, from: data)
        return card
    }
}
