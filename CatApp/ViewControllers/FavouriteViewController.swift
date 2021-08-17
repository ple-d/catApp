//
//  FavouriteViewController.swift
//  CatApp
//
//  Created by XO on 11.08.2021.
//  Copyright © 2021 XO. All rights reserved.
//

import UIKit
import CoreData

class FavouriteViewController: UIViewController {
    
    let fetchResultController: NSFetchedResultsController<CatObject>? = {
        return CoreDataManager.shared.getFetchResultsController(entityName: String(describing: CatObject.self), sortDescriptor: "id", filterKey: nil) as? NSFetchedResultsController<CatObject>
    }()
    
    var catCollectionView: UICollectionView?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchResultController?.delegate = self
        do { try fetchResultController?.performFetch() } catch let error as NSError {
            print (error)
            return
        }
        
        title = "Favourite"
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (view.frame.size.width/3)-4, height: (view.frame.size.width/3)-4)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        catCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        guard let catCollectionView = catCollectionView else { return }
        catCollectionView.register(CatCollectionViewCell.self, forCellWithReuseIdentifier: CatCollectionViewCell.identifier)
        
        catCollectionView.delegate = self
        catCollectionView.dataSource = self
        
        view.addSubview(catCollectionView)
        
        catCollectionView.translatesAutoresizingMaskIntoConstraints = false
        catCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        catCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        catCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        catCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        do {
            try fetchResultController?.performFetch()
        } catch let error as NSError {
            print (error)
            return
        }
    }
}

extension FavouriteViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResultController?.sections?[section].objects?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = catCollectionView?.dequeueReusableCell(withReuseIdentifier: CatCollectionViewCell.identifier, for: indexPath) as! CatCollectionViewCell
        guard let catObject = fetchResultController?.object(at: indexPath) else { return UICollectionViewCell() }
        cell.addImageFromDB(Cat: catObject)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.allowsSelection = true
        collectionView.deselectItem(at: indexPath, animated: true)
        let catObject = fetchResultController?.object(at: indexPath)
        let detailViewController = DetailViewController()
        let detailVCCat = Cat(id: catObject?.id, url: catObject?.url, width: Int("\(String(describing: catObject?.width))") ?? 0, height: Int("\(String(describing: catObject?.height))") ?? 0)
        detailViewController.cat = detailVCCat
        detailViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
}

extension FavouriteViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async {
            self.catCollectionView?.reloadData()
        }
    }
}
