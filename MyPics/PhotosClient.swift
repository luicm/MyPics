
import Foundation
import ComposableArchitecture

enum PhotosClientKey: DependencyKey {
    static var liveValue: PhotosClient = .live
    //TODO: mock preview results
//    static var previewValue: PhotosClient = .preview
}

extension DependencyValues {
    var photosClient: PhotosClient {
        get { self[PhotosClientKey.self] }
        set { self[PhotosClientKey.self] = newValue}
    }
}

struct PhotosClient {
    var requestPhotos: () -> Effect<[PhotoGross], Failure>
    
    enum Failure: Error, Equatable {
        case HTTPError
    }
}

extension PhotosClient {
    
    static let live = PhotosClient(
        requestPhotos: {
            let url = URL(string: "https://jsonplaceholder.typicode.com/photos")
            let request = URLRequest(url: url!)
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            return URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { output -> Data in
                    guard let response = output.response as? HTTPURLResponse else {
                        fatalError()
                    }
                    guard response.statusCode == 200 else {
                        throw PhotosClient.Failure.HTTPError
                    }
                    
                    return output.data
                }
                .decode(type: [PhotoGross].self, decoder: decoder)
                .mapError {
                    print($0)
                    return $0 as! PhotosClient.Failure
                }
                .eraseToEffect()
        }
    )
}

//extension PhotosClient {
//
//    static let preview = PhotosClient(
//        requestAlbums: {
//            //TODO: mock preview results
//            .init(value: [])
//        }
//    )
//}
