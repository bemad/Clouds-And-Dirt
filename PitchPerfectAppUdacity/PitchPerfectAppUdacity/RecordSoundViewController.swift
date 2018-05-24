//
//  ViewController.swift
//  PitchPerfectAppUdacity
//
//  Created by Bhavya Madan on 01/06/17.
//  Copyright © 2017 Bhavya Madan. All rights reserved.
//

import UIKit
import AVFoundation
class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder: AVAudioRecorder!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    override func viewWillAppear(_ animated: Bool) {
        stopButton.isEnabled=false
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func recordAudio(_ sender: Any) {
        configureUI(isRecording: true)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    func configureUI(isRecording: Bool) {
        recordButton.isEnabled = !isRecording
        stopButton.isEnabled = isRecording
        if(isRecording){
            recordingLabel.text = "Recording in prog."}
        else{
        recordingLabel.text = "Tap To Record"
        }
    }
    @IBAction func stopRecording(_ sender: Any) {
        configureUI(isRecording: false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
        else{
            print("Rec Failed ")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundVC = segue.destination as! PlaySoundViewController
            let recorderAudioURL = sender as! URL
            playSoundVC.recordedAudioURL = recorderAudioURL
        
        
        
        }
    }

}

