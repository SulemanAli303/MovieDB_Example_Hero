//
//  ViewController.swift
//  MovieDBExample
//
//  Created by Suleman Ali on 14/02/2024.
//

import UIKit
import Nuke
import Hero

class VideoViewController: UIViewController {

    @IBOutlet private weak var movieCollectionView:UICollectionView!
    private let cellIdentifier = "MovieCollectionViewCell"
    let viewModel = MoviesViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.movieCollectionView!.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.movieCollectionView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        viewModel.delegate = self
        super.viewWillAppear(animated)
        enableHero()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        disableHero()
    }
}

extension VideoViewController:MoviesViewModelUpdateDelegate {
    func didMoviesUpdate(_ oldMoviesCount:Int,_ moviesCount:Int) {
        guard  oldMoviesCount > 0 else {return}
            let indexPaths = (oldMoviesCount..<oldMoviesCount + moviesCount).map { IndexPath(item: $0, section: 0) }
            self.movieCollectionView.performBatchUpdates({
                self.movieCollectionView.insertItems(at: indexPaths)
            }, completion: {_ in
            })
    }
}

extension VideoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {


    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(IndexPath(item: viewModel.movies.count-1, section: 0)) {
            viewModel.loadMoreMovied()
        }
    }
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        let urls = indexPaths.map { viewModel.movies[$0.row] }
        viewModel.stopPrefetching(with: urls)
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movies.count
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! MovieCollectionViewCell
        let movie = viewModel.movies[indexPath.row]
        cell.heroID = "hero\(indexPath.row)"
        cell.config(movie: movie)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let vc = sb.instantiateViewController(withIdentifier: "MovieRealsCollectionViewController") as? MovieRealsCollectionViewController {
            vc.viewModel = self.viewModel
            vc.selectedIndexPath = indexPath
            self.showHero(vc)
        }
    }
}
extension VideoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthOfCollectionView = collectionView.bounds.width
        let widthOfItem = (widthOfCollectionView - 40)/2 // 10| item | 20 | item |10
        return CGSize(width: widthOfItem, height: widthOfItem)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension VideoViewController:PinterestLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightForPhotoAt indexPath: IndexPath, with width: CGFloat) -> CGFloat {
        let widthOfCollectionView = collectionView.bounds.width
        let widthOfItem = (widthOfCollectionView - 40)/2 // 10| item | 20 | item |10
        return widthOfItem
    }
}

