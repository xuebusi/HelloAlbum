//
//  Photo.swift
//  HelloAlbum
//
//  Created by shiyanjun on 2024/10/23.
//

import SwiftUI
import Photos

struct Photo: Identifiable {
    var id: String { localIdentifier }
    var localIdentifier: String
    var asset: PHAsset
    var image: UIImage?
    
    init(asset: PHAsset) {
        self.asset = asset
        self.localIdentifier = asset.localIdentifier
    }
}
