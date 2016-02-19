//
//  QCMPlayerViewer.swift
//  DextR
//
//  Created by Xavier De Koninck on 22/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class QCMPlayerViewer : UIViewController {
  
  @IBOutlet var collectionView : UICollectionView!
  @IBOutlet var timerLabel : UILabel!
  
  @IBOutlet var previousButton : UIButton!
  @IBOutlet var nextButton : UIButton!
  
  var currentIndex : Variable<Int> = Variable(0)
  
  var router: AppRouter?
  
  var disposeBag = DisposeBag()
  
  var completionSuccess: (() -> ())?
  
  var qcm: QCMProtocol?
  
  var qcmAPI: QCMAPIProtocol?
  var qcmResultAPI: QCMResultAPIProtocol?
  var wireframe: Wireframe?
  
  var viewModel: QCMPlayerViewModel?
  
  let playerQuestionCell = "QCMPlayerCell"
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    if let qcm = self.qcm {
    
    self.viewModel = QCMPlayerViewModel(
      input: (
        previousTap: self.previousButton.rx_tap.asDriver(),
        nextTap: self.nextButton.rx_tap.asDriver(),
        qcm: qcm
      ),
      dependency: (
        qcmAPI: self.qcmAPI!,
        qcmResultAPI: self.qcmResultAPI!,
        wireframe: self.wireframe!
      )
    )
    }
    
    self.router?.showQCMStarterFromVC(self, forViewModel: self.viewModel!)
    
    self.viewModel?.qcmStarted
      .asObservable()
      .subscribeNext({ _ in
        
      })
      .addDisposableTo(disposeBag)
    
    self.collectionView.registerNib(UINib(nibName: "QCMPlayerCell", bundle: nil), forCellWithReuseIdentifier: playerQuestionCell)
    
//    let questionsVar = Variable(self.qcm?.questions)
    
    
    self.viewModel?.questionsVariables.asObservable()
      .bindTo(self.collectionView.rx_itemsWithCellIdentifier(playerQuestionCell, cellType: QCMPlayerCell.self)) { [weak self] (row, question, cell) in
        cell.titleLabel.text = question.title
        cell.questionType = question.type
        cell.answers = question.answers
        self?.viewModel?.questionAnswersForQuestion(question)
      }
      .addDisposableTo(disposeBag)
    
    self.collectionView.rx_contentOffset.subscribeNext { (point) -> Void in
      self.currentIndex.value = Int(point.x / self.collectionView.frame.size.width)
    }
      .addDisposableTo(disposeBag)
    
    self.currentIndex.asObservable().map { (nb) in
      if nb > 0 {
        return true
      }
      return false
      }
      .bindTo(previousButton.rx_enabled)
      .addDisposableTo(disposeBag)
    
    self.currentIndex.asObservable().map { (nb) in
      if nb < (self.viewModel?.questionsVariables.value.count)! - 1 {
        return true
      }
      return false
      }
    .bindTo(nextButton.rx_enabled)
    
//      .asObservable()
//    bindTo(previousButton.rx_enabled)
      .addDisposableTo(disposeBag)
    
    
    self.nextButton.rx_tap
    .subscribeNext { (_) -> Void in
      self.collectionView.setContentOffset(CGPoint(x: CGFloat(self.currentIndex.value + 1) * self.collectionView.frame.size.width, y: 0), animated: false)
    }
    .addDisposableTo(disposeBag)
    
    self.previousButton.rx_tap
      .subscribeNext { (_) -> Void in
        self.collectionView.setContentOffset(CGPoint(x: CGFloat(self.currentIndex.value - 1) * self.collectionView.frame.size.width, y: 0), animated: false)
      }
      .addDisposableTo(disposeBag)
  }
  
  override func viewWillAppear(animated: Bool) {
    
    super.viewWillAppear(animated)
    
    let layout = UICollectionViewFlowLayout()
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.itemSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
    layout.scrollDirection = .Horizontal;
    self.collectionView.collectionViewLayout = layout
    
    self.navigationItem.hidesBackButton = true
  }
}