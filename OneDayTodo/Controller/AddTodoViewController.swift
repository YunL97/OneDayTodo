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
    

    //NSManagedObjectContext
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //텍스트필드 테두리 변경
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1.0
        
    }
    
    
    @IBAction func saveTodo(_ sender: Any) {
        // todoList 테이블 가져오기
        //NSentityDesciption
    guard  let entityDesciption = NSEntityDescription.entity(forEntityName: "TodoList", in: context) else {
        return
    }
        
    }
    
}
