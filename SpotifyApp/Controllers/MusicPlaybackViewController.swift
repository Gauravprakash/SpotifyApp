//
//  PlayerViewController.swift
//  MyMusic
//
//  Created by Afraz Siddiqui on 4/3/20.
//  Copyright © 2020 ASN GROUP LLC. All rights reserved.
//

import AVFoundation
import UIKit

class PlayerViewController: UIViewController {

    public var position: Int = 0
    public var songs: [MusicElement] = []

//    var player: AVAudioPlayer?
    
    var player:AVPlayer?
    var playerItem:AVPlayerItem?
    var isPlaying = false

    // User Interface elements

    private let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let songNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0 // line wrap
        return label
    }()

    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0 // line wrap
        return label
    }()

    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0 // line wrap
        return label
    }()

    let playPauseButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if view.subviews.count == 0 {
            configure()
        }
    }
    
    deinit {
        print("Instance is being deallocated.")
    }

    func configure() {
        // set up player
        let song = songs[position]

        let urlString = song.url.replacingOccurrences(of: " ", with: "")

        do {
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            
            let playerItem:AVPlayerItem = AVPlayerItem(url: URL(string: urlString)!)
            player = AVPlayer(playerItem: playerItem)

           // player = try AVAudioPlayer(contentsOf: URL(string: "https://www.kozco.com/tech/LRMonoPhase4.mp3")!)

            guard let player = player else {
                print("player is nil")
                return
            }
            player.volume = 0.5

            player.play()
            self.isPlaying = true
        }
        catch {
            print("error occurred")
        }

        // set up user interface elements

        // album cover
        albumImageView.frame = CGRect(x: 10,
                                      y: 10,
                                      width: view.frame.size.width-20,
                                      height: view.frame.size.width-20)
        albumImageView.image = UIImage(named: "cover1")
        view.addSubview(albumImageView)

        // Labels: Song name, album, artist
        songNameLabel.frame = CGRect(x: 10,
                                     y: albumImageView.frame.size.height + 10,
                                     width: view.frame.size.width-20,
                                     height: 70)
        albumNameLabel.frame = CGRect(x: 10,
                                     y: albumImageView.frame.size.height + 10 + 70,
                                     width: view.frame.size.width-20,
                                     height: 70)
        artistNameLabel.frame = CGRect(x: 10,
                                       y: albumImageView.frame.size.height + 10 + 140,
                                       width: view.frame.size.width-20,
                                       height: 70)

        songNameLabel.text = song.title
        albumNameLabel.text = song.album
        artistNameLabel.text = song.artist

        view.addSubview(songNameLabel)
        view.addSubview(albumNameLabel)
        view.addSubview(artistNameLabel)

        // Player controls
        let nextButton = UIButton()
        let backButton = UIButton()

        // Frame
        let yPosition = artistNameLabel.frame.origin.y + 70 + 20
        let size: CGFloat = 70

        playPauseButton.frame = CGRect(x: (view.frame.size.width - size) / 2.0,
                                       y: yPosition,
                                       width: size,
                                       height: size)

        nextButton.frame = CGRect(x: view.frame.size.width - size - 20,
                                  y: yPosition,
                                  width: size,
                                  height: size)

        backButton.frame = CGRect(x: 20,
                                  y: yPosition,
                                  width: size,
                                  height: size)

        // Add actions
        playPauseButton.addTarget(self, action: #selector(didTapPlayPauseButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)

        // Styling

        playPauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        backButton.setBackgroundImage(UIImage(systemName: "backward.fill"), for: .normal)
        nextButton.setBackgroundImage(UIImage(systemName: "forward.fill"), for: .normal)

        playPauseButton.tintColor = .black
        backButton.tintColor = .black
        nextButton.tintColor = .black

        view.addSubview(playPauseButton)
        view.addSubview(nextButton)
        view.addSubview(backButton)

        // slider
        let slider = UISlider(frame: CGRect(x: 20,
                                            y: view.frame.size.height-60,
                                            width: view.frame.size.width-40,
                                            height: 50))
        slider.value = 0.5
        slider.addTarget(self, action: #selector(didSlideSlider(_:)), for: .valueChanged)
        view.addSubview(slider)
    }

    @objc func didTapBackButton() {
        if position > 0 {
            position = position - 1
            player?.pause()
            isPlaying = false
            for subview in view.subviews {
                subview.removeFromSuperview()
            }
            configure()
        }
    }

    @objc func didTapNextButton() {
        if position < (songs.count - 1) {
            position = position + 1
            player?.pause()
            isPlaying = false
            for subview in view.subviews {
                subview.removeFromSuperview()
            }
            configure()
        }
    }

    @objc func didTapPlayPauseButton() {
        if isPlaying {
            // pause
            player?.pause()
            // show play button
            isPlaying = false
            playPauseButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)

            // shrink image
            UIView.animate(withDuration: 0.2, animations: {
                self.albumImageView.frame = CGRect(x: 30,
                                                   y: 30,
                                                   width: self.view.frame.size.width-60,
                                                   height: self.view.frame.size.width-60)
            })
        }
        else {
            // play
            player?.play()
            isPlaying = true
            playPauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)

            // increase image size
            UIView.animate(withDuration: 0.2, animations: {
                self.albumImageView.frame = CGRect(x: 10,
                                              y: 10,
                                              width: self.view.frame.size.width-20,
                                              height: self.view.frame.size.width-20)
            })
        }
    }

    @objc func didSlideSlider(_ slider: UISlider) {
        let value = slider.value
        player?.volume = value
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let player = player {
            player.pause()
        }
    }

}

