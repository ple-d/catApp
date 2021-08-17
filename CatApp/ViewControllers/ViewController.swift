//
//  ViewController.swift
//  CatApp
//
//  Created by XO on 10.08.2021.
//  Copyright © 2021 XO. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let networkService = NetworkService()
    
    var catCollectionView: UICollectionView?
    var leftButton = UIButton()
    var rightButton = UIButton()
    
    var cats = [Cat]() {
        didSet {
            DispatchQueue.main.async {
                self.catCollectionView?.reloadData()
            }
        }
    }
    
    var page = 0 {
        didSet {
            self.getCats()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Welcome"
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (view.frame.size.width/3)-4, height: (view.frame.size.width/3)-4)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        getCats()
        
        catCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        guard let catCollectionView = catCollectionView else { return }
        catCollectionView.register(CatCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        catCollectionView.delegate = self
        catCollectionView.dataSource = self
        view.addSubview(catCollectionView)
        view.addSubview(leftButton)
        view.addSubview(rightButton)
        
        catCollectionView.translatesAutoresizingMaskIntoConstraints = false
        catCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        catCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        catCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        catCollectionView.bottomAnchor.constraint(equalTo: rightButton.topAnchor).isActive = true
        
        leftButton.backgroundColor = .systemRed
        rightButton.backgroundColor = .systemBlue
        leftButton.setTitle("PREVIOUS", for: .normal)
        rightButton.setTitle("NEXT", for: .normal)
        leftButton.setTitleColor(.black, for: .normal)
        rightButton.setTitleColor(.black, for: .normal)
        leftButton.addTarget(self, action: #selector(decreasePage), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(increasePage), for: .touchUpInside)
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        
        leftButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        leftButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        leftButton.widthAnchor.constraint(equalToConstant: view.frame.width/2).isActive = true
        leftButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        rightButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        rightButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        rightButton.widthAnchor.constraint(equalTo: leftButton.widthAnchor).isActive = true
        rightButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        rightButton.leadingAnchor.constraint(equalTo: leftButton.trailingAnchor).isActive = true
    }
    
    @objc func increasePage() {
        self.page = self.page + 1
    }
    
    @objc func decreasePage() {
        if self.page == 0 { self.page = 0 } else {
            self.page = self.page - 1
        }
    }
    
    func getCats() {
        networkService.getCats(page: (page)+1) { result in
        switch result {
        case .failure(let error):
            print(error)
        case .success(let cats):
            self.cats = cats!
            }
        }
    }

}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cats.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = catCollectionView?.dequeueReusableCell(withReuseIdentifier: CatCollectionViewCell.identifier, for: indexPath) as! CatCollectionViewCell
        cell.addImage(Cat: cats[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.allowsSelection = true
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let catsData = cats[indexPath.row]
        let detailViewController = DetailViewController()
        detailViewController.cat = catsData
        detailViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    
}

