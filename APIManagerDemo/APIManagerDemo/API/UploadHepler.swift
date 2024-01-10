//
//  UploadHepler.swift
//  APIManager_Example
//
//  Created by Jie on 2022/3/17.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import APIManager

class UploadHepler {
    
    /// 上传图片
    /// - Parameter image: 图片
    static func uploadImage(image: UIImage) {
        let compress: CGFloat = 0.6
        let data = image.jpegData(compressionQuality: compress)!
        let url = APIConfig.baseRequestURL
        APIManager.share.uploadFileWith(data: data,
                                        to: url,
                                        name: "myfile",
                                        fileName: "image.png",
                                        mimeType: "image/png") { result in
            switch result {
            case .success(let data): // To do
                break
            case .failure(let error): // To do
                break
            }
        }
    }
}
