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
    
    @IBOutlet weak var resetButton: UIButton!{
        didSet{
            resetButton.titleLabel?.font = .systemFont(ofSize: 25)
        }
    }
    
    @IBAction func resetButtonClick(_ sender:UIButton){
        print("aa")
        
    }
    
    var hidden1 = false
    //앱델리게이트 참조 방법
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var todoList = [TodoList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = "습관 만들기"
        
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
        
        if self.todoTableView.isEditing {
            self.todoTableView.setEditing(false, animated: true)
            hidden1 = false
            if todoList.count != 0{
                for i in 0...todoList.count - 1 {
                    //                    print(todoList)
                    let fetchRequest:NSFetchRequest<TodoList> = TodoList.fetchRequest()
                    guard let hasUUID = todoList[i].uuid else {
                        return
                    }
                    fetchRequest.predicate = NSPredicate(format: "uuid = %@", hasUUID as CVarArg)
                    do{
                        let loadeddData = try context.fetch(fetchRequest)
                        
                        //                                            print(loadeddData)
                        loadeddData.first?.order = Int32(i)
                        
                        let appDelegate = (UIApplication.shared.delegate as! AppDelegate )
                        
                        appDelegate.saveContext()
                        
                        //이 fetchData때문에 오류가 나는거였음
                        //fetchData에서 todoList에 데이터를 담아서 꼬이는거였네 for문돌때마다 가져와서 데이터가 꼬이는거였음
                        //fetchData()
                        //todoTableView.reloadData()
                        
                        
                    }catch{
                        print(error)
                    }
                    
                }
                fetchData()
                todoTableView.reloadData()
            }
            
        }else {
            self.todoTableView.setEditing(true, animated: true)
            hidden1 = true
            fetchData()
            todoTableView.reloadData()
            
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
        
        //item.tintColor = .blue
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
        cell.titleLabel.attributedText = nil
        cell.titleLabel.text = nil
        
        todoList.sort(by: {$0.order < $1.order})
        
        cell.tab = todoList[indexPath.row].check

        cell.titleLabel.text = todoList[indexPath.row].title
        
        if cell.tab == false {
                cell.tabButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            if hidden1 == true{
                cell.tabButton.isHidden = true
            }else {
                cell.tabButton.isHidden = false
            }
            cell.titleLabel.textColor = .black
            cell.titleLabel.attributedText = nil
            cell.titleLabel.text = todoList[indexPath.row].title
        }else {
                cell.tabButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            if hidden1 == true{
                cell.tabButton.isHidden = true
            }else {
                cell.tabButton.isHidden = false
            }
            cell.titleLabel.textColor = .gray
            cell.titleLabel.attributedText = cell.strikeThrough(cell.titleLabel)
        }
        cell.uuid = todoList[indexPath.row].uuid
        cell.title = todoList[indexPath.row].title
        print("\(cell.uuid)\(cell.title)\(cell.tab)")
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

