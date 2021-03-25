//
//  UserListViewModel.swift
//  GitHubClientAppMVVM
//
//  Created by 城野 on 2021/03/23.
//

import Foundation
import UIKit

// 通信状態を ecum で定義
enum ViewModelState {
    case loading
    case finish
    case error(Error)
}

final class UserListViewModel {
    
    // ViewModelState をクロージャとしてプロパティで保持. この変数がVCに通知を送る役割を果たす
    var stateDidUpdate: ((ViewModelState) -> Void)?
    
    // user 配列
    private var users = [User]()
    
    // UserCellViewModel 配列
    var cellViewModels = [UserCellViewModel]()
    
    // Model 層で定義した API クラスを変数として保持
    let api = API()
    
    // User の配列取得
    func getUsers() {
        // .loading 通知を送る
        stateDidUpdate?(.loading)
        users.removeAll()
        
        api.getUsers(success: { (users) in
            self.users.append(contentsOf: users)
            for user in users {
                // UserCellViewModel 配列を作成
                let cellViewModel = UserCellViewModel(user: user)
                self.cellViewModels.append(cellViewModel)
                // 通信が成功したので、.finish 通知を送る
                self.stateDidUpdate?(.finish)
            }
        }) { (error) in
            // 通信失敗なので、.error 通知を送る
            self.stateDidUpdate?(.error(error))
        }
    }
    
    // tableView 表示のために必要なアプトプット
    // UserListViewModel は tableView 全体に対するアウトプットなので、
    // tableView の count に必要な users.count がアウトプット
    // tableViewCell に対するアプトプットは、UserCellViewModel が相当
    func usersCount() -> Int {
        return users.count
    }
    
}
