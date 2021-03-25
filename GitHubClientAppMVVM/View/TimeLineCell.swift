//
//  TimeLineCell.swift
//  GitHubClientAppMVVM
//
//  Created by 城野 on 2021/03/23.
//

import Foundation
import UIKit

class TimeLineCell: UITableViewCell {
    // ユーザーの icon を表示させるための UIImageView
    private var iconView: UIImageView!
    // ユーザーの nickName を表示させるための UIImageLabel
    private var nickNameLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        iconView = UIImageView()
        iconView.clipsToBounds = true
        contentView.addSubview(iconView)
        
        nickNameLabel = UILabel()
        nickNameLabel.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(nickNameLabel)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconView.frame = CGRect(x: 15, y: 15, width: 45, height: 45)
        iconView.layer.cornerRadius = iconView.frame.size.width / 2
        nickNameLabel.frame = CGRect(x: iconView.frame.maxX + 15, y: iconView.frame.origin.y, width: contentView.frame.width - iconView.frame.maxX - 15 * 2, height: 15)
    }
    // ユーザーの nickName をセット
    func setNickName(nickName: String) {
        nickNameLabel.text = nickName
    }
    // ユーザーの icon をセット
    func setIcon(icon: UIImage) {
        iconView.image = icon
    }
}
