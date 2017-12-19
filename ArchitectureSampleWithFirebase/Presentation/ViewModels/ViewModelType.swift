import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    associatedtype State
    
    func transform(input: Input) -> Output
}
