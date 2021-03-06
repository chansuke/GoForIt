//
//  RecorderViewController.swift
//  GoForIt
//
//  Created by Lidner on 14/9/20.
//  Copyright (c) 2014 Solfanto. All rights reserved.
//

import UIKit
import AVFoundation

class RecorderViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    let recordButton = UIButton.buttonWithType(.Custom) as UIButton
    let replayButton = UIButton.buttonWithType(.Custom) as UIButton
    let cancelButton = UIButton.buttonWithType(.Custom) as UIButton
    let uploadButton = UIButton.buttonWithType(.Custom) as UIButton
    
    var recorder: AVAudioRecorder!
    var player: AVAudioPlayer!
    let session = AVAudioSession.sharedInstance()
    
    var go_label: UILabel!
    var for_it_label: UILabel!
    
    var outputFileURL = NSURL.fileURLWithPath(NSTemporaryDirectory().stringByAppendingPathComponent("newMessage.m4a"))
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.title = "Go for it!"
        
        go_label = UILabel(frame: CGRect(x: 0, y: self.view.frame.maxY / 3 - 140 / 2 + 20, width: self.view.frame.size.width, height: 140))
        go_label.text = "GO"
        go_label.textAlignment = .Center
        go_label.font = UIFont(name: "DINCondensed-Bold", size: 120.0)
        self.view.addSubview(go_label)
        
        for_it_label = UILabel(frame: CGRect(x: 0, y: self.view.frame.maxY * 2 / 3 - 140 / 2 + 20, width: self.view.frame.size.width, height: 140))
        for_it_label.text = "FOR IT!"
        for_it_label.textAlignment = .Center
        for_it_label.font = UIFont(name: "DINCondensed-Bold", size: 120.0)
        self.view.addSubview(for_it_label)
        
        recordButton.setImage(UIImage(named: "microphone"), forState: .Normal)
        recordButton.setImage(UIImage(named: "record_button"), forState: .Highlighted)
        recordButton.frame = CGRect(
            x: self.view.frame.midX - 140 / 2,
            y: self.view.frame.midY - 140 / 2,
            width: 140,
            height: 140
        )
        self.view.addSubview(recordButton)
        
        replayButton.setImage(UIImage(named: "replay_button"), forState: .Normal)
        replayButton.frame = CGRect(
            x: self.view.frame.midX - 60 / 2,
            y: self.view.frame.midY - 60 / 2,
            width: 60,
            height: 60
        )
        self.view.addSubview(replayButton)
        replayButton.hidden = true
        
        cancelButton.setImage(UIImage(named: "cancel_button"), forState: .Normal)
        cancelButton.frame = CGRect(
            x: self.view.frame.midX - 120,
            y: self.view.frame.midY - 60 / 2,
            width: 60,
            height: 60
        )
        self.view.addSubview(cancelButton)
        cancelButton.hidden = true
        
        uploadButton.setImage(UIImage(named: "upload_button"), forState: .Normal)
        uploadButton.frame = CGRect(
            x: self.view.frame.midX - 60 / 2,
            y: self.view.frame.midY - 120,
            width: 60,
            height: 60
        )
        self.view.addSubview(uploadButton)
        uploadButton.hidden = true
        
        recordButton.addTarget(self, action: "recordButtonPressed:", forControlEvents: .TouchDown)
        recordButton.addTarget(self, action: "recordButtonReleased:", forControlEvents: .TouchUpInside | .TouchUpOutside)
        replayButton.addTarget(self, action: "replayButtonTapped:", forControlEvents: .TouchUpInside)
        cancelButton.addTarget(self, action: "cancelButtonTapped:", forControlEvents: .TouchUpInside)
        uploadButton.addTarget(self, action: "uploadButtonTapped:", forControlEvents: .TouchUpInside)
        
        
        session.requestRecordPermission({(granted: Bool)-> Void in
            if granted {
                self.setupRecorder()
            } else {
                println("Permission to record not granted")
            }
        })
    }
    
    func setupRecorder() {
//        var pathComponents = [NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last as String, "newMessage.m4a"]
//        var outputFileURL = NSURL.fileURLWithPathComponents(pathComponents)
        
        NSLog("\(outputFileURL)")
        
        // Setup audio session
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        // Define the recorder setting
        var recordSettings = [
            AVFormatIDKey: kAudioFormatMPEG4AAC,
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 2
        ]
        
        // Initiate and prepare the recorder
        recorder = AVAudioRecorder(URL: outputFileURL, settings: recordSettings, error: nil)
        recorder.delegate = self
        recorder.meteringEnabled = true
        recorder.prepareToRecord()
        
        var recorderTimer = NSTimer.scheduledTimerWithTimeInterval(0.1,
            target: self,
            selector: "updateRecorderMeter:",
            userInfo: nil,
            repeats: true
        )
    }
    
    func recordButtonPressed(sender: UIButton) {
        if !recorder.recording {
            self.view.backgroundColor = UIColor.lightGrayColor()
            session.setActive(true, error: nil)
            
            // Start recording
            recorder.record()
            
        }
    }
    
    func recordButtonReleased(sender: UIButton) {
        if recorder.recording {
            recorder.stop()
            player = AVAudioPlayer(contentsOfURL: recorder.url, error: nil)
            player.delegate = self
            session.setActive(false, error: nil)
            
            recordButton.hidden = true
            cancelButton.hidden = false
            replayButton.hidden = false
            uploadButton.hidden = false
        }
    }
    
    func replayButtonTapped(sender: UIButton) {
        if !recorder.recording && !player.playing {
            player.play()
        }
        else {
            player.pause()
        }
    }
    
    func cancelButtonTapped(sender: UIButton) {
        self.view.backgroundColor = UIColor.whiteColor()
        
        recordButton.hidden = false
        replayButton.hidden = true
        cancelButton.hidden = true
        uploadButton.hidden = true
    }
    
    func updateRecorderMeter(timer:NSTimer) {
        if recorder.recording {
            let dFormat = "%02d"
            let min:Int = Int(recorder.currentTime / 60)
            let sec:Int = Int(recorder.currentTime % 60)
            let time = "\(String(format: dFormat, min)):\(String(format: dFormat, sec))"
            recorder.updateMeters()
            var apc0 = recorder.averagePowerForChannel(0)
//            var peak0 = recorder.peakPowerForChannel(0)
            NSLog("\(time)")
        }
    }
    
    func uploadButtonTapped(sender: UIButton) {
        uploadButton.enabled = false
        let manager = AFHTTPRequestOperationManager()
        var parameters = ["uuid": Authentication.sharedInstance.uuid()]
        
        manager.POST("http://localhost:3000/cheeringup.json", parameters: parameters,
            constructingBodyWithBlock: { (formData: AFMultipartFormData!) in
                let data = NSData(contentsOfURL: self.outputFileURL!)
                formData.appendPartWithFileData(data, name: "cheeringup[audio_record]", fileName: "cheeringup.m4a", mimeType: "audio/m4a")
            },
            success: { operation, response in
                println("[success] operation: \(operation), response: \(response)")
                self.recordButton.hidden = false
                self.replayButton.hidden = true
                self.cancelButton.hidden = true
                self.uploadButton.hidden = true
                self.uploadButton.enabled = true
            },
            failure: { operation, error in
                println("[fail] operation: \(operation), error: \(error)")
                self.uploadButton.enabled = true
            }
        )
    }
    
}
