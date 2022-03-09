//
//  TodoCell.swift
//  OneDayTodo
//
//  Created by 이윤식 on 2022/01/17.
//

import UIKit
import CoreData



class TodoCell: UITableViewCell {
    
    weak var delegate: TodoDetailViewControllerDelegate?
    
    var title:String?
    var uuid:UUID?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var tab:Bool?
    var tab1:Bool?

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var tabButton: UIButton!
    
    
    @IBAction func didTap(_ sender:UIButton){
//        sender.isSelected.toggle()
        
        if tab == false{
        titleLabel.textColor = .gray
            tabButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
        titleLabel.attributedText = strikeThrough(titleLabel)
        tab = true
        }else {
            tab = false
            tabButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            
            
            titleLabel.attributedText = nil
            titleLabel.text = title!
            titleLabel.textColor = .black
            print("aaa\(title!)")
        }
        
        guard let hasUUID = uuid else {
            return
            
        }
        
        // todolist 테이블 데이터 불러올 준비
        let fetchRequest:NSFetchRequest<TodoList> = TodoList.fetchRequest()
        
        //todolist 셀렉된 튜플만 가져오기
        fetchRequest.predicate = NSPredicate(format: "uuid = %@", hasUUID as CVarArg)
        
        //컨텍스트에서 fetchRequest 조건이 걸린거를 가져온다
        do{
              let loadeddData = try context.fetch(fetchRequest)
            loadeddData.first?.check = tab ?? false
            
            //세이브는 uiapplicationdelegate 에서 가능
            let appDelegate = (UIApplication.shared.delegate as! AppDelegate )
            
            //테이블에 데이터 저장
            appDelegate.saveContext()
            
            //함수가 끝날 때 프로토콜함수까지 호출하게 만듬, viewcontroller 에서 didfinishData함수가 정의 되어 있음
//            delegate?.didFinishSaveData()

            delegate?.didFinishSaveData()
         
        
    }catch{
        print(error)
    }
        
        
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
