//
//  AppModulesFactory.swift
//  DECK_football
//
//  Created by Максим Нурутдинов on 18.04.2023.
//

import Foundation
import UIKit
import RxSwift
//1 
final class AppModulesFactory {
    static func makePlayersListModule() -> PlayersListViewController {
        PlayersListViewController()
    }
}
