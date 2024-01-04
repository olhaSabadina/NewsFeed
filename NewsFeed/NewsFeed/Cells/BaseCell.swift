//
//  BaseCell.swift
//  NewsFeed
//
// Created by Olga Sabadina on 02.01.2024.
//

import UIKit

protocol BaseCellDelegate: AnyObject {
        func didTapButtonInCell(_ cell: BaseCell)
    }

class BaseCell: UITableViewCell {
    
    let channelLabel = UILabel()
    let newsTitleLabel = UILabel()
    let descriptionLabel = UILabel()
    var bookmarkButton = UIButton(type: .system)
    let newsImageView = UIImageView()
    
    weak var delegate: BaseCellDelegate?
    
    var newsModel: RssItem? {
        didSet {
            updateCell()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setChannelLabels()
        setBookmark()
        setNewsTitleLabel()
        setNewsImageView()
        setDescription()
        setLineView()
        setConstraints()
        backgroundColor = .clear
        contentView.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        channelLabel.text = ""
        newsTitleLabel.text = ""
        descriptionLabel.text = ""
        imageView?.image = nil
    }
    
    func setNewsImageView() {}
    func setDescription() {}
    func setLineView() {}
    func setConstraints() {}
    
    func updateCell() {
        configureChannelName()
        
        guard let newsModel else { return }
        newsTitleLabel.text = newsModel.newsTitle
        descriptionLabel.text = newsModel.newsDescription
        
        bookmarkButton.setImage(newsModel.isFavourite ? ImageConstants.bookmarkFavourite : ImageConstants.bookmark, for: .normal)
    }
    
    func configureChannelName() {
        var string = "\(newsModel?.nameChannel?.firstThreewords() ?? "") , "
        string.append(newsModel?.pubDate?.differenceDate() ?? "")
        channelLabel.text = string
    }
    
    func setNewsTitleLabel() {
        newsTitleLabel.textColor = .systemGray6
        newsTitleLabel.numberOfLines = 0
        newsTitleLabel.textAlignment = .left
        newsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        newsTitleLabel.font = .boldSystemFont(ofSize: 24)
        addSubview(newsTitleLabel)
    }
    
    private func setChannelLabels() {
        channelLabel.font = .systemFont(ofSize: 14)
        channelLabel.textColor = .systemGray6
        channelLabel.textAlignment = .left
        addSubview(channelLabel)
        channelLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setBookmark() {
        let action = UIAction { _ in
            self.delegate?.didTapButtonInCell(self)
        }
        bookmarkButton = UIButton(type: .system, primaryAction: action)
        bookmarkButton.tintColor = .systemGray6
        bookmarkButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bookmarkButton)
    }
}
