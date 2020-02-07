import Foundation

protocol ObserableTransform {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
