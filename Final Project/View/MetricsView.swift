import UIKit

class HealthTableCell: UITableViewCell {

    // UI elements for the cell
    let titleLabel = UILabel()
    let valueLabel = UILabel()
    let arrowImageView = UIImageView()

    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // Configure the UI elements
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        titleLabel.textColor = .label
        
        valueLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        valueLabel.textColor = .secondaryLabel
        
        arrowImageView.image = UIImage(systemName: "chevron.right")
        arrowImageView.tintColor = .systemGray3

        // Add the UI elements to the cell's content view
        contentView.addSubview(titleLabel)
        contentView.addSubview(valueLabel)
        contentView.addSubview(arrowImageView)
        
        // Configure the constraints for the UI elements
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true

        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor, constant: -8).isActive = true
        valueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true

        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        arrowImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
