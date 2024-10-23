//
//  ContentView.swift
//  HelloAlbum
//
//  Created by shiyanjun on 2024/10/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var vm: PhotoViewModel
    
    var body: some View {
        NavigationStack {
            NavigationLink {
                PhotoGridView()
            } label: {
                Text("所有照片(\(vm.photos.count))")
            }
        }
    }
}

#Preview {
    ContentView()
}
