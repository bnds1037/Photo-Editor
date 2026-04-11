import Foundation
import CoreData
import Combine

class DataManager: ObservableObject {
    @Published var photos: [PhotoModel] = []
    @Published var albums: [AlbumModel] = []
    
    private let coreDataStack = CoreDataStack.shared
    private let userDefaults = UserDefaults.standard
    private let photosKey = "savedPhotos"
    private let albumsKey = "savedAlbums"
    
    init() {
        loadData()
    }
    
    private func loadData() {
        // 从UserDefaults加载保存的照片数据
        if let photosData = userDefaults.data(forKey: photosKey),
           let decodedPhotos = try? JSONDecoder().decode([PhotoModel].self, from: photosData) {
            photos = decodedPhotos
        }
        
        // 从UserDefaults加载保存的相册数据
        if let albumsData = userDefaults.data(forKey: albumsKey),
           let decodedAlbums = try? JSONDecoder().decode([AlbumModel].self, from: albumsData) {
            albums = decodedAlbums
        }
        
        // 如果没有相册，创建一个默认相册
        if albums.isEmpty {
            let defaultAlbum = AlbumModel(
                id: UUID(),
                name: "My Photos",
                createDate: Date(),
                photoIDs: [],
                isSmartAlbum: false
            )
            albums.append(defaultAlbum)
            saveData()
        }
    }
    
    private func saveData() {
        // 保存照片数据到UserDefaults
        if let encodedPhotos = try? JSONEncoder().encode(photos) {
            userDefaults.set(encodedPhotos, forKey: photosKey)
        }
        
        // 保存相册数据到UserDefaults
        if let encodedAlbums = try? JSONEncoder().encode(albums) {
            userDefaults.set(encodedAlbums, forKey: albumsKey)
        }
    }
    
    func addPhoto(_ photo: PhotoModel) {
        photos.append(photo)
        saveData()
    }
    
    func deletePhoto(_ photo: PhotoModel) {
        photos.removeAll { $0.id == photo.id }
        albums.forEach { album in
            if let index = album.photoIDs.firstIndex(of: photo.id) {
                var updatedAlbum = album
                updatedAlbum.photoIDs.remove(at: index)
                if let albumIndex = albums.firstIndex(where: { $0.id == album.id }) {
                    albums[albumIndex] = updatedAlbum
                }
            }
        }
        saveData()
    }
    
    func addAlbum(_ album: AlbumModel) {
        albums.append(album)
        saveData()
    }
    
    func updateAlbum(_ album: AlbumModel) {
        if let index = albums.firstIndex(where: { $0.id == album.id }) {
            albums[index] = album
        }
        saveData()
    }
    
    func deleteAlbum(_ album: AlbumModel) {
        albums.removeAll { $0.id == album.id }
        photos = photos.map { photo in
            if photo.albumID == album.id {
                return PhotoModel(
                    id: photo.id,
                    imageData: photo.imageData,
                    createDate: photo.createDate,
                    location: photo.location,
                    tags: photo.tags,
                    albumID: nil,
                    isBlur: photo.isBlur,
                    isDuplicate: photo.isDuplicate,
                    isFavorite: photo.isFavorite
                )
            }
            return photo
        }
        saveData()
    }
    
    func updatePhoto(_ photo: PhotoModel, with imageData: Data) {
        if let index = photos.firstIndex(where: { $0.id == photo.id }) {
            let updatedPhoto = PhotoModel(
                id: photo.id,
                imageData: imageData,
                createDate: photo.createDate,
                location: photo.location,
                tags: photo.tags,
                albumID: photo.albumID,
                isBlur: photo.isBlur,
                isDuplicate: photo.isDuplicate,
                isFavorite: photo.isFavorite
            )
            photos[index] = updatedPhoto
            saveData()
        }
    }
}
