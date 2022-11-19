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
            .observeAdvertise(withObjectType: ChargingTask.objectType)
            .subscribe(onNext: { event in
                let object = event.data.object as! ChargingTask
                Model.shared.tasks.append(object)
            })
            .disposed(by: self.disposeBag)
        try! self.communicationManager
            .observeAdvertise(withObjectType: EmergencyChargingTask.objectType)
            .subscribe(onNext: { event in
                let object = event.data.object as! ChargingTask
                Model.shared.tasks.append(object)
            })
            .disposed(by: self.disposeBag)
    }
}
