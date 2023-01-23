//
//  TaskTableViewCell.swift
//  ToDoAppV2
//
//  Created by Isagulov urmat on 15/1/23.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    private lazy var label: UILabel = {
        let label = UILabel()
        
        label.text = "as"
        
        return label
    }()
    
    private lazy var checkImage: UIImageView = {
        let image = UIImageView()
        
        return image
    }()
    
    private var checkMarkImage = UIImage(systemName: "checkmark.seal.fill")
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(checkImage)
        addSubview(label)
        
        checkImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(10)
            make.size.equalTo(50)
        }
        
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalTo(checkImage.snp.leading).offset(-10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(text: String, isDone: Bool){
        label.text = text
        
        checkImage.image = isDone ? checkMarkImage : .none
    }
}
