//
//  MoviesViewModel.swift
//  MovieDBExample
//
//  Created by Suleman Ali on 14/02/2024.
//

import Foundation
import Nuke
protocol MoviesViewModelUpdateDelegate {
    func didMoviesUpdate(_ oldMoviesCount:Int,_ newMoviesCount:Int)
}
class MoviesViewModel {
    @Published var movies:[MoviesResponse] = []
    var currentPosition:IndexPath = IndexPath(item: 0, section: 0)
    var delegate:MoviesViewModelUpdateDelegate?
    private let prefetcher = ImagePrefetcher()
    var page = 0
    var totalPages = 1
    init() {
        loadMoreMovied()
    }
    func loadMoreMovied() {
        self.page += 1
        guard totalPages >= page else {return}
        ApiService.shared.getRequest(endPoint: "/3/movie/now_playing", queryParams: ["page":"\(page)"], completionHandler: { (result: Result<BaseResponse<MoviesResponse>, Error>) in
            switch result {
                case .success(let response):
                    self.startPrefetching(with:response.results)
                    self.totalPages = response.totalPages
                    let oleMoviesCount = self.movies.count
                    self.movies.append(contentsOf: response.results)
                    DispatchQueue.main.async {
                        self.prefetcher.isPaused = false
                        self.delegate?.didMoviesUpdate(oleMoviesCount,response.results.count)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        })
    }

   private func startPrefetching(with: [MoviesResponse]) {
       prefetcher.startPrefetching(with:with.map{$0.posterURL})
    }

    func stopPrefetching(with: [MoviesResponse]) {
        prefetcher.stopPrefetching(with:with.map{$0.posterURL})
    }
}
