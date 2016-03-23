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
  @IBOutlet var questionStepLabel : UILabel!
  
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
    
    let doneButton = UIBarButtonItem(title: "Terminer", style: .Plain, target: nil, action: nil)
    doneButton.tintColor = UIColor.whiteColor()
    self.navigationItem.rightBarButtonItem = doneButton
    doneButton.rx_tap
      .subscribeNext { _ in
        
        self.viewModel?.qcmOver.value = true
      }
      .addDisposableTo(disposeBag)
    
    self.router?.showQCMStarterFromVC(self, forViewModel: self.viewModel!)
    
    self.viewModel?.qcmStarted
      .asObservable()
      .subscribeNext({ _ in
        
      })
      .addDisposableTo(disposeBag)
    
    self.collectionView.registerNib(UINib(nibName: "QCMPlayerCell", bundle: nil), forCellWithReuseIdentifier: playerQuestionCell)
    
    self.viewModel?.questionsVariables.asObservable()
      .bindTo(self.collectionView.rx_itemsWithCellIdentifier(playerQuestionCell, cellType: QCMPlayerCell.self)) { [weak self] (row, question, cell) in
        cell.titleLabel.text = question.title
        cell.questionType = question.type
        cell.answers = question.answers
        cell.questionAnswers = self?.viewModel?.questionAnswersForQuestion(question)
        
        self?.viewModel?.questionAnswersForQuestion(question)
      }
      .addDisposableTo(disposeBag)
    
    self.collectionView.rx_contentOffset.subscribeNext { (point) -> Void in
      self.currentIndex.value = Int(point.x / self.collectionView.frame.size.width)
      }
      .addDisposableTo(disposeBag)
    
    self.currentIndex.asObservable().map { (nb) in
      if nb < (self.viewModel?.questionsVariables.value.count)! - 1 {
        return true
      }
      return false
      }
      .bindTo(nextButton.rx_enabled)
      .addDisposableTo(disposeBag)
    
    self.viewModel?.questionsVariables.asObservable().subscribeNext({ (questions) in
      
      self.questionStepLabel.text = "\(self.currentIndex.value + 1)/\(questions.count ?? 0)"
    }).addDisposableTo(disposeBag)
    
    self.currentIndex.asObservable().subscribeNext { (index) in
      
      self.questionStepLabel.text = "\(self.currentIndex.value + 1)/\(self.viewModel?.questionsVariables.value.count ?? 0)"
      
      self.previousButton.alpha = 1.0
      self.nextButton.alpha = 1.0
      self.previousButton.enabled = true
      self.nextButton.enabled = true
      
      if index == 0 {
        self.previousButton.alpha = 0.5
        self.previousButton.enabled = false
      }
      
      if index == (self.viewModel?.questionsVariables.value.count ?? 0) - 1 {
        self.nextButton.alpha = 0.5
        self.nextButton.enabled = false
      }
      
      }.addDisposableTo(disposeBag)
    
    self.nextButton.rx_tap
      .subscribeNext { (_) in
        self.collectionView.setContentOffset(CGPoint(x: CGFloat(self.currentIndex.value + 1) * self.collectionView.frame.size.width, y: 0), animated: true)
      }
      .addDisposableTo(disposeBag)
    
    self.previousButton.rx_tap
      .subscribeNext { (_) in
        self.collectionView.setContentOffset(CGPoint(x: CGFloat(self.currentIndex.value - 1) * self.collectionView.frame.size.width, y: 0), animated: true)
      }
      .addDisposableTo(disposeBag)
    
    self.viewModel?.currentTimer
      .asObservable()
      .subscribeNext({ currentTimer in
        
        self.timerLabel.text = "\(String(format: "%02d", currentTimer / 60)):\(String(format: "%02d", currentTimer % 60))"
      })
      .addDisposableTo(disposeBag)
    
    self.viewModel?.qcmOver.asObservable()
      .subscribeNext({ (over) in
        if over {
          self.router?.showQCMThanksFromVC(self)
        }
      }).addDisposableTo(disposeBag)
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