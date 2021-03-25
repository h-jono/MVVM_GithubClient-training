//
//  UserCellViewModel.swift
//  GitHubClientAppMVVM
//
//  Created by 城野 on 2021/03/23.
//

import Foundation
import UIKit

// image のダウンロード状態をecumで定義
enum ImageDownloadProgress {
    case loading(UIImage)
    case finish(UIImage)
    case error
}


final class UserCellViewModel {
    
    // ユーザーを変数として保持
    private var user: User
    
    // ImageDownloader を変数として保持
    private let imageDownloader = ImageDownloader()
    
    // ImageDownloader でダウンロード中かどうかをBool変数で保持
    private var isLoading = false
    
    // Cell に反映させるアウトプット
    var nickName: String {
        return user.name
    }
    
    // Cell 選択時に必要なwebURL
    var webURL: URL {
        return URL(string: user.webUrl)!
    }
    
    // user を引数にイニシャライズ
    init(user: User) {
        self.user = user
    }
    
    // imageDownloader を用いてダウンロードし、その結果を imageDownloaderProgress として Closure で返却
    func downloadImage(progress :@escaping (ImageDownloadProgress) -> Void) {
        // isLoading が true であれば、return
        // このメソッドは cellForRow メソッドで呼ばれることを想定してる為、何度もダウンロードしないようにisLoadingを使用
        if isLoading == true {
            return
        }
        isLoading = true
        
        // gray の UIImageを作成
        let loadingImage = UIImage(color: .systemPink, size: CGSize(width: 45, height: 45))!
        
        // .loading を closure で返却
        progress(.loading(loadingImage))
        // imageDownloader を用いて画像をダウンロード
        // 引数に、user.iconUrl を使用
        // ダウンロード終了後、.finish を Closure で返却. Error の場合は .error を Closure で返却.
        imageDownloader.downloadImage(imageURL: user.iconUrl, success: { (image) in
            progress(.finish(image))
        }) { (error) in
            progress(.error)
            self.isLoading = false
        }
    }
    
}

