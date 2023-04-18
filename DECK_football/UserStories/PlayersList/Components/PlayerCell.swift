//
//  PlayerCell.swift
//  DECK_football
//
//  Created by Максим Нурутдинов on 18.04.2023.
//

import Foundation
import UIKit
import RxSwift
import RxRelay


final class PlayerCell: UITableViewCell {
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("delete", for: .normal)
        button.configuration = .filled()
        button.configuration?.background.backgroundColor = .red
        return button
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    
    func configure<T>(with viewModel: PlayerViewModel, and buttonEvent: T) where T: ObserverType, T.Element == String? {
        label.text = viewModel.name
        
        deleteButton.rx.tap
            .map { viewModel.id }
            .bind(to: buttonEvent)
            .disposed(by: disposeBag)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
  
        setupDeleteButton()
        setupTextLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupDeleteButton() {
        contentView.addSubview(deleteButton)
        
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            deleteButton.widthAnchor.constraint(equalToConstant: 100),
            deleteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    private func setupTextLabel() {
        contentView.addSubview(label)

        NSLayoutConstraint.activate([
            label.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -20),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

        ])
        label.translatesAutoresizingMaskIntoConstraints = false

    }
}

