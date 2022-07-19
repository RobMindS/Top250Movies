//
//  DetailViewController.swift
//  Top250Movies
//
//  Created by admin on 18.07.2022.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var imDbRatingLabel: UILabel!
    @IBOutlet weak var imDbRatingCountLabel: UILabel!
    @IBOutlet weak var crewLabel: UILabel!
    
    var movie: TopMovies?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setViews()
    }
    
    func setViews() {
        guard let data = movie else { return }
        nameLabel.text = data.fullTitle
        posterImageView.downloaded(from: data.image)
        imDbRatingLabel.text = "Rating: " + data.imDbRating
        imDbRatingCountLabel.text = "Rating count: " + data.imDbRatingCount
        crewLabel.text = "Crew: " + data.crew
    }
    
    
    @IBAction func checkDuplicatesAction(_ sender: UIButton) {
        guard let data = movie else { return }
        let str = data.fullTitle
        var dict : [Character : Int] = [:]
        let newstr = str.replacingOccurrences(of: " ", with: "")
        for i in newstr {
            if dict[i] == nil {
                dict[i] = 1
            } else {
                dict[i]! += 1
            }
        }
        showAlertContinue(text: "\(dict)")
    }
    
    func showAlertContinue(text: String) {
        let alertController = UIAlertController(title: "Duplicates:", message: text, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            alertController.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
