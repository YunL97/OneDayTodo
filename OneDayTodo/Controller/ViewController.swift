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
    
    var todoList = [TodoList]()
    
    
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

    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)

        
        if self.todoTableView.isEditing {
            self.todoTableView.setEditing(false, animated: true)
            hidden1 = false
        } else {
            self.todoTableView.setEditing(true, animated: true)
                hidden1 = true
                }
        
        
        
//        self.todoTableView.reloadData()

    }

    
    
    
    //데이터 가져오기
    func fetchData() {
        let fetchRequest: NSFetchRequest<TodoList> = TodoList.fetchRequest()
        
       let context = appdelegate.persistentContainer.viewContext
        
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
        
//        todoList.sort(by: {$0.order < $1.order})
        cell.titleLabel.text = todoList[indexPath.row].title
//        cell.threeLine.isHidden = hidden1
        return cell
    }
    

    // + - 반환
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.row == 0 {
//               return .insert
            return .delete
           } else {
               return .delete
           }
    }
    
    
    //
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        print("delete1")
//    }
    
    
    
    //edit 옮기기
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print(sourceIndexPath.row, destinationIndexPath.row)
        
        
        
        
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

