//
//  NativeAdViewProg.swift
//  NewsFeed
//
//  Created by Yura Sabadin on 29.12.2023.
//

import GoogleMobileAds
import UIKit

/// Programmatically create NativeAdView instead of from XIB.
final class NativeAdViewProg : GADNativeAdView {
    private let icon: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 40),
            imageView.widthAnchor.constraint(equalToConstant: 40)
        ])
        return imageView
    }()
   
    private let advertiserLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.contentMode = .left
        label.text = "Advertiser"
        label.lineBreakMode = .byTruncatingTail
        label.baselineAdjustment = .alignBaselines
        label.adjustsFontSizeToFitWidth = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let adRatingView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = false
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 17),
            imageView.widthAnchor.constraint(equalToConstant: 100)
        ])
        return imageView
    }()
    
    private let adDescription: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.contentMode = .left
        label.setContentCompressionResistancePriority(UILayoutPriority(751), for: .vertical)
        label.text = "Body that is really really long and can take up to two lines or sometimes even more."
        label.textAlignment = .justified
        label.lineBreakMode = .byTruncatingTail
        label.baselineAdjustment = .alignBaselines
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.isUserInteractionEnabled = false
        button.contentMode = .scaleToFill
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.titleLabel?.lineBreakMode = .byTruncatingMiddle
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.setTitle("Install", for: .normal)
        button.setTitleShadowColor(UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let price: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.contentMode = .left
        label.setContentHuggingPriority(UILayoutPriority(251), for: .vertical)
        label.text = "Price"
        label.lineBreakMode = .byTruncatingTail
        label.baselineAdjustment = .alignBaselines
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkText
        label.adjustsFontSizeToFitWidth = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let store: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.contentMode = .left
        label.setContentHuggingPriority(UILayoutPriority(251), for: .vertical)
        label.text = "Store"
        label.lineBreakMode = .byTruncatingTail
        label.baselineAdjustment = .alignBaselines
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkText
        label.adjustsFontSizeToFitWidth = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let headline: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.contentMode = .left
        label.setContentHuggingPriority(UILayoutPriority(251), for: .vertical)
        label.setContentCompressionResistancePriority(UILayoutPriority(751), for: .horizontal)
        label.text = "Headline"
        label.lineBreakMode = .byTruncatingTail
        label.baselineAdjustment = .alignBaselines
        label.adjustsFontSizeToFitWidth = false
        label.font = .systemFont(ofSize: 17)
        label.textColor = .darkText
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.heightAnchor.constraint(equalToConstant: 20.5).isActive = true
        return label
    }()
    
    private let adMediaView: GADMediaView = {
        let mediaView = GADMediaView()
        mediaView.contentMode = .scaleAspectFit
        mediaView.translatesAutoresizingMaskIntoConstraints = false
        
        let heightConstraint = mediaView.heightAnchor.constraint(equalToConstant: 150)
        heightConstraint.isActive = true
        heightConstraint.priority = UILayoutPriority(999)
        mediaView.widthAnchor.constraint(equalToConstant: 250).isActive = true
        return mediaView
    }()
    
    private let adIndicator: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.contentMode = .left
        label.setContentHuggingPriority(UILayoutPriority(251), for: .vertical)
        label.setContentHuggingPriority(UILayoutPriority(251), for: .horizontal)
        label.textAlignment = .natural
        label.text = "Ad"
        label.lineBreakMode = .byTruncatingTail
        label.baselineAdjustment = .alignBaselines
        label.adjustsFontSizeToFitWidth = false
        label.backgroundColor = UIColor(red: 1, green: 0.8, blue: 0.4, alpha: 1)
        label.font = .systemFont(ofSize: 11, weight: .semibold)
        label.textColor = UIColor(white: 1, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 15).isActive = true
        label.widthAnchor.constraint(greaterThanOrEqualToConstant: 15).isActive = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(icon)
        addSubview(advertiserLabel)
        addSubview(adRatingView)
        addSubview(adDescription)
        addSubview(button)
        addSubview(price)
        addSubview(store)
        addSubview(headline)
        addSubview(adMediaView)
        addSubview(adIndicator)
        
        NSLayoutConstraint.activate([
            adIndicator.topAnchor.constraint(equalTo: topAnchor),
            adIndicator.leadingAnchor.constraint(equalTo: leadingAnchor),
            adIndicator.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -8),
           
            icon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            icon.bottomAnchor.constraint(equalTo: adRatingView.bottomAnchor),
            icon.leadingAnchor.constraint(equalTo: adDescription.leadingAnchor),
            
            headline.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            headline.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 8),
            headline.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            
            adDescription.topAnchor.constraint(greaterThanOrEqualTo: icon.bottomAnchor),
            adDescription.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            adDescription.topAnchor.constraint(equalTo: adRatingView.bottomAnchor, constant: 8),
            
            advertiserLabel.leadingAnchor.constraint(equalTo: headline.leadingAnchor),
            advertiserLabel.centerYAnchor.constraint(equalTo: adRatingView.centerYAnchor),
            
            adMediaView.centerXAnchor.constraint(equalTo: centerXAnchor),
            adMediaView.topAnchor.constraint(equalTo: adDescription.bottomAnchor, constant: 5),
            
            adRatingView.topAnchor.constraint(equalTo: headline.bottomAnchor, constant: 8),
            adRatingView.leadingAnchor.constraint(equalTo: advertiserLabel.trailingAnchor),
            
            price.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 8),
            price.centerYAnchor.constraint(equalTo: store.centerYAnchor),
            price.topAnchor.constraint(equalTo: adMediaView.bottomAnchor, constant: 15.5),
            
            store.leadingAnchor.constraint(equalTo: price.trailingAnchor, constant: 10),
            
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            button.leadingAnchor.constraint(equalTo: store.trailingAnchor, constant: 10),
            button.centerYAnchor.constraint(equalTo: store.centerYAnchor),
            button.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -8)
        ])
        
        headlineView = headline
        callToActionView = button
        iconView = icon
        bodyView = adDescription
        storeView = store
        priceView = price
        starRatingView = adRatingView
        advertiserView = advertiserLabel
        mediaView = adMediaView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
