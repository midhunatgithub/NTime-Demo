//
//  NewsTableViewCell.swift
//  NYTimesDemo
//
//  Created by mithun s on 8/30/19.
//  Copyright © 2019 Midhun P. Mathew. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var abstractLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

}
extension NewsTableViewCell {
    
    func configure(withModel model: NewsCellViewModel) {
        headingLabel.text = model.heading
        abstractLabel.text = model.abstract
        authorLabel.text = model.author
        dateLabel.text = model.date
    }
}
