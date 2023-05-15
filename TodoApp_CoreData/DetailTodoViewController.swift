//
//  DetailTodoViewController.swift
//  TodoApp_CoreData
//
//  Created by 초코크림 on 2023/05/09.
//

import UIKit
import CoreData

enum PriorityLevel: Int16{
    case level1
    case level2
    case level3
}

extension PriorityLevel{
    var color: UIColor{
        switch self{
        case .level1:
            return .green
        case .level2:
            return .orange
        case .level3:
            return .red
        }
    }
    
    var title: String{
        switch self {
        case .level1:
            return "Low"
        case .level2:
            return "Normal"
        case .level3:
            return "High"
        }
    }
}

protocol DetailTodoViewControllerProtocol{
    func didFinishSave()
}

class DetailTodoViewController: UIViewController {
    var delegate: DetailTodoViewControllerProtocol?
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    var todoItem: TodoList?
    var isPickerOpen = false
    var priorityLevel = PriorityLevel.level1
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let halfButtonHeight: CGFloat = 20
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerHeight: NSLayoutConstraint!
    @IBOutlet weak var openButton: UIButton!
    @IBOutlet weak var priorityLevel1: UIButton!{
        didSet{
            priorityLevel1.layer.cornerRadius = halfButtonHeight
            priorityLevel1.setTitle(PriorityLevel.level1.title, for: .normal)
        }
    }
    @IBOutlet weak var priorityLevel2: UIButton!{
        didSet{
            priorityLevel2.layer.cornerRadius = halfButtonHeight
            priorityLevel2.setTitle(PriorityLevel.level2.title, for: .normal)
        }
    }
    @IBOutlet weak var priorityLevel3: UIButton!{
        didSet{
            priorityLevel3.layer.cornerRadius = halfButtonHeight
            priorityLevel3.setTitle(PriorityLevel.level3.title, for: .normal)
        }
    }
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let todoItem = todoItem{
            saveButton.setTitle("Modify", for: .normal)
            titleTextField.text = todoItem.title
            datePicker.date = todoItem.date ?? Date()
            
            let level = PriorityLevel(rawValue: todoItem.priorityLevel)
            priorityLevel = level ?? .level1
            
            updateLevelDesign(level: priorityLevel)
        }
        else{
            deleteButton.isHidden = true
        }
    }
    
    func updateLevelDesign(level: PriorityLevel){
        priorityLevel1.backgroundColor = .clear
        priorityLevel2.backgroundColor = .clear
        priorityLevel3.backgroundColor = .clear
        switch level{
        case .level1:
            priorityLevel1.backgroundColor = level.color
        case .level2:
            priorityLevel2.backgroundColor = level.color
        case .level3:
            priorityLevel3.backgroundColor = level.color
        }
    }

    @IBAction func pockerOpenOrClose(_ sender: Any) {
        isPickerOpen.toggle()
        UIView.animate(withDuration: 0.25){
            if self.isPickerOpen{
                self.datePickerHeight.priority = UILayoutPriority(240.0)
                self.openButton.setTitle("Close", for: .normal)
            }
            else{
                self.datePickerHeight.priority = UILayoutPriority(999.0)
                self.openButton.setTitle("Open", for: .normal)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func selectLevel(_ sender: UIButton) {
        if sender.currentTitle == PriorityLevel.level1.title{
            priorityLevel = .level1
        }
        else if sender.currentTitle == PriorityLevel.level2.title{
            priorityLevel = .level2
        }
        else if sender.currentTitle == PriorityLevel.level3.title{
            priorityLevel = .level3
        }
        
        updateLevelDesign(level: priorityLevel)
    }
    
    @IBAction func save(_ sender: Any) {
        if let todoItem = todoItem{
            // 수정 할 때
            CoreDataManager.shared.update(entity: todoItem) { entity in
                entity.title = titleTextField.text
                entity.priorityLevel = priorityLevel.rawValue
                entity.date = datePicker.date
            }
//            todoItem.title = titleTextField.text
//            todoItem.priorityLevel = priorityLevel.rawValue
//            todoItem.date = datePicker.date
            
            // let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
            // appDelegate.saveContext()
            
            CoreDataManager.shared.saveContext()
            delegate?.didFinishSave()
            self.dismiss(animated: true)
            
            return
        }
        
//        guard let entityDesctiption = NSEntityDescription.entity(forEntityName: "TodoList", in: context) else{
//            return
//        }
//        guard let managedObject = NSManagedObject(entity: entityDesctiption, insertInto: context) as? TodoList else{
//            return
//        }
//        appDelegate.saveContext()
        
        CoreDataManager.shared.create(entity: TodoList.self){ entity in
            entity.title = titleTextField.text
            entity.priorityLevel = priorityLevel.rawValue
            entity.date = datePicker.date
            entity.id = UUID()
        }

        delegate?.didFinishSave()
        self.dismiss(animated: true)
    }
    
    @IBAction func deleteItem(_ sender: Any) {
        if let todoItem = todoItem{
            // 삭제
            // context.delete(todoItem)
            CoreDataManager.shared.delete(entity: todoItem)
            
            // appDelegate.saveContext()
            delegate?.didFinishSave()
            self.dismiss(animated: true)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

