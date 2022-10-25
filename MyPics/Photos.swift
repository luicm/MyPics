
import Foundation

struct PhotoGross: Codable, Equatable {
    let albumId: Int
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
}

struct Photo: Equatable, Identifiable {
    let id: Int
    let title: String
    let url: URL?
    let thumbnailUrl: URL?
}

struct Album: Equatable, Identifiable {
    let id: Int
    let photos: [Photo]
}
