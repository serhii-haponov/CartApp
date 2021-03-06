//
//  ViewController.swift
//  CartApp
//
//  Created by SerhiiHaponov on 15.03.2021.
//

import UIKit
import CoreData

class CartListViewController: UICollectionViewController {
    
    private var blockOperations: [BlockOperation] = []
    var isStatusBarHidden = false
    
    override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }
    
    lazy var viewModel: CartListViewModel = {
        return CartListViewModel()
    }()
    
    lazy var activityView: ActivityView = {
        return ActivityView(loadingView: view)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initBinding()
        start()
        viewModel.dataSource?.fetchDataController?.fetchHandler?.delegate = self
        errorHandler()
    }
    
    func start() {
        viewModel.isLoading.value = true
        viewModel.isCollectionViewHidden.value = true
        updateTableContent { [weak self] in
            self?.viewModel.isLoading.value = false
            self?.viewModel.isCollectionViewHidden.value = false
        }
    }
    
    func initView() {
        view.backgroundColor = .white
    }
    
    func initBinding() {
        viewModel.isCollectionViewHidden.addObserver { [weak self] (isHidden) in
            self?.collectionView.isHidden = isHidden
        }
        viewModel.isLoading.addObserver { [weak self] (isLoading) in
            if isLoading {
                self?.activityView.loadingIdicator.startAnimating()
            } else {
                self?.activityView.loadingIdicator.stopAnimating()
            }
        }
    }
    
    private func updateTableContent(completion: @escaping () -> ()) {
        
        viewModel.performFetch()
        
        InternetMonitor().checkInternetConnection(completion: { result in
            
            switch result {
            case .Success(let hasInternet):
                if hasInternet {
                    self.viewModel.fetchCartData(completion: { (success) in
                        if success {
                            self.reloadCollectionViewInMainThread()
                        }
                    })
                }
            case .Error(let error):
                if let errorHandler = self.viewModel.errorHandling {
                    errorHandler(error)
                }
            }
            completion()
        })
    }
    
    private func reloadCollectionViewInMainThread() {
        if Thread.isMainThread {
            self.collectionView.reloadData()
        } else {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func errorHandler() {
        viewModel.errorHandling = { [weak self] errorMessage in
            DispatchQueue.main.async {
                let controller = UIAlertController(title: "Error!!!", message: errorMessage?.value, preferredStyle: .alert)
                controller.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
                guard let self = self else {
                    return
                }
                self.present(controller, animated: true, completion: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = sender as? IndexPath {
            if let product = viewModel.fetchObjectAtIndex(index: indexPath) {
                let viewController = segue.destination as? ProductDetailViewController
                viewController?.image = product.imageUrl
            }
        }
    }
    
    // MARK: - CollectionView delegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ProductDetailViewController", sender: indexPath)
    }
    
    // MARK: - CollectionView DataSource
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! ProductCollectionViewCell
        if let product = viewModel.fetchObjectAtIndex(index: indexPath) {
            cell.setWith(product: product)
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.fetchCountForView()
    }
    
    // MARK: - Deinit
    
    deinit {
        blockOperations.forEach { $0.cancel() }
        blockOperations.removeAll(keepingCapacity: false)
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension CartListViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            let op = BlockOperation { [weak self] in
                self?.collectionView.insertItems(at: [(newIndexPath as IndexPath)])
            }
            blockOperations.append(op)
            
        case .update:
            guard let newIndexPath = newIndexPath else { return }
            let op = BlockOperation { [weak self] in
                self?.collectionView.reloadItems(at: [(newIndexPath as IndexPath)])
            }
            blockOperations.append(op)
            
        case .move:
            guard let indexPath = indexPath else { return }
            guard let newIndexPath = newIndexPath else { return }
            let op = BlockOperation { [weak self] in
                self?.collectionView.moveItem(at: indexPath as IndexPath, to: newIndexPath as IndexPath)
            }
            blockOperations.append(op)
            
        case .delete:
            guard let indexPath = indexPath else { return }
            let op = BlockOperation { [weak self] in
                self?.collectionView.deleteItems(at: [(indexPath as IndexPath)])
            }
            blockOperations.append(op)
            
        @unknown default:
            fatalError()
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView.performBatchUpdates({
            self.blockOperations.forEach { $0.start() }
        }, completion: { finished in
            self.blockOperations.removeAll(keepingCapacity: false)
        })
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        blockOperations.removeAll(keepingCapacity: false)
    }
}

