//
//  TableViewCell.swift
//  Movie Data
//
//  Created by Константин Малков on 24.06.2022.
//
//отредактировать строку с данными при получении запроса
import UIKit


class MovieTableViewCell: UITableViewCell {

    static let identifier = "MovieTableViewCell"
    
    @IBOutlet var movieTitle: UILabel!
    @IBOutlet var movieYear: UILabel!
    @IBOutlet var moviePoster :UIImageView!
    @IBOutlet var movieType: UILabel!
    @IBOutlet var movieRatingKP: UILabel!
    @IBOutlet var movieRatingIMDB: UILabel!
    @IBOutlet var movieDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with model: Docs) {
        self.movieTitle.text = model.name
        self.movieYear.text = "Релиз: " + String(model.year)
        self.movieType.text = model.type
        self.movieRatingKP.text = "Кинопоиск: " + String(model.rating.kp)
        self.movieRatingIMDB.text = "IMDb: "+String(model.rating.imdb)
        self.movieDescription.text = model.description ?? "Описания пока нет, но скоро Кинопоиск все исправит."
        guard let url = model.poster.url else {
            return
        }
        if let data = try? Data(contentsOf: URL(string: url)!) {
            self.moviePoster.image = UIImage(data: data)
        }
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "MovieTableViewCell", bundle: nil)
    }
    
}
