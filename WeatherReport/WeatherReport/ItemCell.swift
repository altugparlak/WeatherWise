//
//  ItemCell.swift
//  WeatherReport
//
//  Created by Altug Parlak on 5.08.2023.
//

import UIKit

class ItemCell: UITableViewCell {

    var title: String? = nil
    {
        didSet {
            if oldValue != title {
                setNeedsUpdateConfiguration()
            }
        }
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        var content = defaultContentConfiguration().updated(for: state)

        content.text = title

        self.contentConfiguration = content
    }

}
