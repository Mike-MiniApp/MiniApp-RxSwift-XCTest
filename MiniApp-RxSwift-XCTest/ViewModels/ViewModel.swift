//
//  ViewModel.swift
//  MiniApp-RxSwift-XCTest
//
//  Created by 近藤米功 on 2022/10/06.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

protocol ViewModelInputs {
    var number1TextFieldObservable: Observable<String> { get }
    var number2TextFieldObservable: Observable<String> { get }
    var calcButtonObservable: Observable<Void> { get }
}
protocol ViewModelOutputs {
    var calcResultPublishRelay: PublishRelay<String> { get }
}

class ViewModel: ViewModelOutputs,ViewModelInputs {
    // MARK: Outputs
    var calcResultPublishRelay = RxRelay.PublishRelay<String>()

    // MARK: Inputs
    var number1TextFieldObservable: RxSwift.Observable<String>
    var number2TextFieldObservable: RxSwift.Observable<String>
    var calcButtonObservable: RxSwift.Observable<Void>

    private var disposeBag = DisposeBag()

    private let calculator = Calculator()

    private var number1 = 0
    private var number2 = 0
    private var resultNumber = 0

    init(number1TextFieldObservable: Observable<String>,number2TextFieldObservable: Observable<String>,calcButtonObservable: Observable<Void>){
        self.number1TextFieldObservable = number1TextFieldObservable
        self.number2TextFieldObservable = number2TextFieldObservable
        self.calcButtonObservable = calcButtonObservable
        setupBindings()
    }

    private func setupBindings() {
        let totalInput = Observable.combineLatest(number1TextFieldObservable, number2TextFieldObservable)
        totalInput.subscribe { number1,number2 in
            self.number1 = Int(number1) ?? 0
            self.number2 = Int(number2) ?? 0
        }.disposed(by: disposeBag)

        calcButtonObservable.subscribe (onNext: { [weak self] in
            self?.resultNumber = self?.calculator.addition(number1: self?.number1 ?? 0, number2: self?.number2 ?? 0) ?? 0
            self?.calcResultPublishRelay.accept(String(self?.resultNumber ?? 0))
        }).disposed(by: disposeBag)
    }

}
