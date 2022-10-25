//
//  ContentView.swift
//  MyPics
//
//  Created by Shellflower on 25.10.22.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    
    let store: StoreOf<PhotosOrganizer>
    
    var columns: [GridItem] = [
        GridItem(.fixed(100), spacing: 10),
        GridItem(.fixed(100), spacing: 10),
        GridItem(.fixed(100), spacing: 10)
    ]
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                
                if viewStore.isLoading {
                    ProgressView()
                } else {
                    ScrollView(.vertical) {
                        LazyVGrid(columns: columns, spacing: 20, pinnedViews: [.sectionHeaders], content: {
                            ForEach(viewStore.albums) { album in
                                Section(header: Text("Album \(album.id)").font(.title)) {
                                    ForEach(album.photos) { photo in
                                        NavigationLink(destination: PhotoDetail(photo: photo)) {
                                            PhotoCell(photo: photo)
                                                }
                        
                                    }
                                }
                                
                            }
                        })
                    }
                    .navigationTitle("My nice pics")
                }
            }
            .task {
                viewStore.send(.loadAllPhotos)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            store: .init(
                initialState: PhotosOrganizer.State(),
                reducer: PhotosOrganizer()
            )
        )
    }
}


struct PhotoCell: View {
    let photo: Photo
    
    var body: some View {
        VStack {
            AsyncImage(url: photo.thumbnailUrl) { thumbnail in
                thumbnail
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipped()
            } placeholder: {
                Image(systemName: "camera.macro")
                    .frame(width: 100, height: 150)
                    .font(.caption)
            }
        }
    }
}

struct PhotoCell_Preview: PreviewProvider {
    static var previews: some View {
        PhotoCell(photo: Photo(id: 1, title: "accusamus beatae ad facilis cum similique qui sunt", url: URL(string: "https://via.placeholder.com/600/92c952")!, thumbnailUrl: URL(string: "https://via.placeholder.com/150/92c952")!))
    }
}

struct PhotoDetail: View {
    let photo: Photo
    
    var body: some View {
        ZStack(alignment: .bottom) {
            AsyncImage(url: photo.url) { photo in
                photo
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .clipped()
            } placeholder: {
                Image(systemName: "camera.macro")
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)                    .font(.caption)
            }
            
            Text(photo.title)
                .font(.body)
                .bold()
                .padding(24)
                .background(
                    Rectangle()
                        .fill(Color.white.opacity(0.75))
                        .frame(minWidth: 0, maxWidth: .infinity)
                )
        }
        .ignoresSafeArea()
    }
}

struct PhotoDetail_Preview: PreviewProvider {
    static var previews: some View {
        PhotoDetail(photo: Photo(id: 1, title: "accusamus beatae ad facilis cum similique qui sunt", url: URL(string: "https://via.placeholder.com/600/92c952")!, thumbnailUrl: URL(string: "https://via.placeholder.com/150/92c952")!))
    }
}
