//
//  TaskControllerObserve.swift
//  sixt
//
//  Created by Martin Fink on 19.11.22.
//

import Foundation
import CoatySwift

class TaskControllerObserve: Controller {

    override func onCommunicationManagerStarting() {
        super.onCommunicationManagerStarting()

        self.observe()
    }
    
    private func observe() {
        try! self.communicationManager
            .observeUpdate(withObjectType: ChargingTask.objectType)
            .subscribe(onNext: { event in
                let object = event.data.object as! ChargingTask
            })
            .disposed(by: self.disposeBag)
        try! self.communicationManager
            .observeUpdate(withObjectType: EmergencyChargingTask.objectType)
            .subscribe(onNext: { event in
                let object = event.data.object as! ChargingTask
            })
            .disposed(by: self.disposeBag)
    }
}
