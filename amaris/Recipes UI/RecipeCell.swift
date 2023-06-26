//
//  RecipeCell.swift
//  amaris
//
//  Created by santiago calvo on 25/06/23.
//

import UIKit

final class RecipeCell: UITableViewCell {
    
    static let identifier = "RecipeCell"
    
    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    let recipeImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let backgroundImageView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.gray
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(backgroundImageView)
        backgroundImageView.addSubview(recipeImageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
            
            backgroundImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 14),
            backgroundImageView.widthAnchor.constraint(equalToConstant: 250),
            backgroundImageView.heightAnchor.constraint(equalToConstant: 250),
            backgroundImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),
            
            recipeImageView.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor),
            recipeImageView.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor),
            recipeImageView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor),
            recipeImageView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor),
        ])
    }
    
}
