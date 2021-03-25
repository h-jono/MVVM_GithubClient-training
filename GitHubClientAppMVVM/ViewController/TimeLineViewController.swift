//
//  TimeLineViewController.swift
//  GitHubClientAppMVVM
//
//  Created by 城野 on 2021/03/23.
//

import Foundation
import UIKit
import SafariServices

final class TimeLineViewController: UIViewController {
    
    fileprivate var viewModel: UserListViewModel!
    fileprivate var tableView: UITableView!
    fileprivate var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableView の生成
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TimeLineCell.self, forCellReuseIdentifier: "TimeLineCell")
        view.addSubview(tableView)
        
        // UIRefreshControl を生成し、リフレッシュした時に呼ばれるメソッドを定義し、tableView.refreshControl にセット
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlValueDidChange(sender:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        // UserListViewModel を生成し、通知を受け取った時の処理を定義
        viewModel = UserListViewModel()
        viewModel.stateDidUpdate = {[weak self] state in
            switch state {
            case .loading:
                // 通信中だと tableView を操作不可に
                self?.tableView.isUserInteractionEnabled = false
                break
            case .finish:
                
                self?.tableView.isUserInteractionEnabled = true
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
                break
            case .error(let error):
                
                self?.tableView.isUserInteractionEnabled = true
                self?.refreshControl.endRefreshing()
                
                let alertController = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(alertAction)
                self?.present(alertController, animated: true, completion: nil)
                break
            }
        }
        // ユーザー一覧を取得
        viewModel.getUsers()
    }
    
    @objc func refreshControlValueDidChange(sender: UIRefreshControl) {
        // リフレッシュ時にユーザー一覧を取得
        viewModel.getUsers()
    }
}

extension TimeLineViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    
    // viewModel.usersCount() を tableView の Cell の数として設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.usersCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let timeLineCell = tableView.dequeueReusableCell(withIdentifier: "TimeLineCell") as? TimeLineCell {
            // その Cell の UserCellViewModel を取得し、timeLineCell に対して nickName と icon をセット
            let cellViewModel = viewModel.cellViewModels[indexPath.row]
            timeLineCell.setNickName(nickName: cellViewModel.nickName)
            cellViewModel.downloadImage{ (progress) in
                switch progress {
                case .loading(let image):
                    timeLineCell.setIcon(icon: image)
                    break
                case .finish(let image):
                    timeLineCell.setIcon(icon: image)
                    break
                case .error:
                    break
                }
            }
            return timeLineCell
        }
        fatalError()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        // その Cell の UserCellViewModel を取得し、そのユーザーの Github ページへ画面遷移
        let cellViewModel = viewModel.cellViewModels[indexPath.row]
        let webURL = cellViewModel.webURL
        let webViewController = SFSafariViewController(url: webURL)
        navigationController?.pushViewController(webViewController, animated: true)
    }
    
}
