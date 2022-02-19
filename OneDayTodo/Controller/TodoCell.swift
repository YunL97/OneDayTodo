//
//  TodoCell.swift
//  OneDayTodo
//
//  Created by 이윤식 on 2022/01/17.
//

import UIKit

class TodoCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func didTap(_ sender:UIButton){
        sender.isSelected.toggle()
        titleLabel.textColor = .gray
        
        titleLabel.attributedText = strikeThrough(titleLabel)
    }
    
    func strikeThrough(_ label: UILabel) -> NSAttributedString {
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: label.text ?? "")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
            return attributeString
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
