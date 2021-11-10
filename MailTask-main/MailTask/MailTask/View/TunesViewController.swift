//
//  TunesMovieTableViewCell.swift
//  MailTask
//
//  Created by Ума Мирзоева on 04.11.2021.
//

import UIKit


struct TableViewData {
    let movies: [ItunesItem]
    let music: [ItunesItem]
}

class TunesViewController: UIViewController, UITableViewDataSource, SwitcherDelegate {
    
    private let cellId = "TunesTableViewCellId"
    
    private var isImageHidden = false
    
    private var data: TableViewData? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTapped), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 64
        tableView.register(TunesTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        return tableView
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 2
        return label
    }()
    
    
    private let presenter: TunesPresenter
    
    init(presenter: TunesPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        loadData()
    }
    
    private func setupUI() {
        title = "Ryan Gosling"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(settingsTapped))
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        view.addSubview(errorLabel)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            errorLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func refreshTapped() {
        loadData()
    }
    
    private func loadData() {
        presenter.loadData { [weak self] result in
            switch result {
            case .success(let data):
                self?.data = data
                self?.errorLabel.isHidden = true
            case .failure(let error):
                self?.errorLabel.text = error.localizedDescription
                self?.errorLabel.isHidden = false
            }
            self?.refreshControl.endRefreshing()
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Movies"
        } else if section == 1 {
            return "Musics"
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return data?.movies.count ?? 0
        } else if section == 1 {
            return data?.music.count ?? 0
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    @objc func settingsTapped() {
        let settingsController = SettingsViewController()
        settingsController.isImageHidden = self.isImageHidden
        settingsController.delegate = self
        navigationController?.pushViewController(settingsController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? TunesTableViewCell,
           let data = data {
            let dataMovieMusic = indexPath.section == 0 ? data.movies[indexPath.row] : data.music[indexPath.row]
            cell.title = dataMovieMusic.trackName
            cell.imageUrlString = dataMovieMusic.artworkUrl100
            cell.isImageHidden = isImageHidden
            return cell
        }
        return UITableViewCell()
    }
    
    func switched(value: Bool) {
        isImageHidden = value
        tableView.reloadData()
    }
    
}
