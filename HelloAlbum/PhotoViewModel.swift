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
}
