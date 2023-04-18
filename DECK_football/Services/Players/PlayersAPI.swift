//
//  PlayersAPI.swift
//  DECK_football
//
//  Created by Максим Нурутдинов on 18.04.2023.
//

import Foundation
import Moya

enum PlayersAPI {
    case getPlayers
    case deletePlayer(id: String)
}

extension PlayersAPI: TargetType {
    var baseURL: URL {
        return URL(string: "apple.com")!
    }
        
    var path: String {
        switch self {
        case .getPlayers:
            return "/players"
        case let .deletePlayer(id):
            return "/players/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPlayers:
            return .get
        case .deletePlayer:
            return .delete
            
        }
    }
    
    var task: Moya.Task { .requestPlain }
    
    var headers: [String: String]? { ["Content-type": "application/json"] }
    
    var sampleData: Data {
        switch self {
        case .getPlayers:
            return (try? JSONEncoder().encode(MockData.playersModel)) ?? Data()
        case let .deletePlayer(id):
            return (try? JSONEncoder().encode(MockData.playersModel.players.first { $0.id == id })) ?? Data()
        }
        
    }
}

final class MockData {
    static let playersModel = PlayersModel(
        players: [
            .init(id: "1", name: "Vasya", surname: "Petrov"),
            .init(id: "2", name: "Petya", surname: "Ivanov"),
            .init(id: "3", name: "Mik", surname: "Petrov"),
            .init(id: "4", name: "Dima", surname: "Petrov"),
            .init(id: "5", name: "Gena", surname: "Kler"),
            .init(id: "6", name: "Kolya", surname: "Floe"),
            .init(id: "7", name: "Igor", surname: "Petrov"),
            .init(id: "8", name: "Misha", surname: "Petrov"),
            .init(id: "9", name: "Gena", surname: "Petrov"),
            .init(id: "10", name: "Lad", surname: "Petrov"),
            .init(id: "11", name: "Gleb", surname: "Petrov"),
        ]
    )
}

