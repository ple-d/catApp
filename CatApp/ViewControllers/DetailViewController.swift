//
//  DetailViewController.swift
//  CatApp
//
//  Created by XO on 10.08.2021.
//  Copyright © 2021 XO. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
        
    var imageView = UIImageView()
    var downloadButton = UIButton()
    var addButton = UIButton()
    
    var cat: Cat? {
        didSet {
            guard let url = cat?.url else { return }
            imageView.loadImageWithCache(from: url) { (data, url) in
                if (self.cat?.url == url) {
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage(data: data)
                    }
                }
            }
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(downloadButton)
        view.addSubview(addButton)
        view.addSubview(imageView)
        setUpUI()
    }
    
    func setUpUI() {
        downloadButton.setTitle("Download", for: .normal)
        downloadButton.addTarget(self, action: #selector(savePhoto), for: .touchUpInside)
        
        if CoreDataManager.shared.checkSave(id: "\(cat?.id ?? String(0))") {
            addButton.setTitle("Delete!", for: .normal)
            addButton.addTarget(self, action: #selector(removeFromFavourite), for: .touchUpInside)
        } else {
            addButton.setTitle("Add!", for: .normal)
            addButton.addTarget(self, action: #selector(addToFavourite), for: .touchUpInside)
        }
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        imageView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -100).isActive = true
        
        downloadButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
        downloadButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        downloadButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        downloadButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        downloadButton.backgroundColor = .systemBlue
        
        addButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
        addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        addButton.backgroundColor = .systemTeal
    }
    
    @objc func savePhoto(sender: UIButton) {
        guard let imageData = imageView.image?.pngData() else { return }
        guard let compressedImage = UIImage(data: imageData) else { return }
        UIImageWriteToSavedPhotosAlbum(compressedImage, nil, nil, nil)
        
        let alert = UIAlertController(title: "Saved", message: "This image has been saved", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func addToFavourite(sender: UIButton) {
        CoreDataManager.shared.save(cat: cat)
        
        let alert = UIAlertController(title: "Added", message: "This image has been added to Favourite", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func removeFromFavourite(sender: UIButton) {
        guard let catID = (cat?.id) else { return }
        CoreDataManager.shared.remove(id: catID)
        
        let alert = UIAlertController(title: "Removed", message: "This image has been removed from Favourite", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}
