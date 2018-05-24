//
//  YTVideoViewController.swift
//  TechWishList
//
//  Created by Bhavya Madan on 20/02/18.
//  Copyright © 2018 Bhavya Madan. All rights reserved.
//

import Foundation
import UIKit

class YTVideoViewController: UIViewController {
    var youtubeVideo: YoutubeVideo?
    @IBOutlet weak var videoTitleLabel: UILabel!
    @IBOutlet weak var youtubePlayer: YTPlayerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        youtubePlayer.delegate = self
        if let youtubeVideo = youtubeVideo {
            let playerVars = ["playsinline":1]
            youtubePlayer.load(withVideoId: youtubeVideo.videoId, playerVars: playerVars)
            videoTitleLabel.text = youtubeVideo.title
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        testNetworkConnectionToYouTube()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddTechFromYouTubeVideo" {
            let destinationController = segue.destination as! AddTechViewController
            destinationController.youtubeVideo = youtubeVideo
        }
    }
    func testNetworkConnectionToYouTube() {
        do {
            Network.reachability = try Reachability(hostname: "www.youtube.com")
            do {
                try Network.reachability?.start()
            } catch let error as Network.Error {
                print(error)
                displayConnectionErrorAlert()
            } catch {
                print(error)
                displayConnectionErrorAlert()
            }
        } catch {
            print(error)
            displayConnectionErrorAlert()
        }
    }
    func displayConnectionErrorAlert() {
        let alert = UIAlertController(title: "Connection Error", message: "Unable to connect to YouTube to play this video.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: "Default action"), style: .`default`, handler: { _ in
            print(" The \"Connection Error\" alert occured ")
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
extension YTVideoViewController: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        youtubePlayer.playVideo()
    }
}
