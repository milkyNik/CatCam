//
//  ViewController.swift
//  CatCam
//
//  Created by Nikita Milko on 08.09.2020.
//  Copyright © 2020 Nikita Milko. All rights reserved.
//

import Cocoa
import AgoraRtcKit

class ViewController: NSViewController {

    @IBOutlet weak var remoteVideoView: NSView!
    @IBOutlet weak var localVideoView: NSView!
    
    private let appID = "5750874a9ff3449a89758408d1d546f2"
    private let token = "0065750874a9ff3449a89758408d1d546f2IACJF+K90EBOcRfro3YQUv+L9cFcf7/Fp9OBFdZDvhDAZ4d/zXwAAAAAEACe2t6IevtXXwEAAQB6+1df"
    private let channel = "CatcamChanel"
    
    private var agoraKit: AgoraRtcEngineKit?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeAgoraEngine()
        setupVideo()
        setupLocalVideo()
        
        joinChannel()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    // MARK: Agora
    
    func initializeAgoraEngine() {
       // Initialize the AgoraRtcEngineKit object.
       agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: appID, delegate: self)
    }
    
    func setupVideo() {
        // Enable the video
        agoraKit?.enableVideo()
    }
    
    func setupLocalVideo() {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = 0
        videoCanvas.view = localVideoView
        videoCanvas.renderMode = .hidden
        // Set the local video view.
        agoraKit?.setupLocalVideo(videoCanvas)
    }
    
    @IBAction func stopAction(_ sender: Any) {
        agoraKit?.setupLocalVideo(nil)
        agoraKit?.leaveChannel(nil)
        agoraKit?.stopPreview()
    }
    
    func joinChannel() {
        agoraKit?.startPreview()
        // Join a channel with a token.
        agoraKit?.joinChannel(byToken: token, channelId: channel, info: nil, uid: 0, joinSuccess: nil)
        
    }
}

extension ViewController: AgoraRtcEngineDelegate {
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoDecodedOfUid uid:UInt, size:CGSize, elapsed:Int) {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.view = remoteVideoView
        videoCanvas.renderMode = .hidden
        // Set the remote video view.
        agoraKit?.setupRemoteVideo(videoCanvas)
    }
}

