//
//  PhotoGridView.swift
//  HelloAlbum
//
//  Created by shiyanjun on 2024/10/23.
//

import SwiftUI

struct PhotoGridView: View {
    @EnvironmentObject var vm: PhotoViewModel
    
    private let columns = [GridItem(.adaptive(minimum: 120), spacing: 2)]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 2) {
                ForEach(vm.photos.indices, id: \.self) { index in
                    NavigationLink {
                        PhotoDetailView(photo: vm.photos[index])
                    } label: {
                        PhotoGridItem(photo: vm.photos[index])
                    }
                }
            }
        }
        .navigationTitle("我的照片(\(vm.photos.count)张)")
    }
}

struct PhotoGridItem: View {
    @EnvironmentObject var vm: PhotoViewModel
    private let targetSize: CGSize = .init(width: 200, height: 200)
    let photo: Photo
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            Group {
                if let uiImage = photo.uiImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: size.width, height: size.height)
                        .clipped()
                        .contentShape(.rect)
                } else {
                    ProgressView()
                        .frame(width: size.width, height: size.height)
                }
            }
            .onAppear {
                vm.loadImage(asset: photo.asset, targetSize: targetSize) { uiImage in
                    if let index = vm.photos.firstIndex(where: {$0.id == photo.id}) {
                        vm.photos[index].uiImage = uiImage
                    }
                }
            }
        }
        .aspectRatio(contentMode: .fill)
    }
}

struct PhotoDetailView: View {
    @EnvironmentObject var vm: PhotoViewModel
    private let targetSize: CGSize = .init(width: 1024, height: 1024)
    let photo: Photo
    
    var body: some View {
        VStack {
            if let uiImage = photo.uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView()
            }
        }
        .onAppear {
            vm.loadImage(asset: photo.asset, targetSize: targetSize) { uiImage in
                if let index = vm.photos.firstIndex(where: {$0.id == photo.id}) {
                    vm.photos[index].uiImage = uiImage
                }
            }
        }
        .navigationTitle(photo.id)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        PhotoGridView()
            .preferredColorScheme(.dark)
    }
}
