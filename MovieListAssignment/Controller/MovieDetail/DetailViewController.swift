//
//  DetailViewController.swift
//  MovieListAssignment
//
//  Created by Ahmad Shaheer on 11/03/2023.
//

import UIKit

class DetailViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var releaseDateLbl: UILabel!
    @IBOutlet weak var posterIV: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var overviewLbl: UILabel!
    @IBOutlet weak var favBtn: UIButton!
    
    
    //MARK: - Variables
    
    var movie: Movie?
    private var isFav = false
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
    //MARK: - View Setup
    func setupView() {
        
        if let mov = movie {
            
            title = mov.title
            
            isFav = DBManager.shared.isFavMovie(movie: mov)
            
            favBtn.setImage(isFav ? UIImage(named: "is.fav") : UIImage(named: "not.fav"), for: .normal)
            
            if let imgUrl = URL(string: ApiRequest.posterUrl + mov.posterPath) {
                posterIV.getImage(from: imgUrl)
            }
            
            titleLbl.text = mov.originalTitle
            releaseDateLbl.text = mov.releaseDate
            overviewLbl.text = mov.overview
        }
    }
    
        
    
    //MARK: - Actions
    
    @IBAction func favBtnAction(_ sender: Any) {
        if isFav {
            DBManager.shared.deleteFavMovie(movie: movie!)
            isFav = false
            favBtn.setImage(UIImage(named: "not.fav"), for: .normal)
        } else {
            DBManager.shared.saveFavMovie(movie: movie!)
            isFav = true
            favBtn.setImage(UIImage(named: "is.fav"), for: .normal)
        }
    }
    
    
    //MARK: - Methods
    
}
