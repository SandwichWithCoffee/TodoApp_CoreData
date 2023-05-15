//
//  ViewController.swift
//  TodoApp_CoreData
//
//  Created by 초코크림 on 2023/05/09.
//

import UIKit

class ViewController: UIViewController {
    // let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    var todoList = [TodoList]()
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UINib(nibName: "TodoCell", bundle: nil), forCellReuseIdentifier: "TodoCell")
        }
    }
    
    func fetchData(){
        // self 값으로 TodoList의 타입을 보냄
        guard let hasList = CoreDataManager.shared.fetchData(entity: TodoList.self) else{
            return
        }
        
        self.todoList = hasList
//        let fetchRequest = TodoList.fetchRequest()
//        let context = appDelegate.persistentContainer.viewContext
//        do{
//            todoList = try context.fetch(fetchRequest)
//        }
//        catch{
//            print(error)
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "To do List"
        addRightBarButtonItem() // 오른쪽 위 +버튼 추가 코드로 구현
        self.fetchData()
        self.tableView.reloadData()
    }

    private func addRightBarButtonItem(){
        let item = UIBarButtonItem(barButtonSystemItem: .add
                                   , target: self, action: #selector(createTodo))
        // item.tintColor = .orange // 버튼 색 변경
        navigationItem.rightBarButtonItem = item
    }

    @objc func createTodo(){
        let detailVC = DetailTodoViewController(nibName: "DetailTodoViewController", bundle: nil)
        
        detailVC.delegate = self
        self.present(detailVC, animated: true)
    }
}

extension ViewController: DetailTodoViewControllerProtocol{
    func didFinishSave(){
        self.fetchData()
        self.tableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailTodoViewController(nibName: "DetailTodoViewController", bundle: nil)
        
        detailVC.delegate = self
        detailVC.todoItem = todoList[indexPath.row]
        self.present(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodoCell
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let savedLevel = todoList[indexPath.row].priorityLevel
        let level = PriorityLevel(rawValue: savedLevel)
        
        if let todoDate = todoList[indexPath.row].date{
            cell.bottomDate.text = formatter.string(from: todoDate)
        }
        cell.topTitle.text = todoList[indexPath.row].title
        cell.priorityLevel.backgroundColor = level?.color
        
        
        return cell
    }
    
    
}

