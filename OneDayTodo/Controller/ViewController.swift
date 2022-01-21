//
//  ViewController.swift
//  OneDayTodo
//
//  Created by 이윤식 on 2022/01/14.
//

import UIKit
import CoreData



class ViewController: UIViewController {
    @IBOutlet weak var todoTableView: UITableView!
    
    var hidden1 = false
    //앱델리게이트 참조 방법
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var todoList = [TodoList]()
    var todoList1 = [TodoList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "억지로하는게 아닌 당연히 해야하는것"
        
        self.makeLeftEditButton()
        self.makeRightAddButton()
        self.navistatbarColor()
        
        todoTableView.delegate = self
        todoTableView.dataSource = self
        
        
        fetchData()
        
        

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
   
    }

    
//    edit 버튼 누르면 -, 3선 나오는거
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        //여기서 todoList안 넣어 주면 데이터가 꼬인다 왜그러지
        todoList1 = todoList
        
        if self.todoTableView.isEditing {
            self.todoTableView.setEditing(false, animated: true)
            hidden1 = false

            
            if todoList1.count != 0{
            for i in 0...todoList1.count - 1 {
                let fetchRequest:NSFetchRequest<TodoList> = TodoList.fetchRequest()
                
                
                guard let hasUUID = todoList1[i].uuid else {
                    return
                }
                
                fetchRequest.predicate = NSPredicate(format: "uuid = %@", hasUUID as CVarArg)
                
                
                do{
                      let loadeddData = try context.fetch(fetchRequest)
                    
                    print("--------------------------------")
//                    print(loadeddData)
                    loadeddData.first?.order = Int32(i)
                    
//                    print(todoList[i])
                    let appDelegate = (UIApplication.shared.delegate as! AppDelegate )
                    
                    appDelegate.saveContext()

                    fetchData()
                    todoTableView.reloadData()

                
            }catch{
                print(error)
            }
                 
            }
            }
        
        }else {
            self.todoTableView.setEditing(true, animated: true)
                hidden1 = true
            
                }
    

    }


    //데이터 가져오기
    func fetchData() {
        let fetchRequest: NSFetchRequest<TodoList> = TodoList.fetchRequest()
        
        
        do {
            //
            self.todoList = try context.fetch(fetchRequest)
            
            
        }catch {
            printContent(error)
        }
        
        
    }
    
    
    
    func makeLeftEditButton() {
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    
    }
    
    //네비게이션 + 버튼 추가
    func makeRightAddButton() {
        let item = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTodo))
        
//        item.tintColor = .blue
        self.navigationItem.rightBarButtonItem = item
    }
    
    //네비게이션바, 스테이터스바 색 변경
    func navistatbarColor() {
        let barAppearence = UINavigationBarAppearance()
        barAppearence.backgroundColor = UIColor(red: 20/255, green: 30/255, blue: 40/255, alpha: 0.2)
    
        self.navigationController?.navigationBar.scrollEdgeAppearance = barAppearence
        self.navigationController?.navigationBar.standardAppearance = barAppearence
    }
    
    @objc func addTodo() {
        print("add");
        let addVC = AddTodoViewController.init(nibName: "AddTodoViewController", bundle: nil)
        addVC.ordercount = todoList.count
        addVC.delegate = self
        self.present(addVC, animated: true, completion: nil)
    }
    
    
   
}

extension ViewController:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print(todoList.count)
        return todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodoCell
        
        todoList.sort(by: {$0.order < $1.order})
        
        
        cell.titleLabel.text = todoList[indexPath.row].title
//        cell.threeLine.isHidden = hidden1
        return cell
    }
    

//    // + - 반환
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.row == 0 {
//               return .insert
            return .delete
           } else {
               return .delete
           }
    }

    
    //- 제스쳐로 지우기
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let fetchRequest:NSFetchRequest<TodoList> = TodoList.fetchRequest()
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        fetchRequest.predicate = NSPredicate(format: "uuid = %@", todoList[indexPath.row].uuid! as CVarArg)
        
        do{
            let loadedData = try context.fetch(fetchRequest)
            
            if let loadFirstData = loadedData.first {
                    //메모리 상태에 있는거만 지움 그래서 앱 다시키면 있음
                    context.delete(loadFirstData)
                
                //그래서 앱델리게이트 세이브 해주면 된다
                let appDelegate = (UIApplication.shared.delegate as! AppDelegate )
                
                //테이블에 데이터 저장
                appDelegate.saveContext()
                self.fetchData()
                todoTableView.reloadData()
            }
        }catch{
            print(error)
        }
    }
    
    
    
    //edit 옮기기
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print(sourceIndexPath.row, destinationIndexPath.row)
        
        var emtodo:TodoList = todoList[sourceIndexPath.row]
        todoList.remove(at: sourceIndexPath.row)
        todoList.insert(emtodo, at: destinationIndexPath.row)
        print(todoList)
        
        
        
        
    }

    
//    ---------------------------
    //클릭
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addVC = AddTodoViewController.init(nibName: "AddTodoViewController", bundle: nil)
        tableView.deselectRow(at: indexPath, animated: true)
        addVC.selectedTodoList = todoList[indexPath.row]
        addVC.delegate = self
        self.present(addVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension ViewController:TodoDetailViewControllerDelegate {
    func didFinishSaveData() {
        self.fetchData()
        self.todoTableView.reloadData()
    }
    
    
}

