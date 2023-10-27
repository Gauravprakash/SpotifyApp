//
//  OrderCell.swift
//  Upkeep iOS Interview Project
//
//  Created by Gaurav Prakash on 25/10/23.
//


import UIKit

class OrderCell: UITableViewCell {
    
    static let identifier = "OrderCell"
    
    // MARK: - Variables
    private(set) var music: MusicElement!
    
    // MARK: - UI Components
    
    private let artistName: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 1
        label.text = ""
        return label
    }()
    
    private let albumName: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 1
        label.text = ""
        return label
    }()
    
    private let titleName: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 1
        label.text = ""
        return label
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with music: MusicElement) {
        self.music = music
        self.artistName.text = "Artist: \(music.artist)"
        self.albumName.text = "Album: \(music.album)"
        self.titleName.text = "Title: \(music.title)"
    }
    
    // TODO: - PrepareForReuse
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.addSubview(titleName)
        self.addSubview(artistName)
        self.addSubview(albumName)
    
        [artistName,albumName,titleName].forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        NSLayoutConstraint.activate([
            titleName.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor, constant: 8),
            titleName.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor, constant: 8),
            titleName.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor,constant: 8),
            artistName.topAnchor.constraint(equalTo:titleName.lastBaselineAnchor, constant: 8),
            artistName.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor, constant: 8),
            artistName.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor,constant: 8),
            albumName.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor, constant: 8),
            albumName.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor,constant: 8),
            albumName.topAnchor.constraint(equalTo: artistName.lastBaselineAnchor, constant: 8)
            
        ])
    }
}
