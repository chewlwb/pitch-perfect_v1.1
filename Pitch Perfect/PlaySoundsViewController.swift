//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Bernard Chew on 17/5/15.
//  Copyright (c) 2015 BCHEW. All rights reserved.
//
import Foundation
import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioEngine : AVAudioEngine!
    var audioFile   : AVAudioFile!
    
    var audioPlayer : AVAudioPlayer!
    var receivedAudio : RecordedAudio!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        // init audioEngine & audioFile objects
        audioEngine = AVAudioEngine()
        audioFile   = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        
        // print the recordedFilePath from previous view
        println("In PlaySounds")
        println(receivedAudio.filePathUrl)
        println(receivedAudio.title)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playFast(sender: UIButton) {
        playAudioWithVariableSpeed(2.0)  // playback at double speed
    }
    
    @IBAction func playSlow(sender: UIButton) {
        playAudioWithVariableSpeed(0.5)  // playback at half-speed
    }

    @IBAction func playChipmunkAudio(sender: AnyObject) {
        playAudioWithVariablePitch(1000)  // increase to high pitch
    }
    
    @IBAction func playDarthVaderAudio(sender: AnyObject) {
        playAudioWithVariablePitch(-1000)  // reduce to low pitch
    }
    
    @IBAction func stopPlaying(sender: UIButton) {
        stopAndResetAudio()
        // restart clip from the beginning
        audioPlayer.currentTime = 0
    }
    
    // stop the audioPlayer and AudioEngine and Reset audioEngine
    func stopAndResetAudio() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    // stop & reset audio, then play back at speed determined by
    // the speed parameter.   1.0 => normal speed.
    //                      < 1.0 => slower speed
    //                      > 1.0 => faster speed
    func playAudioWithVariableSpeed(speed : Float) {
        stopAndResetAudio()
        audioPlayer.rate = speed
        audioPlayer.play()
    }

    func playAudioWithVariablePitch(pitch: Float){

        stopAndResetAudio()

        // attach an audioPlayerNode to audio engine
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        // attach the change pitch effect to audio engine
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        // connect the change pitch effect to the audioPlayerNode
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        // now connect the audio pipeline to audio output node.
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        // schedule the file for playback, then play it
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
    
}
