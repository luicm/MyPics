
import Foundation

struct PhotoGross: Codable, Equatable {
    let albumID: Int
    let id: Int
    let title: String
    let url: URL
    let thumbnailUrl: URL
}

struct Photo: Equatable {
    let id: Int
    let title: String
    let url: URL
    let thumbnailUrl: URL
}

struct Album: Equatable {
    let albumID: Int
    let photos: [Photo]
}
