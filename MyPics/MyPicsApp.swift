//
//  MyPicsApp.swift
//  MyPics
//
//  Created by Shellflower on 25.10.22.
//

import SwiftUI

@main
struct MyPicsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                store: .init(
                    initialState: PhotosOrganizer.State(),
                    reducer: PhotosOrganizer()
                )
            )        }
    }
}
