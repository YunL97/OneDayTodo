//
//  ViewController.swift
//  OneDayTodo
//
//  Created by 이윤식 on 2022/01/14.
//

import UIKit
import CoreData



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        var titleName = UILabel()
       
        self.title = "습관에는 의지가 필요하지 않아요. 습관이 쌓이면 인생이 바뀝니다"
        
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor:UIColor.blue]
        
  
    }


}

