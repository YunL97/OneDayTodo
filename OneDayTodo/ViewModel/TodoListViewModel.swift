//
//  TodoListViewModel.swift
//  OneDayTodo
//
//  Created by 이윤식 on 2022/03/09.
//

import Foundation


struct TodoListViewModel{
    let todoList:[TodoList]
}

extension TodoListViewModel {
    func numberOfRowInSection(_ section: Int) -> Int {
        return self.todoList.count
    }
}

