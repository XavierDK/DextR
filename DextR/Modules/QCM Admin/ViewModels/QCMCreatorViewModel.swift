//
//  QCMCreatorViewModel.swift
//  DextR
//
//  Created by Xavier De Koninck on 06/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class QCMCreatorViewModel {
  
  let validatedQCMName: Driver<ValidationResult>
  let validatedQCMDuration: Driver<ValidationResult>
  
  let qcmEnabled: Driver<Bool>
  let qcmCreating: Driver<Bool>
  let qcmCreated: Driver<Bool>
  
  var completionSuccess: (() -> ())?
  
  init(
    input: (
    qcmName: Driver<String>,
    qcmDuration: Driver<String>,
    qcmTaps: Driver<Void>
    ),
    dependency: (
    API: QCMAPIProtocol,
    validationService: QCMValidationProtocol,
    wireframe: Wireframe
    )
    ) {
      
      let API = dependency.API
      let validationService = dependency.validationService
      let wireframe = dependency.wireframe
      
      validatedQCMName = input.qcmName
        .map { name in
          return validationService.validateQCMName(name)
      }
      
      validatedQCMDuration = input.qcmDuration
        .map { duration in
          return validationService.validateDuration(duration)
      }

      let activityIndicQcm = ActivityIndicator()
      self.qcmCreating = activityIndicQcm.asDriver()

      qcmEnabled = Driver.combineLatest(
        validatedQCMName,
        validatedQCMDuration,
        qcmCreating
        )   { name, duration, creating in
          name.isValid &&
            duration.isValid &&
            !creating
        }
        .distinctUntilChanged()
      
      let qcmDatas = Driver.combineLatest(input.qcmName, input.qcmDuration) { ($0, $1) }
      
      qcmCreated = input.qcmTaps.withLatestFrom(qcmDatas)
        .flatMapLatest { (name, duration) in
          return API.saveQCM(name, duration: duration)
            .trackActivity(activityIndicQcm)
            .asDriver(onErrorJustReturn: false)
        }
        .flatMapLatest { created -> Driver<Bool> in
          let message = created ? "Le QCM a été créé avec succès" : "Le QCM n'a pas pu être créé"
          return wireframe.promptFor("QCM", message: message, cancelAction: "OK", actions: [])
            .map { _ in
              created
            }
            .asDriver(onErrorJustReturn: false)
      }
  }
}