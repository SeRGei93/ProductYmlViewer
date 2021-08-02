//
//  CategoriesTableViewCell.swift
//  ProductYmlViewer
//
//  Created by Сергей Бушкевич on 1.08.21.
//

import UIKit

class CategoriesTableViewCell: UITableViewCell {
    
    static let identifier = "CategoriesTableViewCell"
    
    let categoryTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(categoryTitleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        categoryTitleLabel.frame = CGRect(
            x: 20,
            y: 0,
            width: contentView.frame.size.width,
            height: 30
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
