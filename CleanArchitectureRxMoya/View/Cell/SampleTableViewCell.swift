//
//  SampleTableViewCell.swift
//  CleanArchitectureRxMoya
//
//  Created by Jeff Yu on 2020/2/3.
//  Copyright © 2020 Tcit. All rights reserved.
//

import UIKit
import Kingfisher

class SampleTableViewCell : UITableViewCell {

    @IBOutlet weak private var ivAvatar: UIImageView!
    @IBOutlet weak private var label1: UILabel!
    @IBOutlet weak private var label2: UILabel!
    @IBOutlet weak private var label3: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setModel(_ model: GitHubUserElement) {
        label1.text = "\(model.id)"
        label2.text = model.login
        label3.text = model.url
        
        let processor = RoundCornerImageProcessor(cornerRadius: 20)
        
        ivAvatar.kf.setImage(with: URL(string: model.avatarURL),
                             options: [.processor(processor)])
    }
}
