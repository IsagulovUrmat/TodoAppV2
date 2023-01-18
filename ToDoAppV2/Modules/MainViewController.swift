//
//  MainViewController.swift
//  ToDoAppV2
//
//  Created by Isagulov urmat on 15/1/23.
//

import UIKit
import SnapKit

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
    
    var array: [String] = ["Сделать проект", "Устроить созвон", "Посмотреть кино"]
    
    let userDefaults = UserDefaults.standard
    
    let tasksKey = "Tasks"
    
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
        if let tasks = userDefaults.stringArray(forKey: tasksKey){
            array = tasks
            reloadData()
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
                self.array.append(text)
                self.reloadData()
                self.userDefaults.set(self.array, forKey: self.tasksKey)
                
            }
        }
        
        alertView.addAction(action)
        present(alertView, animated: true)
    }

}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as! TaskTableViewCell
        
        cell.config(text: array[indexPath.row])
        
        return cell
    }
    
    
}
