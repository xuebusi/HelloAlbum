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
            .onDisappear {
                // 退出时停止所有缓存
                vm.cachingManager.stopCachingImagesForAllAssets()
            }
        }
        .navigationTitle("我的照片(\(vm.photos.count)张)")
    }
}

struct PhotoGridItem: View {
    @EnvironmentObject var vm: PhotoViewModel
    private let targetSize: CGSize = .init(width: 200, height: 200)
    let photo: Photo
    @State private var gridImage: UIImage? = nil
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            ZStack {
                if let gridImage = gridImage {
                    Image(uiImage: gridImage)
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
                vm.startCaching(asset: photo.asset, targetSize: targetSize)
                vm.requestImage(asset: photo.asset, targetSize: targetSize) { uiImage in
                    gridImage = uiImage
                }
            }
            .onDisappear {
                vm.stopCaching(asset: photo.asset, targetSize: targetSize)
            }
        }
        .aspectRatio(contentMode: .fill)
    }
}

struct PhotoDetailView: View {
    @EnvironmentObject var vm: PhotoViewModel
    private let targetSize: CGSize = .init(width: 1024, height: 1024)
    let photo: Photo
    @State private var detailImage: UIImage? = nil
    
    var body: some View {
        ZStack {
            if let detailImage = detailImage {
                Image(uiImage: detailImage)
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView()
            }
        }
        .onAppear {
            // 进入详情页面时开始缓存该照片
            vm.startCaching(asset: photo.asset, targetSize: targetSize)
            vm.requestImage(asset: photo.asset, targetSize: targetSize) { uiImage in
                detailImage = uiImage
            }
        }
        .onDisappear {
            // 离开详情页面时停止缓存该照片
            vm.stopCaching(asset: photo.asset, targetSize: targetSize)
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
