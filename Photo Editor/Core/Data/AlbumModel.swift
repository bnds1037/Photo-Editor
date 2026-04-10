import Foundation

struct AlbumModel: Identifiable, Codable {
    let id: UUID
    var name: String
    let createDate: Date
    var photoIDs: [UUID]
    let isSmartAlbum: Bool
}
