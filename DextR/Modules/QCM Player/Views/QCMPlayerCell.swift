//
//  QCMPlayerCell.swift
//  DextR
//
//  Created by Xavier De Koninck on 19/02/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public class QCMPlayerCell: UICollectionViewCell, UITableViewDataSource {
  
  var disposeBag: DisposeBag = DisposeBag()
  
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var answersTableView: UITableView!
  
  let answerSelectionCell = "QCMAnswerSelectionCell"
  let answerTrueFalseCell = "QCMAnswerTrueFalseCell"
  
  var questionType: QuestionType?
  
  var questionAnswers: QuestionAnswersProtocol?
  
  var answers: [AnswerProtocol]? {
    didSet {
      answersTableView.reloadData()
    }
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
  }
  
  override public func prepareForReuse() {
    super.prepareForReuse()
    
    disposeBag = DisposeBag()
  }
  
  
  // MARK: TableViewDataSource
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    answersTableView.registerNib(UINib(nibName: "QCMAnswerSelectionCell", bundle: nil), forCellReuseIdentifier: answerSelectionCell)
    answersTableView.registerNib(UINib(nibName: "QCMAnswerTrueFalseCell", bundle: nil), forCellReuseIdentifier: answerTrueFalseCell)
    return self.answers?.count ?? 0
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    if let answer = answers?[indexPath.row] {
      
      var cell = UITableViewCell()
      
      if questionType == .Selection {
        
        cell = answersTableView?.dequeueReusableCellWithIdentifier(answerSelectionCell) ?? UITableViewCell()
        
        if let cell = cell as? QCMAnswerSelectionCell {
          cell.answerLabel.text = answer.title
          
          if let answersResult = self.questionAnswers?.answersResult {
            var answ = answersResult[indexPath.row]
            
            cell.answerSwitch.selected = answ.selected ?? false
            
            cell.answerSwitch.rx_value
              .subscribeNext({ (value) in
                if answ.answer?.objectId == answer.objectId {
                  answ.selected = value
                }
              })
              .addDisposableTo(disposeBag)
          }
        }
      }
      else if questionType == .TrueFalse {
        
        cell = answersTableView?.dequeueReusableCellWithIdentifier(answerTrueFalseCell) ?? UITableViewCell()
        
        if let cell = cell as? QCMAnswerTrueFalseCell {
          cell.answerLabel.text = answer.title
          
          if let answersResult = self.questionAnswers?.answersResult {
            var answ = answersResult[indexPath.row]
            
            cell.answerSegment.selectedSegmentIndex = (answ.selected == true) ? (0) : (1)
            
            cell.answerSegment.rx_value
              .subscribeNext({ (value) in
                
                if answ.answer?.objectId == answer.objectId {
                  answ.selected = (value == 0) ? (true) : (false)
                }
              })
              .addDisposableTo(disposeBag)
          }
        }
      }
      
      return cell
    }
    
    return UITableViewCell()
  }
}