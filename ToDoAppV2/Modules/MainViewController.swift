//
//  MainViewController.swift
//  ToDoAppV2
//
//  Created by Isagulov urmat on 15/1/23.
//

import UIKit
import SnapKit
import CoreData

class MainViewController: UIViewController {
    
    
    private lazy var newTaskButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("Add new item", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        //        let tap = UITapGestureRecognizer(target: self, action: #selector(newTaskButtonTapped))
        
        button.addTarget(self, action: #selector(newTaskButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var searchTextField: UITextField = {
        let tf = UITextField()
        
        tf.backgroundColor = .white
        tf.borderStyle = .line
        tf.placeholder = "Search"
        tf.setLeftPaddingPoints(20)
        tf.delegate = self
        
        return tf
    }()
    
    private lazy var taskTableView: UITableView = {
        let tv = UITableView()
        
        tv.backgroundColor = .systemGray6
        tv.register(TaskTableViewCell.self, forCellReuseIdentifier: "TaskTableViewCell")
        tv.rowHeight = 100
        tv.dataSource = self
        tv.delegate = self
        
        return tv
    }()
    
    var tasks: [Task] = []
    var searchedTasks: [Task] = []
    var isSearching: Bool = false
    var searchingText: String = ""
    let tasksKey = "Tasks"
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Tasks.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray6
        
        setupViews()
        setupConstraints()
        
        getTasksData()
        
        
        
    }
    
    private func setupViews() {
        view.addSubview(searchTextField)
        view.addSubview(taskTableView)
        view.addSubview(newTaskButton)
    }
    
    private func setupConstraints() {
        searchTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(100)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        
        taskTableView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(100)
        }
        
        newTaskButton.snp.makeConstraints { make in
            make.top.equalTo(taskTableView.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview().inset (20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-6)
        }
    }
    
    private func getTasksData() {
        
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        
        do{
            try tasks = context.fetch(request)
            self.reloadData()
        }catch{
            print("failed to get data \(error) ")
        }
    }
    
    private func saveTasksData() {
        
        do{
            try context.save()
        }catch{
            print("failed to save Data: \(error) ")
        }
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.taskTableView.reloadData()
        }
    }
    
    @objc func newTaskButtonTapped() {
        
        var tf = UITextField()
        
        let alertView = UIAlertController(title: "Add new Task", message: "Add task please!", preferredStyle: .alert)
        
        alertView.addTextField { (textField) in
            tf = textField
        }
        
        let action = UIAlertAction(title: "Add task!", style: .default) { (action) in
            
            guard let text = tf.text else {return}
            if !text.isEmpty{
                let task = Task(context: self.context)
                
                task.title = text
                task.isDone = false
                task.id = UUID().uuidString
                self.saveTasksData()
                self.getTasksData()
            }
        }
        
        alertView.addAction(action)
        present(alertView, animated: true)
    }
    
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching{
            return searchedTasks.count
        }else{
            return tasks.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as! TaskTableViewCell
        
//        var task = Task(id: "", title: "", isDone: false)
        
//        if isSearching{
//            task = searchedTasks[indexPath.row]
//        }else{
//            task = tasks[indexPath.row]
//        }
        
//        cell.config(text: task.title, isDone: task.isDone)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        tasks[indexPath.row].isDone = !tasks[indexPath.row].isDone
        saveTasksData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            
            if isSearching{
                for i in tasks{
                    if searchedTasks[indexPath.row].id == i.id{
                        searchedTasks.remove(at: indexPath.row)
                        tasks.remove(at: indexPath.row)
                    }
                }
                
            }else{
                tasks.remove(at: indexPath.row)
            }
            
            saveTasksData()
        }
    }
}

extension MainViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//
//        guard let text = textField.text else {
//            isSearching = false
//            self.reloadData()
//            return
//        }
//
//        if !text.isEmpty{
//            isSearching = true
//            searchingText = text
//            searchedTasks.removeAll()
//            for i in tasks {
//                if i.title.lowercased().contains("\(text.lowercased())"){
//                    searchedTasks.append(i)
//                }
//            }
//            self.reloadData()
//        }else{
//            isSearching = false
//            self.reloadData()
//        }
//    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else {
            isSearching = false
            self.reloadData()
            return
        }
        
        if !text.isEmpty{
            isSearching = true
            searchingText = text
            searchedTasks.removeAll()
            for i in tasks {
//                if i.title.lowercased().contains("\(text.lowercased())"){
//                    searchedTasks.append(i)
//                }
            }
            self.reloadData()
        }else{
            isSearching = false
            self.reloadData()
        }
    }
}
