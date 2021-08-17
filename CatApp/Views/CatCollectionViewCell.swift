//
//  CatCollectionViewCell.swift
//  CatApp
//
//  Created by XO on 10.08.2021.
//  Copyright © 2021 XO. All rights reserved.
//

import UIKit

class CatCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "Cell"
    
    private let catImageView = UIImageView()
    public var cat:Cat?
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        backgroundColor = .systemRed
        contentView.backgroundColor = .systemGray
        contentView.addSubview(catImageView)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        catImageView.frame = CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.height)
    }
    
    func addImage(Cat: Cat) -> Void {
        guard let url = Cat.url else { return }
        catImageView.loadImageWithCache(from: url) { (data, url) in
            if (Cat.url == url) {
                DispatchQueue.main.async {
                    self.catImageView.image = UIImage(data: data)
                }
            }
        }
    }
    
    func addImageFromDB(Cat: CatObject) -> Void {
        guard let url = Cat.url else { return }
        catImageView.backgroundColor = .white
        catImageView.loadImageWithCache(from: url) { (data, url) in
            if (Cat.url == url) {
                DispatchQueue.main.async {
                    self.catImageView.image = UIImage(data: data)
                }
            }
        }
    }
    
}
