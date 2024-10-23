//
//  PhotoViewModel.swift
//  HelloAlbum
//
//  Created by shiyanjun on 2024/10/23.
//

import SwiftUI
import Photos

class PhotoViewModel: ObservableObject {
    @Published var photos: [Photo] = []
    
    init() {
        requestAuthorization()
    }
    
    // 请求相册权限
    func requestAuthorization() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            switch(status) {
            case .authorized, .limited:
                self.fetchPhotos()
            default:
                print("相册未授权！")
                break
            }
        }
    }
    
    // 加载照片资源
    func fetchPhotos() {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchRestult = PHAsset.fetchAssets(with: options)
        
        fetchRestult.enumerateObjects { asset, _, _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.photos.append(Photo(asset: asset))
            }
        }
    }
    
    // 加载图片
    func loadImage(asset: PHAsset, targetSize: CGSize, completion: @escaping (UIImage?) -> Void) {
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.deliveryMode = .opportunistic
        options.isNetworkAccessAllowed = true
        
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options) { image, _ in
            completion(image)
        }
    }
}
