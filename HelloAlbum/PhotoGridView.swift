//
//  PhotoGridView.swift
//  HelloAlbum
//
//  Created by shiyanjun on 2024/10/23.
//

import SwiftUI

let photoNames: [String] = (0...7).map({"m\($0)"})

struct PhotoGridView: View {
    @StateObject var vm = PhotoViewModel()
    
    private let columns = [GridItem(.adaptive(minimum: 120), spacing: 2)]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 2) {
                ForEach(photoNames.indices, id: \.self) { index in
                    NavigationLink {
                        PhotoDetailView(photo: photoNames[index])
                    } label: {
                        PhotoGridItem(photo: photoNames[index])
                    }
                }
            }
        }
        .navigationTitle("我的照片")
    }
}

struct PhotoGridItem: View {
    let photo: String
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            Image(photo)
                .resizable()
                .scaledToFill()
                .frame(width: size.width, height: size.height)
                .clipped()
                .contentShape(.rect)
        }
        .aspectRatio(contentMode: .fill)
    }
}

struct PhotoDetailView: View {
    let photo: String
    
    var body: some View {
        Image(photo)
            .resizable()
            .scaledToFit()
            .navigationTitle(photo)
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        PhotoGridView()
            .preferredColorScheme(.dark)
    }
}
