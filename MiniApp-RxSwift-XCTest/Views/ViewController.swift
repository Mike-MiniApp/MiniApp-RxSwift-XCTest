//
//  ViewController.swift
//  MiniApp-RxSwift-XCTest
//
//  Created by 近藤米功 on 2022/10/06.
//

import UIKit
import RxSwift
import RxRelay

class ViewController: UIViewController {

    // MARK: - UI Parts
    @IBOutlet weak var number1TextField: UITextField!
    @IBOutlet weak var number2TextField: UITextField!
    @IBOutlet weak var calcButton: UIButton!
    @IBOutlet weak var numberLabel: UILabel!

    private let disposeBag = DisposeBag()

    private lazy var viewModel = ViewModel(number1TextFieldObservable: number1TextField.rx.text.map{$0 ?? ""}.asObservable(), number2TextFieldObservable: number2TextField.rx.text.map{$0 ?? ""}.asObservable(), calcButtonObservable: calcButton.rx.tap.asObservable())

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }

    private func setupBindings() {
        viewModel.calcResultPublishRelay.bind(to: numberLabel.rx.text).disposed(by: disposeBag)
    }


}

