//
//  AddTodoViewController.swift
//  OneDayTodo
//
//  Created by 이윤식 on 2022/01/14.
//

import UIKit
import CoreData

class AddTodoViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    var testModel:testModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //텍스트필드 테두리 변경
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1.0
        
        
        
        
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "alarm"), style: .plain, target: self, action: #selector(popToPrevious))
        
//        self.navigationItem.backButtonTitle = "뒤로"
//        self.present(addVC, animated: true, completion: nil)
    }
    
//
//    @IBAction func testAction(_ sender: Any) {
//        //NSManagedObjectContext
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//
//    guard    let entityDesciption = NSEntityDescription.entity(forEntityName: "Test", in: context) else {
//        return
//    }
//
//    //그 모델 그대로 가져옴
//    guard let object = NSManagedObject(entity: entityDesciption, insertInto: context) as? Test else{
//        return
//    }
//        object.test = "model 에 들어가는지 테스트1"
////        object.test = "model 에 들어가는지 테스트2"
//
//        let appDelegate = (UIApplication.shared.delegate as! AppDelegate )
//
//        appDelegate.saveContext()
//
//        dismiss(animated: true, completion: nil)
//    }
    
    
    
    
    
//    @objc func popToPrevious() {
//        self.navigationController?.popViewController(animated: true)
//    }
    
}
