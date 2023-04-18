//
//  PlayersService.swift
//  DECK_football
//
//  Created by Максим Нурутдинов on 18.04.2023.
//

import Foundation
import RxSwift
import Moya
import RxMoya

protocol PlayerServiceProtocol {
    func getPlayers() -> Single<PlayersModel>
    func deletePlayer(with id: String?) -> Single<PlayersModel.Player>
}

final class PlayersService: PlayerServiceProtocol {
    enum Error: Swift.Error, LocalizedError {
        case incorrectIdentifier

        var errorDescription: String? {
          switch self {
          case .incorrectIdentifier:
              return "ошибоный индентификатор"
          }
        }

    }
    
    private let provider = MoyaProvider<PlayersAPI>(stubClosure: MoyaProvider.delayedStub(0.5))
    
    func getPlayers() -> Single<PlayersModel> {
        provider.rx
            .request(.getPlayers)
            .filterSuccessfulStatusAndRedirectCodes()
            .map(PlayersModel.self)
    }
    
    func deletePlayer(with id: String?) -> Single<PlayersModel.Player> {
        guard let id else { return .error(Error.incorrectIdentifier)}
        return provider.rx
            .request(.deletePlayer(id: id))
            .filterSuccessfulStatusAndRedirectCodes()
            .map(PlayersModel.Player.self)
    }
    
}
