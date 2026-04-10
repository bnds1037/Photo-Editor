import Foundation
import SwiftUI
import Combine

class MainViewModel: ObservableObject {
    @Published var photos: [PhotoModel] = []
    @Published var albums: [AlbumModel] = []
    @Published var selectedAlbumID: UUID?
    @Published var searchText: String = ""
    @Published var isGridView: Bool = true
    
    private let photoService: PhotoService
    private let albumService: AlbumService
    
    init(dataManager: DataManager) {
        self.photoService = PhotoService(dataManager: dataManager)
        self.albumService = AlbumService(dataManager: dataManager)
        loadData()
    }
    
    func loadData() {
        photos = photoService.getPhotos()
        albums = albumService.getAlbums()
    }
    
    func getPhotosByAlbum(albumID: UUID) -> [PhotoModel] {
        return photoService.getPhotosByAlbum(albumID: albumID)
    }
    
    func toggleView() {
        isGridView.toggle()
    }
    
    func searchPhotos() -> [PhotoModel] {
        if searchText.isEmpty {
            return selectedAlbumID != nil ? getPhotosByAlbum(albumID: selectedAlbumID!) : photos
        } else {
            let filteredPhotos = photos.filter { photo in
                photo.tags.contains { $0.lowercased().contains(searchText.lowercased()) }
                    || (photo.location?.lowercased().contains(searchText.lowercased()) ?? false)
            }
            return selectedAlbumID != nil ? filteredPhotos.filter { $0.albumID == selectedAlbumID } : filteredPhotos
        }
    }
    
    func selectAlbum(albumID: UUID?) {
        selectedAlbumID = albumID
    }
    
    func importPhoto(imageData: Data, location: String?, tags: [String]) {
        photoService.importPhoto(imageData: imageData, location: location, tags: tags)
        loadData()
    }
    
    func deletePhoto(photo: PhotoModel) {
        photoService.deletePhoto(photo: photo)
        loadData()
    }
}
