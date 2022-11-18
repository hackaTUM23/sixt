//
//  ExampleController.swift
//  sixt
//
//  Created by Nikolai Madlener on 18.11.22.
//

import Foundation
import CoatySwift

class ExampleControllerObserve: Controller {

    override func onCommunicationManagerStarting() {
        super.onCommunicationManagerStarting()

        self.observeExampleCoatyObjects()
    }
    
    private func observeExampleCoatyObjects() {
        try! self.communicationManager
            .observeUpdate(withObjectType: ExampleCoatyObject.objectType)
            .subscribe(onNext: { event in
                let object = event.data.object as! ExampleCoatyObject
//                let example = Example(taskType: .auction, object: object)
//                if DuckieModel.standard.tasks.contains{ $0.object.objectId == object.objectId } {
//                    return
//                }
//                DuckieModel.standard.tasks.append(task)
                
            })
            .disposed(by: self.disposeBag)
    }
}

