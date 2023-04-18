//
//  PlayersListViewController.swift
//  DECK_football
//
//  Created by Максим Нурутдинов on 18.04.2023.
//

import UIKit
import RxSwift
import RxCocoa

final class PlayersListViewController: UIViewController {
    
    // MARK: - Dependencies
    
    private let viewModel: PlayersListViewModel
    
    // MARK: - UI
    
    private let tableView = UITableView()
    private let updateButton = UIButton(type: .system)
    private let disposeBag = DisposeBag()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Init`s
    
    init(viewModel: PlayersListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        configureTableView()
        configureUpdateButton()
        configureActivityIndicator()
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.allowsSelection = false
        tableView.delaysContentTouches = false
        tableView.register(PlayerCell.self, forCellReuseIdentifier: .reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
        
    }
    
    private func configureUpdateButton() {
        view.addSubview(updateButton)
        updateButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            updateButton.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            updateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            updateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            updateButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            updateButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        updateButton.setTitle("update", for: .normal)
        updateButton.configuration = .filled()
    }
    
    private func configureActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)

        ])
    }
    
    private func setupBindings() {
        let deleteButtonClicked = PublishSubject<String?>()
        let updateSubject = PublishSubject<Void>()
        
        updateButton.rx.tap
            .bind(to: updateSubject)
            .disposed(by: disposeBag)
        
        let input = PlayersListViewModel.Input(
            updated: updateSubject.asDriver(onErrorJustReturn: ()),
            deleted: deleteButtonClicked.asDriver(onErrorJustReturn: nil)
        )
        let output = viewModel.transform(input: input)
        output.players.drive(
            tableView.rx.items(
                cellIdentifier: .reuseIdentifier,
                cellType: PlayerCell.self
            )
        ) { row, element, cell in
            cell.configure(
                with: element,
                and: deleteButtonClicked.asObserver()
            )
        }.disposed(by: disposeBag)
        
        output.loading
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        output.errorMessage
            .drive { [weak self] message in
                self?.presentAlert(
                    with: "error",
                    and: message
                )
            }.disposed(by: disposeBag)
        
        output.removedPlayer.drive { model in
            updateSubject.onNext(())
        }.disposed(by: disposeBag)
    }
    

    func presentAlert(with title: String, and message: String) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        present(controller, animated: true)
    }
}


// MARK: - Constants
private extension String {
    static let reuseIdentifier = "PlayerCell"
}
