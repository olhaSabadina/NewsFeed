//
//  GoogleAdManager.swift
//  NewsFeed
//
//  Created by Yura Sabadin on 29.12.2023.
//

import UIKit
import GoogleMobileAds

protocol NativeAdProtocol: AnyObject {
    func nativeAdLoader(ad: GADNativeAd)
    func failToLoadNativeAd()
}

class GoogleAdManager: NSObject {
    
    static let shared = GoogleAdManager()
    var delegateForNativeAd: NativeAdProtocol?
    var adLoaderForNativeAd: GADAdLoader? //!
    
    var nativeAdForBottomScreen: GADNativeAdView? //!
    var nativeAD: GADNativeAd?
    var unitID: String = "ca-app-pub-3940256099942544/3986624511"
    
    func requestForNativeAdd(rootVC: UIViewController) {
        adLoaderForNativeAd = GADAdLoader(adUnitID: unitID, rootViewController: rootVC, adTypes: [.native], options: nil)
        adLoaderForNativeAd?.delegate = self
        adLoaderForNativeAd?.load(GADRequest())
    }
    
    func displayNativeAd(nativeAd: GADNativeAd, nativeAdView: GADNativeAdView) {
        (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
        let mediaContent = nativeAd.mediaContent
        if mediaContent.hasVideoContent {
            mediaContent.videoController.delegate = self
        }
        nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent
        nativeAdView.mediaView?.contentMode = .scaleAspectFit
        (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
        nativeAdView.bodyView?.isHidden = nativeAd.body == nil
        
        (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
        nativeAdView.callToActionView?.isHidden = nativeAd.callToAction == nil
        
        (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
        if let _ = nativeAdView.advertiserView {
            nativeAdView.advertiserView?.isHidden = nativeAd.icon == nil
            nativeAdView.advertiserView?.frame = CGRect(x: nativeAdView.advertiserView!.frame.origin.x, y: nativeAdView.advertiserView!.frame.origin.y, width: nativeAdView.advertiserView!.frame.height, height: nativeAdView.advertiserView!.frame.height)
        }
        nativeAdView.advertiserView?.isHidden = false
        nativeAdView.nativeAd = nativeAd
    }
    
}
    
extension GoogleAdManager: GADAdLoaderDelegate, GADVideoControllerDelegate, GADNativeAdLoaderDelegate {

    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        if delegateForNativeAd != nil {
            delegateForNativeAd?.failToLoadNativeAd()
            return
        }
    }
    
    func videoControllerDidEndVideoPlayback(_ videoController: GADVideoController) {
        print("endVideo")
    }
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        if delegateForNativeAd != nil {
            delegateForNativeAd?.nativeAdLoader(ad: nativeAd)
        }
    }
}
