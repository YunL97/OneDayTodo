//
//  AddTodoViewController.swift
//  OneDayTodo
//
//  Created by 이윤식 on 2022/01/14.
//



import UIKit
import CoreData

protocol TodoDetailViewControllerDelegate: AnyObject {
    func didFinishSaveData()
}

class AddTodoViewController: UIViewController {

    weak var delegate: TodoDetailViewControllerDelegate?
    
    var ordercount:Int?
    var selectedTodoList: TodoList?
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    //NSManagedObjectContext
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //텍스트필드 테두리 변경
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1.0
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let hasdata = selectedTodoList {
            textField.text = hasdata.title
            deleteButton.isHidden = false
            saveButton.setTitle("업데이트", for: .normal)
        }else {
            deleteButton.isHidden = true
            saveButton.setTitle("더하기", for: .normal)
            
        }
        
    }
    
    
    
    @IBAction func saveTodo(_ sender: Any) {
        if selectedTodoList != nil {
            updateTodo()
        }else {
            saveTodo()
        }
        
    }
    
    func saveTodo() {
        // todoList 테이블 가져오기
        //NSentityDesciption
    guard  let entityDesciption = NSEntityDescription.entity(forEntityName: "TodoList", in: context) else {
        return
    }
        //그 모델 그대로 가져옴
    guard let object = NSManagedObject(entity:entityDesciption, insertInto: context) as? TodoList else{
        return
    }
        object.title = textField.text
        object.uuid = UUID()
        if let ordercount1 = ordercount{
        object.order = Int32(ordercount1 + 1)
        print(Int32(ordercount1 + 1))
        
        }
        //세이브는 uiapplicationdelegate 에서 가능
        //appdelegate 참조방법
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate )
        
        //테이블에 데이터 저장
        appDelegate.saveContext()
        
        //함수가 끝날 때 프로토콜함수까지 호출하게 만듬, viewcontroller 에서 didfinishData함수가 정의 되어 있음
        delegate?.didFinishSaveData()
    
        //화면내린다고해서 테이블뷰가 자동으로 갱신되지 않음 그래서 프로토콜로 지정해줘야함
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateTodo() {
        guard let hasData = selectedTodoList else {
            return
        }
        
        guard let hasUUID = hasData.uuid else {
            return
        }
        
        // todolist 테이블 데이터 불러올 준비
        let fetchRequest:NSFetchRequest<TodoList> = TodoList.fetchRequest()
        
        //todolist 셀렉된 튜플만 가져오기
        fetchRequest.predicate = NSPredicate(format: "uuid = %@", hasUUID as CVarArg)
        
        //컨텍스트에서 fetchRequest 조건이 걸린거를 가져온다
        do{
              let loadeddData = try context.fetch(fetchRequest)
            loadeddData.first?.title = textField.text
            
            //세이브는 uiapplicationdelegate 에서 가능
            let appDelegate = (UIApplication.shared.delegate as! AppDelegate )
            
            //테이블에 데이터 저장
            appDelegate.saveContext()
            
            //함수가 끝날 때 프로토콜함수까지 호출하게 만듬, viewcontroller 에서 didfinishData함수가 정의 되어 있음
            delegate?.didFinishSaveData()


            //화면내린다고해서 테이블뷰가 자동으로 갱신되지 않음 그래서 프로토콜로 지정해줘야함
            self.dismiss(animated: true, completion: nil)
        
    }catch{
        print(error)
    }
}
    
    
    @IBAction func deleteTodo(_ sender: Any) {
        
        
        guard let hasData = selectedTodoList else {
            return
        }
        
        guard let hasUUID = hasData.uuid else {
            return
        }
        
        // todolist 테이블 데이터 불러올 준비
        let fetchRequest:NSFetchRequest<TodoList> = TodoList.fetchRequest()
        
        //todolist 셀렉된 튜플만 가져오기
        fetchRequest.predicate = NSPredicate(format: "uuid = %@", hasUUID as CVarArg)
        
        do{
            let loadedData = try context.fetch(fetchRequest)
            
            if let loadFirstData = loadedData.first {
                    //메모리 상태에 있는거만 지움 그래서 앱 다시키면 있음
                    context.delete(loadFirstData)
                
                //그래서 앱델리게이트 세이브 해주면 된다
                let appDelegate = (UIApplication.shared.delegate as! AppDelegate )
                
                //테이블에 데이터 저장
                appDelegate.saveContext()
            }
            
            
        }catch{
            print(error)
        }
        
        delegate?.didFinishSaveData()
        self.dismiss(animated: true, completion: nil)

    }
    
}
