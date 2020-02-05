//
//  SampleTableViewCell.swift
//  CleanArchitectureRxMoya
//
//  Created by Jeff Yu on 2020/2/3.
//  Copyright © 2020 Tcit. All rights reserved.
//

import UIKit

class SampleTableViewCell : UITableViewCell {

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

    func bind(data: GitHubUserElement) {
        label1.text = "\(data.id)"
        label2.text = data.login
        label3.text = data.url
    }
}
