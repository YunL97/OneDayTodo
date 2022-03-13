//
//  TodoListViewModel.swift
//  OneDayTodo
//
//  Created by 이윤식 on 2022/03/09.
//

import Foundation
import CoreData
import UIKit

struct TodoListViewModel{
    let context:NSManagedObjectContext
}

extension TodoListViewModel {

    func resetCount(_ todoList: [TodoList]) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
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
                    //print(loadeddData)
                    loadeddData.first?.check = false
                    let appDelegate = (UIApplication.shared.delegate as! AppDelegate )
                    
                    //코어데이터에 저장
                    appDelegate.saveContext()
                }catch{
                    print(error)
                }
            }
           
        }
    }
    
    func editMove(_ todoList:[TodoList]){
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
    }
}

