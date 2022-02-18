//
//  TodoCell.swift
//  OneDayTodo
//
//  Created by 이윤식 on 2022/01/17.
//

import UIKit

class TodoCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var threeLine: UIImageView!{
        didSet{
            threeLine.isHidden = false
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
