//
//  DetailsViewFlowlayout.swift
//  MovieDBExample
//
//  Created by Suleman Ali on 16/02/2024.
//

import Foundation
import UIKit

class DetailsViewFlowlayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        itemSize = collectionView.frame.size // Square cells, adjust height as needed
        sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
