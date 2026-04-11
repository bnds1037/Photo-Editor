import Foundation

struct PhotoModel: Identifiable, Codable {
    let id: UUID
    let imageData: Data
    let createDate: Date
    let location: String?
    let tags: [String]
    let albumID: UUID?
    let isBlur: Bool
    let isDuplicate: Bool
    let isFavorite: Bool
}
