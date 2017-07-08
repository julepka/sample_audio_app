//
//  ViewController.swift
//  AudioAppSample
//
//  Created by Julia Potapenko on 6.07.2017.
//  Copyright © 2017 Julia Potapenko. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioEngine = AVAudioEngine()
        
        let path = Bundle.main.path(forResource: "Endorphin", ofType: "mp3")!
        let url = NSURL.fileURL(withPath: path)
        audioFile = try? AVAudioFile(forReading: url)
    }
    
    @IBAction func playSound(sender: UIButton) {
        commonAudioFunction(audioChangeNumber: 1, typeOfChange: "rate")
    }
    
    @IBAction func playSoundSlowly(sender: UIButton) {
        commonAudioFunction(audioChangeNumber: 0.5, typeOfChange: "rate")
        
    }
    
    @IBAction func playSoundFast(sender: UIButton) {
        commonAudioFunction(audioChangeNumber: 1.5, typeOfChange: "rate")
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        audioEngine.stop()
        audioEngine.reset()
        
    }
    
    @IBAction func playChipmunk(sender: UIButton) {
        commonAudioFunction(audioChangeNumber: 1000, typeOfChange: "pitch")
    }
    
    @IBAction func playDarthVader(sender: UIButton) {
        commonAudioFunction(audioChangeNumber: -1000, typeOfChange: "pitch")
    }
    
    @IBAction func playEQ(sender: UIButton) {
        commonAudioFunction(audioChangeNumber: 0, typeOfChange: "eq")
    }
    
    func commonAudioFunction(audioChangeNumber: Float, typeOfChange: String){
        let audioPlayerNode = AVAudioPlayerNode()
        
        audioPlayerNode.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        audioEngine.attach(audioPlayerNode)
        
        let changeAudioUnitTime = AVAudioUnitTimePitch()
        
        if (typeOfChange == "rate") {
            
            changeAudioUnitTime.rate = audioChangeNumber
            
        } else if (typeOfChange == "pitch") {
            
            changeAudioUnitTime.pitch = audioChangeNumber
            
        } else if (typeOfChange == "eq") {
            
            let unitEq = AVAudioUnitEQ(numberOfBands: 2)
            
            var filterParams = unitEq.bands[0]
            filterParams.filterType = .highPass
            filterParams.frequency = 100
            
            filterParams = unitEq.bands[1]
            filterParams.filterType = .parametric
            filterParams.frequency = 500
            filterParams.bandwidth = 3.0
            filterParams.gain = 10.0
            
            self.audioEngine.attach(unitEq)
        }
        audioEngine.attach(changeAudioUnitTime)
        audioEngine.connect(audioPlayerNode, to: changeAudioUnitTime, format: nil)
        audioEngine.connect(changeAudioUnitTime, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
        try? audioEngine.start()
        
        audioPlayerNode.play()
        
    }

}

