//
//  courseListCell.swift
//  course
//
//  Created by 杨科军 on 2016/11/24.
//  Copyright © 2016年 杨科军. All rights reserved.
//

import UIKit

class courseListCell: UITableViewCell {

    @IBOutlet weak var zjNameLabel: UILabel!
    
    var name1:String = "" {
        didSet {
           print(name1)
            self.zjNameLabel.text = "  " + name1
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
