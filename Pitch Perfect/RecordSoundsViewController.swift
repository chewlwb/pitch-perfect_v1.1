//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Bernard Chew on 12/5/15.
//  Copyright (c) 2015 BCHEW. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingInfoPrompt: UILabel!
    @IBOutlet weak var stopRecording: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    let beforeRecordingPrompt = "Tap to Record"
    let duringRecordingPrompt = "Recording In Progress"
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    var filePath:NSURL!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        recordingInfoPrompt.text = beforeRecordingPrompt
        recordingInfoPrompt.hidden = false
        stopRecording.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: (UIStoryboardSegue!), sender: AnyObject!) {
        // if the segue is from finishRecording (stopRecording) event,
        // set up the receivedAudio var in playSoundsViewController to
        // the recordedAudio info (filepath & title)
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let dataToSend = sender as! RecordedAudio
            playSoundsVC.receivedAudio = dataToSend
        }
    }

    @IBAction func recordAudio(sender: UIButton) {
        // Show text "Recording in Progress"
        recordButton.enabled = false
        recordingInfoPrompt.text = duringRecordingPrompt
        recordingInfoPrompt.hidden = false
        stopRecording.hidden = false
        println("in recordAudio")
        
        // Record the user's voice
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)

        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            // Finished recording, so save the clip
            recordedAudio = RecordedAudio(title : recorder.url.lastPathComponent!, filePathUrl : recorder.url)
        
            // Perform the Segue & move to next scene (play audio)
            println("In performSegue")
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else {
            println("Recording was unsuccessful!")
        }
    }

    @IBAction func stopRecordingButton(sender: UIButton) {
        // Hide text "Recording in Progress"
        recordingInfoPrompt.text = beforeRecordingPrompt
        stopRecording.hidden = true
        println("in stopRecordingButton")
        
        // Stop the Recording
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        
        // re-enable the record button for next recording
        recordButton.enabled = true
    }
}

