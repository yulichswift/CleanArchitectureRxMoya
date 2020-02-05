import Foundation
import RxSwift
import RxCocoa

extension SharedSequenceConvertibleType {
    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        return map { _ in }
    }
}

extension ObservableType {

    func asDriverOnErrorJustComplete() -> Driver<Void> {
        return asDriver { error in
            return Driver.empty()
            } as! Driver<Void>
    }
    
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}
