//
//  MovieCollectionViewCell.swift
//  MovieDBExample
//
//  Created by Suleman Ali on 14/02/2024.
//

import UIKit
import Nuke

class MovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var movieImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func config(movie:MoviesResponse){
        let url =  movie.posterURL
        let request = ImageRequest(url: url)
        var options = ImageLoadingOptions(transition: nil)
        options.pipeline = .none
        Nuke.loadImage(with: request,into: movieImageView)
    }

}
