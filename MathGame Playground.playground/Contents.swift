import UIKit
import RxSwift
import PlaygroundSupport

var disposeBag = DisposeBag()

let tick = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)

tick
    .flatMapLatest{ (moment) -> Observable<String> in
        if moment < 5 { return Observable.just("Less than 5") }
        if moment > 5 { return Observable.just("More than 5") }
        return Observable.just("Somewhere between")
    }
    .filter { (da) -> Bool in
        return da == "Less than 5"
    }
    .distinctUntilChanged()
    .debug()
    .subscribe(onNext: { tick in
        
    }).disposed(by: disposeBag)

PlaygroundPage.current.needsIndefiniteExecution = true
