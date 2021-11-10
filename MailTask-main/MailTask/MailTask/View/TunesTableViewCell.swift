//
//  TunesTableViewCell.swift
//  MailTask
//
//  Created by Ума Мирзоева on 05.11.2021.
//

import UIKit

class TunesTableViewCell: UITableViewCell {
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var isImageHidden: Bool? {
        didSet {
            guard let isImageHidden = isImageHidden else { return }
            coverImageView.isHidden = isImageHidden
            widthConstraint?.constant = isImageHidden ? 0 : 100
        }
    }
    
    var imageUrlString: String? {
        didSet {
            guard let urlString = imageUrlString else { return }
            coverImageView.loadImageUsingUrlString(string: urlString)
        }
    }
    
    var widthConstraint: NSLayoutConstraint?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        coverImageView.image = nil
    }
    
    private func setupLayout() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(coverImageView)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        
        widthConstraint = coverImageView.widthAnchor.constraint(equalToConstant: 100)
        widthConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: coverImageView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -20),
            
            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            coverImageView.heightAnchor.constraint(equalToConstant: 100),
            coverImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
}

private extension UIImageView {
    func loadImageUsingUrlString(string: String) {
        guard let url = URL(string: string) else { return }
        image = nil
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            }
        }
        .resume()
    }
}
