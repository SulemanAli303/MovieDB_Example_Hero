//
//  MovieRealsCollectionViewController.swift
//  MovieDBExample
//
//  Created by Suleman Ali on 14/02/2024.
//

import UIKit
import Nuke

class MovieRealsCollectionViewController: UICollectionViewController {


    private let cellIdentifier = "MovieDetailViewCell"
    var viewModel:MoviesViewModel!
    var selectedIndexPath:IndexPath!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(UINib(nibName: "MovieDetailViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        collectionView.scrollToItem(at: selectedIndexPath, at: .left, animated: false)
        viewModel.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        enableHero()

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        disableHero()
    }
}

// MARK: UICollectionViewDataSource
extension MovieRealsCollectionViewController: UICollectionViewDataSourcePrefetching {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movies.count
    }

    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(IndexPath(item: viewModel.movies.count-1, section: 0)) {
            viewModel.loadMoreMovied()
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! MovieDetailViewCell
        cell.tag = indexPath.row
        let movie = viewModel.movies[indexPath.row]
        cell.heroID = "hero\(indexPath.row)"
        cell.config(movie: movie)
        return cell
    }
}


extension MovieRealsCollectionViewController:MoviesViewModelUpdateDelegate {
    func didMoviesUpdate(_ oldMoviesCount: Int, _ newMoviesCount: Int) {
        let indexPaths = (oldMoviesCount..<oldMoviesCount + newMoviesCount).map { IndexPath(item: $0, section: 0)}
        self.collectionView.performBatchUpdates({
            self.collectionView.insertItems(at: indexPaths)
        }, completion: {_ in
        })
    }
}
