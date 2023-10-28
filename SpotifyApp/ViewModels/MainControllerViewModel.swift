//
//  MainControllerViewModel.swift
//
//  Created by Gaurav Prakash on 25/10/23.
//

import Foundation

class MainControllerViewModel {
    
    var onMusicUpdated: (()->Void)?
    var onErrorMessage: ((MusicServiceError)->Void)?
    var isLoadingState = true
    
    private(set) var musicorders: [MusicElement] = [] {
        didSet {
            isLoadingState = false
            self.onMusicUpdated?()
        }
    }
    
    init() {
        self.fetchAlbums()
    }
    
    
    func setWorkorders(_ musicorders:[MusicElement]){
        self.musicorders = musicorders
    }
    
    
    public func fetchAlbums() {
        let endpoint = Endpoint.fetchMusic()
        MusicService.fetchMusics(with: endpoint, completion:  { [weak self] result  in
            switch result {
            case .success(let data):
                self?.musicorders = data
                
            case .failure(let error):
                self?.onErrorMessage?(error)
            }
        })
        
    }
}
