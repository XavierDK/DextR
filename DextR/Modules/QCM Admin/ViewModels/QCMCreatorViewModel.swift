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
  let qcmCreated: Driver<RequestResult<QCMProtocol>>
  
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
          
          return API.createQCM(name, duration: Int(duration)!)
            .trackActivity(activityIndicQcm)
            .asDriver(onErrorJustReturn: RequestResult<QCMProtocol>(isSuccess: false, code: 500, message: "Une erreur est survenue", modelObject: nil))
        }
        .flatMapLatest { created -> Driver<RequestResult<QCMProtocol>> in
          let message = created.message ?? "Le QCM a été créé avec succès"
          
          return wireframe.promptFor("QCM", message: message, cancelAction: "OK", actions: [])
            .map { _ in
              created
            }
            .asDriver(onErrorJustReturn: RequestResult<QCMProtocol>(isSuccess: false, code: 500, message: "Une erreur est survenue", modelObject: nil))
      }
  }
}