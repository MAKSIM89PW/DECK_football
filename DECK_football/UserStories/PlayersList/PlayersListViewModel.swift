//
//  PlayersListViewModel.swift
//  DECK_football
//
//  Created by Максим Нурутдинов on 18.04.2023.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

struct PlayerViewModel {
    let id: String
    let name: String
    
    static let empty = Self(id: "", name: "")
}

final class PlayersListViewModel {
    
    struct Input {
        let updated: Driver<Void>
        let deleted: Driver<String?>
     }
     
    struct Output {
        let players: Driver<[PlayerViewModel]>
        let removedPlayer: Driver<PlayerViewModel>
        let loading: Driver<Bool>
        let errorMessage: Driver<String>

    }
    
    private let service: PlayerServiceProtocol
    private let disposeBag = DisposeBag()

    init(service: PlayerServiceProtocol){
        self.service = service
    }
    
    func transform(input: Input) -> Output {
        let loading = ActivityIndicator()
        let errorRouter = ErrorRouter()
        
        let players = input.updated
            .throttle(.milliseconds(500))
            .flatMap { [weak self] _ in
                self?.service
                    .getPlayers()
                    .trackActivity(loading)
                    .rerouteError(errorRouter)
                    .asDriver(onErrorJustReturn: .init(players: []))
                    .map { $0.players.map { PlayerViewModel(id: $0.id, name: $0.fullName)}} ?? .just([])
                
            }
        
        let removedPlayer = input.deleted
            .throttle(.milliseconds(500))
            .flatMap { [weak self] id in
                self?.service
                    .deletePlayer(with: id)
                    .trackActivity(loading)
                    .rerouteError(errorRouter)
                    .asDriver(onErrorJustReturn: .empty)
                    .map { PlayerViewModel(id: $0.id, name: $0.fullName) } ?? .just(.empty)
            }


        let errorMessage = errorRouter.error
            .map { $0.localizedDescription }
        
        return .init(
            players: players,
            removedPlayer: removedPlayer,
            loading: loading.asDriver(),
            errorMessage: errorMessage.asDriver(onErrorJustReturn: String())
        )
    }
}
