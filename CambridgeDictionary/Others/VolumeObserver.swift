//
//  VolumeObserver.swift
//  CambridgeDictionary
//
//  Created by 吳浩瑋 on 2022/8/7.
//

import Foundation
import MediaPlayer

final class VolumeObserver: ObservableObject {

    @Published var volume: Float = AVAudioSession.sharedInstance().outputVolume

    // Audio session object
    private let session = AVAudioSession.sharedInstance()

    // Observer
    private var progressObserver: NSKeyValueObservation!

    func subscribe() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("cannot activate session")
        }

        progressObserver = session.observe(\.outputVolume) { [self] (session, value) in
            DispatchQueue.main.async {
                self.volume = session.outputVolume
            }
        }
    }

    func unsubscribe() {
        self.progressObserver.invalidate()
    }

    init() {
        subscribe()
    }
}
