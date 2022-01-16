//
//  ViewController.swift
//  OneDayTodo
//
//  Created by 이윤식 on 2022/01/14.
//

import UIKit
import CoreData



class ViewController: UIViewController {
    var testmodel1 = testModel()
    @IBOutlet weak var todoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "억지로하는게 아닌 당연히 해야하는것"
        
//        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor:UIColor.blue]
        
//        todoTableView.delegate = self
//        todoTableView.dataSource = self
//
        self.makeLeftEditButton()
        self.makeRightAddButton()
        self.navistatbarColor()
        
        
        
//        var test = [Test]()
//        let appdelegate = UIApplication.shared.delegate as! AppDelegate
//        let fetchRequest: NSFetchRequest<Test> = Test.fetchRequest()
        
//        let context = appdelegate.persistentContainer.viewContext
//
//         do {
//             //
//             test = try context.fetch(fetchRequest)
//
//             print(test.count)
//             print("aa")
//         }catch {
//             printContent(error)
//         }
//
//
//
//        testmodel1.test = test
//        print(testmodel1)
//
        
        
        
        
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
        
        
        self.present(addVC, animated: true, completion: nil)
        
        //네비게이션바 push
//        self.navigationController?.pushViewController(addVC, animated: true)
//        self.navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "alarm")
//
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    
        
        
        
    }
    
    
    
}

//extension ViewController:UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        return
//    }
//
//
//}

