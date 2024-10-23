//
//  HelloAlbumApp.swift
//  HelloAlbum
//
//  Created by shiyanjun on 2024/10/23.
//

import SwiftUI

@main
struct HelloAlbumApp: App {
    @StateObject var vm = PhotoViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(vm)
        }
    }
}
