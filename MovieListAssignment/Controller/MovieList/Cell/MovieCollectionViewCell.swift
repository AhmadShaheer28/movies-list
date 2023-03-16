//
//  MovieCollectionViewCell.swift
//  MovieListAssignment
//
//  Created by Ahmad Shaheer on 11/03/2023.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {

    //MARK: - Outlets
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var posterIV: UIImageView!
    @IBOutlet weak var movieNameLbl: UILabel!
    @IBOutlet weak var releaseDateLbl: UILabel!
    @IBOutlet weak var favBtn: UIButton!
    
    
    var favTapped: ((Int) -> Void)?
    
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        mainView.backgroundColor = .white
        mainView.layer.cornerRadius = 12
        mainView.clipsToBounds = true
    }
    
    //MARK: - Action
    
    @IBAction func favBtnAction(_ sender: UIButton) {
        favTapped?(sender.tag)
    }
    
    //MARK: - Methods
    
    func config(movie: Movie) {
        
        if let imgUrl = URL(string: ApiRequest.posterUrl + (movie.posterPath ?? "")) {
            posterIV.getImage(from: imgUrl)
        } else {
            posterIV.image = UIImage(named: "placeholder")
        }
        
        let isFav = DBManager.shared.isFavMovie(movie: movie)
        
        favBtn.setImage(isFav ? UIImage(named: "is.fav") : UIImage(named: "not.fav"), for: .normal)
        
        movieNameLbl.text = movie.title
        releaseDateLbl.text = movie.releaseDate
    }

}
