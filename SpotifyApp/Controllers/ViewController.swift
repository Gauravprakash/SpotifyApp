//
//  ViewController.swift
//  SpotifyApp
//
//  Created by Gaurav Prakash on 27/10/23.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    // MARK: - Variables
    private let viewModel: MainControllerViewModel?
    
    private var data: Music?
    
    // MARK: - UI Components
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .systemBackground
        tv.register(OrderCell.self, forCellReuseIdentifier: OrderCell.identifier)
        tv.isHidden = true
        return tv
    }()
    
    private let loadingLabel: UILabel = {
        let tv = UILabel()
        tv.text = "Loading..."
        tv.textAlignment = .center
        tv.isHidden = true
        return tv
    }()
    
  //  var tableView: UITableView!
    
    // MARK: - LifeCycle
    init(_ viewModel: MainControllerViewModel = MainControllerViewModel()) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        setupUI()
        

        self.viewModel?.onMusicUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.loadingLabel.isHidden = true
                self?.tableView.isHidden = false
                self?.tableView.reloadData()
            }
        }
    
    }
   
    
    // MARK: - UI Setup
    private func setupUI() {
        self.navigationItem.title = "Music Player"
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white] // Replace UIColor.red with your desired color
        }
        self.view.backgroundColor = UIColor(named: "backgroundColor")
        self.view.addSubview(loadingLabel)
        self.view.addSubview(tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        // self.tableView.isHidden = true
        
        loadingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
       
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
        ])
    }
    

}



extension ViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.musicorders.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderCell.identifier, for: indexPath) as? OrderCell else {
            fatalError("Unable to dequeue OrderCell in HomeController")
        }
        
        if let order = self.viewModel?.musicorders[indexPath.row]{
            cell.configure(with: order)
        }
        return cell
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
        tableView.deselectRow(at: indexPath, animated: true)

        // present the player
        let position = indexPath.row
        let vc = PlayerViewController()
        
        vc.songs = viewModel?.musicorders ?? []
        vc.position = position
        present(vc, animated: true)
        
    }
    


}

