//
//  PlayersModel.swift
//  DECK_football
//
//  Created by Максим Нурутдинов on 18.04.2023.
//

import Foundation

struct PlayersModel: Codable {
    struct Player: Codable {
        let id: String
        let name: String
        let surname: String
        
        var fullName: String {
            "\(name) \(surname)"
        }
    }
    let players: [Player]
}

extension PlayersModel.Player {
    static let empty = Self(id: "", name: "", surname: "")
}

