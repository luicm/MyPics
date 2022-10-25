

import ComposableArchitecture
import Foundation
import SwiftUI

struct PhotosOrganizer: ReducerProtocol {
    /// Controls states and actions that concern logic or modification  of the app globally
    struct State: Equatable {
        var albums: [Album] = []
        var isLoading: Bool = true
    }
    
    enum Action: Equatable {
        case loadAllPhotos
        case loadPhotosResponse(Result<[PhotoGross], PhotosClient.Failure>)
    }
    
    @Dependency(\.mainQueue) var mainQueue
    @Dependency(\.photosClient) var photosClient
    
    //    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    //        switch action {
    //
    //        }
    //    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .loadAllPhotos:
                state.isLoading = true
                return photosClient.requestPhotos()
                    .receive(on: mainQueue)
                    .catchToEffect()
                    .map(Action.loadPhotosResponse)
                
            case let .loadPhotosResponse(.success(photos)):
                
                let photosDic = Dictionary(grouping: photos, by: { $0.albumId })
                
                var albums = photosDic.map({ key, value -> Album in
                    Album(id: key, photos: value.map{Photo(id: $0.id, title: $0.title, url: URL(string: $0.url), thumbnailUrl: URL(string: $0.thumbnailUrl)) } )
                })
                
                state.albums = albums.sorted(by: { $0.id < $1.id })
                state.isLoading = false

                return .none
                
            case .loadPhotosResponse(.failure):
                // TODO: return error message to the user
                return .none
            }
        }
    }
}
