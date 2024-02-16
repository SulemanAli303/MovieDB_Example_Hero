//
//  MovieDetailViewCell.swift
//  MovieDBExample
//
//  Created by Suleman Ali on 16/02/2024.
//

import UIKit
import Nuke

class MovieDetailViewCell: UICollectionViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backdropImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func config(movie:MoviesResponse){
        descriptionLabel.text = movie.overview
        titleLabel.text =  movie.originalTitle
        let url =  movie.posterURL
        let request = ImageRequest(url: url)
        var options = ImageLoadingOptions(transition: nil)
        options.pipeline = .none
        Nuke.loadImage(with: request,into: backdropImageView)
    }
}
