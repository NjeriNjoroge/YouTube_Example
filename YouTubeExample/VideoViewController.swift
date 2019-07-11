//
//  VideoViewController.swift
//  YouTubeExample
//
//  Created by Grace Njoroge on 11/07/2019.
//  Copyright © 2019 Grace. All rights reserved.
//

import UIKit
import XCDYouTubeKit
import AVKit

class VideoViewController: UIViewController {
  
  let videoURL = "https://www.youtube.com/watch?v=8bWR26jF7qM&list=PLtMSzkAUZN3g0ETV21jTRZ6c0_PNx3eRB"
  
  lazy var videoButton: UIButton = {
    let btn = UIButton()
    btn.backgroundColor = .blue
    btn.translatesAutoresizingMaskIntoConstraints = false
    btn.setTitle("Open YouTube", for: .normal)
    btn.addTarget(self, action: #selector(openVideo), for: .touchUpInside)
    return btn
  }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
      
      //place button in view
        view.addSubview(videoButton)
        NSLayoutConstraint.activate([
          videoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
          videoButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
          ])
    }
  
  
  @objc func openVideo() {
    //        let testId = "DkeiKbqa02g" // Dua Lipa
    //        self.playVideo(videoIdentifier: testId)
    
    //if let recipe = self.recipe, let youtube = recipe.youtube {
      // open in native player in app
      // RETURNED VIDEO IS NOT AN ID BUT THE URL, SO OPEN YOUTUBE
      self.openYoutube(url: videoURL)
      //self.playVideo(videoIdentifier: youtube)
   // } else {
      //no video
      
    //}
  }
  
  func openYoutube(url: String) {
    
    var youtubeUrl = "http://www.youtube.com/watch?v=\(url)"
    if url.contains("www.youtube.com") {
      youtubeUrl = url
    }
    //open outside app
    if !youtubeUrl.isEmpty {
      let appURL = NSURL(string: youtubeUrl.replacingOccurrences(of: "https", with: "youtube"))!
      let webURL = NSURL(string: youtubeUrl)!
      let application = UIApplication.shared
      
      if application.canOpenURL(appURL as URL) {
        if #available(iOS 10.0, *) {
          application.open(appURL as URL)
        } else {
          // Fallback on earlier versions
          application.openURL(appURL as URL)
        }
      } else {
        // if Youtube app is not installed, open URL inside Safari
        if #available(iOS 10.0, *) {
          application.open(webURL as URL)
        } else {
          // Fallback on earlier versions
          application.openURL(webURL as URL)
        }
      }
    } else {
      let alert = UIAlertController(title: "", message: "The YouTube video cannot be found. Sorry for the inconvenience.", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        NSLog("The \"OK\" alert occured.")
      }))
      self.present(alert, animated: true, completion: nil)
    }
  }
  
  func playVideo(videoIdentifier: String?) {
    let playerViewController = AVPlayerViewController()
    self.present(playerViewController, animated: true, completion: nil)
    
    XCDYouTubeClient.default().getVideoWithIdentifier(videoIdentifier) { [weak playerViewController] (video: XCDYouTubeVideo?, error: Error?) in
      if let streamURLs = video?.streamURLs, let streamURL = (streamURLs[XCDYouTubeVideoQualityHTTPLiveStreaming] ?? streamURLs[YouTubeVideoQuality.hd720] ?? streamURLs[YouTubeVideoQuality.medium360] ?? streamURLs[YouTubeVideoQuality.small240]) {
        playerViewController?.player = AVPlayer(url: streamURL)
      } else {
        self.dismiss(animated: true, completion: nil)
      }
    }
  }
  
  struct YouTubeVideoQuality {
    static let hd720 = NSNumber(value: XCDYouTubeVideoQuality.HD720.rawValue)
    static let medium360 = NSNumber(value: XCDYouTubeVideoQuality.medium360.rawValue)
    static let small240 = NSNumber(value: XCDYouTubeVideoQuality.small240.rawValue)
  }


}
