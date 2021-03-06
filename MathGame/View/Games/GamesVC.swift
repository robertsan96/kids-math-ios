//
//  GamesVC.swift
//  MathGame
//
//  Created by Robert Sandru on 7/28/19.
//  Copyright © 2019 codecontrive. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum GamesVCPickers: Int {
    case dividingCategoryPicker
    case addingsCategoryPicker
    case takeAwaysCategoryPicker
    case halvesCategoryPicker
    case timeTablesCategoryPicker
    case doublesCategoryPicker
    case timedMultiplyingLevelPicker
}

class GamesVC: UIViewController {
    
    @IBOutlet weak var gamesTable: UITableView!
    @IBOutlet weak var studentLabel: UILabel!
    @IBOutlet weak var statsButton: UIButton!
    
    var viewModel: GamesVM?
    
    var disposeBag: DisposeBag = DisposeBag()
    
    var selectModeOverlay: UIView?
    var selectModeView: SelectModeView?
    var categoryVC: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statsButton.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        statsButton.setTitleColor(.white, for: .normal)
        
        customizeTable()
        rxStart()
    }
    
    func customizeTable() {
        gamesTable.register(UINib(nibName: "GameTVC", bundle: nil), forCellReuseIdentifier: "GameCell")
        gamesTable.rowHeight = 100
        
        viewModel?.games.bind(to: gamesTable
            .rx.items(cellIdentifier: "GameCell", cellType: GameTVC.self)) { row, model, cell in
                cell.gameName.text = model.getName()
                cell.delegate = self
                cell.game = model
            }.disposed(by: disposeBag)
        
        gamesTable.rx.modelSelected(Game.self).subscribe(onNext: { [weak self] game in
            guard let `self` = self else { return }
            guard game.getName() != Game.timedMultiplying.getName() else {
                self.didSelect(mode: .quiz, for: game)
                return
            }
            
            self.selectModeView?.removeFromSuperview()
            self.selectModeOverlay?.removeFromSuperview()
            let selectMode = SelectModeView()
            selectMode.load(with: game)
            selectMode.frame = CGRect(x: 0, y: self.view.frame.height-400, width: self.view.frame.width, height: 400)
            selectMode.closeButton.addTarget(self, action: #selector(self.didCloseModeSelector), for: .touchUpInside)
            selectMode.delegate = self
            self.selectModeView = selectMode
            
            let overlay: UIView = UIView(frame: CGRect(x: 0,
                                                       y: 0,
                                                       width: self.view.frame.width,
                                                       height: self.view.frame.height))
            overlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            overlay.addSubview(selectMode)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didCloseModeSelector))
            overlay.addGestureRecognizer(tapGesture)
            self.selectModeOverlay = overlay
            self.view.addSubview(overlay)
        }).disposed(by: disposeBag)
    }
    
    @objc func didCloseModeSelector() {
        self.selectModeOverlay?.removeFromSuperview()
        self.selectModeView?.removeFromSuperview()
    }
    
    func updateView(with student: Student) {
        let firstName = student.firstName ?? ""
        let lastName = student.lastName ?? ""
        let fullName = firstName + " " + lastName
        studentLabel.text = fullName
        statsButton.setTitle("Reports for \(fullName)", for: .normal)
    }
    
    @IBAction func onBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onStats(_ sender: Any) {
        guard let student = viewModel?.getStudent() else { return }
        let studentDataVC: StudentDataVC = Storyboard.shared.getViewController(by: .studentDataVC)
        let studentDataVM = StudentDataVM(with: student, and: .student)
        studentDataVC.viewModel = studentDataVM
        navigationController?.pushViewController(studentDataVC, animated: true)
    }
}

extension GamesVC {
    
    func rxStart() {
        viewModel?
            .student
            .subscribe(onNext: { [weak self] student in
                self?.updateView(with: student)
            })
            .disposed(by: disposeBag)
    }
}

extension GamesVC: SelectModeViewDelegate {
    
    func didSelect(mode: Constants.GameModes, for game: Game) {
        guard let student = viewModel?.getStudent() else { return }
        switch game {
        case .numbersBond10:
            if mode == .quiz || mode == .training {
                let numbersBondVC: NumbersBondVC = Storyboard.shared.getViewController(by: .numbersBondVC)
                let numbersBondVM: NumbersBondVM = NumbersBondVM(with: game,
                                                                 with: mode,
                                                                 and: .ten,
                                                                 and: student,
                                                                 and: .beginner)
                numbersBondVC.viewModel = numbersBondVM
                numbersBondVC.delegate = self
                present(numbersBondVC, animated: true, completion: {
                    numbersBondVC.reloadViews()
                })
            }
        case .numbersBond20:
            if mode == .quiz || mode == .training{
                let numbersBondVC: NumbersBondVC = Storyboard.shared.getViewController(by: .numbersBondVC)
                let numbersBondVM: NumbersBondVM = NumbersBondVM(with: game,
                                                                 with: mode,
                                                                 and: .twenty,
                                                                 and: student,
                                                                 and: .beginner)
                numbersBondVC.viewModel = numbersBondVM
                numbersBondVC.delegate = self
                present(numbersBondVC, animated: true, completion: {
                    numbersBondVC.reloadViews()
                })
            }
        case .constrainedAddings:
            if mode == .quiz || mode == .training {
                let halvesVC: GenericGameOne = Storyboard.shared.getViewController(by: .genericGameOne)
                let halvesVM: HalvesVM = HalvesVM(with: game,
                                                  with: mode,
                                                  and: 20,
                                                  and: student,
                                                  and: .beginner)
                halvesVC.viewModel = halvesVM
                halvesVC.delegate = self
                self.present(halvesVC, animated: true, completion: {
                    halvesVC.reloadViews()
                })
            }
        case .halves:
            if mode == .quiz || mode == .training {
                
                let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
                pickerView.delegate = self
                pickerView.dataSource = self
                pickerView.tag = GamesVCPickers.halvesCategoryPicker.rawValue
                
                categoryVC = UIViewController()
                categoryVC?.preferredContentSize = CGSize(width: 250,height: 300)
                categoryVC?.view.addSubview(pickerView)
                let editRadiusAlert = UIAlertController(title: "Category",
                                                        message: "Select your halves level.",
                                                        preferredStyle: UIAlertController.Style.alert)
                editRadiusAlert.setValue(categoryVC, forKey: "contentViewController")
                editRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak self] action in
                    let selectedLevel = Constants.GameLevels.getLevel(by: pickerView.selectedRow(inComponent: 0))
                    let halvesVC: GenericGameOne = Storyboard.shared.getViewController(by: .genericGameOne)
                    let halvesVM: HalvesVM = HalvesVM(with: game,
                                                      with: mode,
                                                      and: 20,
                                                      and: student,
                                                      and: selectedLevel)
                    halvesVC.viewModel = halvesVM
                    halvesVC.delegate = self
                    self?.present(halvesVC, animated: true, completion: {
                        halvesVC.reloadViews()
                    })
                }))
                editRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(editRadiusAlert, animated: true) {
                    pickerView.selectRow(0, inComponent: 0, animated: true)
                }
            }
        case .doubles:
            if mode == .quiz || mode == .training {
                let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
                pickerView.delegate = self
                pickerView.dataSource = self
                pickerView.tag = GamesVCPickers.doublesCategoryPicker.rawValue
                
                categoryVC = UIViewController()
                categoryVC?.preferredContentSize = CGSize(width: 250,height: 300)
                categoryVC?.view.addSubview(pickerView)
                let editRadiusAlert = UIAlertController(title: "Category",
                                                        message: "Select your doubles level.",
                                                        preferredStyle: UIAlertController.Style.alert)
                editRadiusAlert.setValue(categoryVC, forKey: "contentViewController")
                editRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak self] action in
                    let selectedLevel = Constants.GameLevels.getLevel(by: pickerView.selectedRow(inComponent: 0))
                    let halvesVC: GenericGameOne = Storyboard.shared.getViewController(by: .genericGameOne)
                    let halvesVM: HalvesVM = HalvesVM(with: game,
                                                      with: mode,
                                                      and: 20,
                                                      and: student,
                                                      and: selectedLevel)
                    halvesVC.viewModel = halvesVM
                    halvesVC.delegate = self
                    self?.present(halvesVC, animated: true, completion: {
                        halvesVC.reloadViews()
                    })
                }))
                editRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(editRadiusAlert, animated: true) {
                    pickerView.selectRow(0, inComponent: 0, animated: true)
                }
            }
        case .adding:
            if mode == .quiz || mode == .training {
                let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
                pickerView.delegate = self
                pickerView.dataSource = self
                pickerView.tag = GamesVCPickers.addingsCategoryPicker.rawValue
                
                categoryVC = UIViewController()
                categoryVC?.preferredContentSize = CGSize(width: 250,height: 300)
                categoryVC?.view.addSubview(pickerView)
                let editRadiusAlert = UIAlertController(title: "Category",
                                                        message: "Select your addings level.",
                                                        preferredStyle: UIAlertController.Style.alert)
                editRadiusAlert.setValue(categoryVC, forKey: "contentViewController")
                editRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak self] action in
                    let selectedLevel = Constants.GameLevels.getLevel(by: pickerView.selectedRow(inComponent: 0))
                    let halvesVC: GenericGameOne = Storyboard.shared.getViewController(by: .genericGameOne)
                    let halvesVM: HalvesVM = HalvesVM(with: game,
                                                      with: mode,
                                                      and: 20,
                                                      and: student,
                                                      and: selectedLevel)
                    halvesVC.viewModel = halvesVM
                    halvesVC.delegate = self
                    self?.present(halvesVC, animated: true, completion: {
                        halvesVC.reloadViews()
                    })
                }))
                editRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(editRadiusAlert, animated: true) {
                    pickerView.selectRow(0, inComponent: 0, animated: true)
                }
            }
        case .takeAways:
            if mode == .quiz || mode == .training {
                
                let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
                pickerView.delegate = self
                pickerView.dataSource = self
                pickerView.tag = GamesVCPickers.takeAwaysCategoryPicker.rawValue
                
                categoryVC = UIViewController()
                categoryVC?.preferredContentSize = CGSize(width: 250,height: 300)
                categoryVC?.view.addSubview(pickerView)
                let editRadiusAlert = UIAlertController(title: "Category",
                                                        message: "Select your take aways level.",
                                                        preferredStyle: UIAlertController.Style.alert)
                editRadiusAlert.setValue(categoryVC, forKey: "contentViewController")
                editRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak self] action in
                    let selectedLevel = Constants.GameLevels.getLevel(by: pickerView.selectedRow(inComponent: 0))
                    let halvesVC: GenericGameOne = Storyboard.shared.getViewController(by: .genericGameOne)
                    let halvesVM: HalvesVM = HalvesVM(with: game,
                                                      with: mode,
                                                      and: 20,
                                                      and: student,
                                                      and: selectedLevel)
                    halvesVC.viewModel = halvesVM
                    halvesVC.delegate = self
                    self?.present(halvesVC, animated: true, completion: {
                        halvesVC.reloadViews()
                    })
                }))
                editRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(editRadiusAlert, animated: true) {
                    pickerView.selectRow(0, inComponent: 0, animated: true)
                }
            }
        case .timesTable:
            if mode == .quiz || mode == .training {
                let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
                pickerView.delegate = self
                pickerView.dataSource = self
                pickerView.tag = GamesVCPickers.timeTablesCategoryPicker.rawValue
                
                categoryVC = UIViewController()
                categoryVC?.preferredContentSize = CGSize(width: 250,height: 300)
                categoryVC?.view.addSubview(pickerView)
                let editRadiusAlert = UIAlertController(title: "Category",
                                                        message: "Select your desired level including times table category.",
                                                        preferredStyle: UIAlertController.Style.alert)
                editRadiusAlert.setValue(categoryVC, forKey: "contentViewController")
                editRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak self] action in
                    let selectedCategory = Constants.GameLevels.beginner.getCategory(by: pickerView.selectedRow(inComponent: 0))
                    let halvesVC: GenericGameOne = Storyboard.shared.getViewController(by: .genericGameOne)
                    let halvesVM: HalvesVM = HalvesVM(with: game,
                                                      with: mode,
                                                      and: 20,
                                                      and: student,
                                                      and: .beginner,
                                                      and: selectedCategory)
                    halvesVC.viewModel = halvesVM
                    halvesVC.delegate = self
                    self?.present(halvesVC, animated: true, completion: {
                        halvesVC.reloadViews()
                    })
                    
                }))
                editRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(editRadiusAlert, animated: true) {
                    pickerView.selectRow(0, inComponent: 0, animated: true)
                }
            }
        case .timedMultiplying:
            if mode == .quiz || mode == .training {
                // it can only be quiz anyway
                let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
                pickerView.delegate = self
                pickerView.dataSource = self
                pickerView.tag = GamesVCPickers.timedMultiplyingLevelPicker.rawValue
                let level = viewModel?.getTimedMultiplyingLevel() ?? 0
                pickerView.selectRow(level, inComponent: 0, animated: true)
                
                categoryVC = UIViewController()
                categoryVC?.preferredContentSize = CGSize(width: 250,height: 300)
                categoryVC?.view.addSubview(pickerView)
                let editRadiusAlert = UIAlertController(title: "Level",
                                                        message: "Select your desired level.",
                                                        preferredStyle: UIAlertController.Style.alert)
                editRadiusAlert.setValue(categoryVC, forKey: "contentViewController")
                editRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak self] action in
                    let selectedLevel = pickerView.selectedRow(inComponent: 0) + 1
                    let halvesVC: GenericGameOne = Storyboard.shared.getViewController(by: .genericGameOne)
                    let halvesVM: HalvesVM = HalvesVM(with: game,
                                                      with: mode,
                                                      and: 20,
                                                      and: student,
                                                      and: .beginner,
                                                      and: 1,
                                                      and: selectedLevel)
                    halvesVC.viewModel = halvesVM
                    halvesVC.delegate = self
                    self?.present(halvesVC, animated: true, completion: {
                        halvesVC.reloadViews()
                    })
                    
                }))
                editRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(editRadiusAlert, animated: true) {
//                    pickerView.selectRow(0, inComponent: 0, animated: true)
                }
                
            }
        case .dividing:
            if mode == .quiz || mode == .training {
                let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
                pickerView.delegate = self
                pickerView.dataSource = self
                pickerView.tag = GamesVCPickers.dividingCategoryPicker.rawValue
                
                categoryVC = UIViewController()
                categoryVC?.preferredContentSize = CGSize(width: 250,height: 300)
                categoryVC?.view.addSubview(pickerView)
                let editRadiusAlert = UIAlertController(title: "Category",
                                                        message: "Select your desired level including division category.",
                                                        preferredStyle: UIAlertController.Style.alert)
                editRadiusAlert.setValue(categoryVC, forKey: "contentViewController")
                editRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak self] action in
                    let selectedLevel = Constants.GameLevels.beginner
                    let selectedCategory = selectedLevel.getCategory(by: pickerView.selectedRow(inComponent: 0))
                    let halvesVC: GenericGameOne = Storyboard.shared.getViewController(by: .genericGameOne)
                    let halvesVM: HalvesVM = HalvesVM(with: game,
                                                      with: mode,
                                                      and: 20,
                                                      and: student,
                                                      and: selectedLevel,
                                                      and: selectedCategory)
                    halvesVC.viewModel = halvesVM
                    halvesVC.delegate = self
                    self?.present(halvesVC, animated: true, completion: {
                        halvesVC.reloadViews()
                    })
                    
                }))
                editRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(editRadiusAlert, animated: true) {
                    pickerView.selectRow(0, inComponent: 0, animated: true)
                }
            }
        }
    }
}

extension GamesVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerView.tag {
        case GamesVCPickers.dividingCategoryPicker.rawValue: return 1
        case GamesVCPickers.addingsCategoryPicker.rawValue: return 1
        case GamesVCPickers.halvesCategoryPicker.rawValue: return 1
        case GamesVCPickers.timeTablesCategoryPicker.rawValue: return 1
        case GamesVCPickers.timedMultiplyingLevelPicker.rawValue: return 1
        case GamesVCPickers.doublesCategoryPicker.rawValue: return 1
        case GamesVCPickers.takeAwaysCategoryPicker.rawValue: return 1
        default: break
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case GamesVCPickers.dividingCategoryPicker.rawValue:
            if component == 0 {
                return Constants.GameLevels.beginner.getDividingCategory().count
            }
            return 0
        case GamesVCPickers.timeTablesCategoryPicker.rawValue:
            if component == 0 {
                return Constants.GameLevels.beginner.getTimesTableCategory().count
            }
            return 0
        case GamesVCPickers.halvesCategoryPicker.rawValue,
             GamesVCPickers.addingsCategoryPicker.rawValue,
             GamesVCPickers.takeAwaysCategoryPicker.rawValue,
             GamesVCPickers.doublesCategoryPicker.rawValue:
            return 3
        case GamesVCPickers.timedMultiplyingLevelPicker.rawValue:
            return TimedMultiplyingManager.shared.getLevels()
        default: break
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case GamesVCPickers.dividingCategoryPicker.rawValue:
            return "By \(row+1)"
        case GamesVCPickers.timeTablesCategoryPicker.rawValue:
                return "By \(row + 1)"
        case GamesVCPickers.halvesCategoryPicker.rawValue,
             GamesVCPickers.addingsCategoryPicker.rawValue,
             GamesVCPickers.takeAwaysCategoryPicker.rawValue,
             GamesVCPickers.doublesCategoryPicker.rawValue:
            switch row {
            case Constants.GameLevels.beginner.rawValue: return "Beginner"
            case Constants.GameLevels.medium.rawValue: return "Medium"
            case Constants.GameLevels.advanced.rawValue: return "Advanced"
            default: return nil
            }
        case GamesVCPickers.timedMultiplyingLevelPicker.rawValue:
            return "Level \(row+1)"
        default: return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case GamesVCPickers.dividingCategoryPicker.rawValue:
            if component == 0 {
                pickerView.reloadComponent(0)
            }
        case GamesVCPickers.timeTablesCategoryPicker.rawValue:
            if component == 0 {
                pickerView.reloadComponent(0)
            }
        case GamesVCPickers.timedMultiplyingLevelPicker.rawValue:
            let level = viewModel?.getTimedMultiplyingLevel() ?? 1
            
            if level < row {
                pickerView.selectRow(level, inComponent: 0, animated: true)
            }
        default: break
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        switch pickerView.tag {
        case GamesVCPickers.timedMultiplyingLevelPicker.rawValue:
            
            let level = viewModel?.getTimedMultiplyingLevel() ?? 0
            
            if level >= row {
                return NSAttributedString(string: "\(row+1)", attributes: nil)
            } else {
                let attributes = [NSAttributedString.Key.foregroundColor: UIColor.gray]
                return NSAttributedString(string: "\(row+1)", attributes: attributes)
            }
            
        default: return nil
        }
    }
}

extension GamesVC: NumbersBondVCDelegate {
    
    func didDismiss(on vc: NumbersBondVC) {
        didCloseModeSelector()
    }
}

extension GamesVC: HalvesVCDelegate {
    
    func didDismiss(on vc: GameTypeOne) {
        
    }
}

extension GamesVC: GameTVCDelegate {
    
    func didPressInfo(on cell: GameTVC) {
        let gameInfoVC: GameInfoVC = Storyboard.shared.getViewController(by: .gameInfoVC)
        let gameInfoVM = GameInfoVM(with: cell.game)
        gameInfoVC.viewModel = gameInfoVM
        present(gameInfoVC, animated: true, completion: nil)
    }
}
