import Foundation
import RxSwift
import RxCocoa

class SignUpViewModel: ViewModelType {
    
    struct Input {
        let checkLoginTrigger: Driver<Void>
        let loginTrigger: Driver<Void>
        let signUpTrigger: Driver<Void>
        let email: Driver<String>
        let password: Driver<String>
    }
    
    struct Output {
        let checkLogin: Driver<Void>
        let signUp: Driver<Void>
        let login: Driver<Void>
        let error: Driver<Error>
    }
    
    struct State {
        let error = ErrorTracker()
    }
    
    private let authModel: AuthModel
    private let navigator: SignUpNavigator
    
    init(with authModel: AuthModel, and navigator: SignUpNavigator) {
        self.authModel = authModel
        self.navigator = navigator
    }
    
    func transform(input: SignUpViewModel.Input) -> SignUpViewModel.Output {
        let state = State()
        let requiredInputs = Driver.combineLatest(input.email, input.password)
        let signUp = input.signUpTrigger
            .withLatestFrom(requiredInputs)
            .flatMapLatest { [unowned self] (email: String, password: String) in
                return self.authModel.signUp(with: email, and: password)
                    .trackError(state.error)
                    .flatMapLatest { [unowned self] _ in
                        return self.authModel.sendEmailVerification()
                            .trackError(state.error)
                    }
                    .asDriverOnErrorJustComplete()
        }
        let login = input.loginTrigger
            .do(onNext: { [unowned self] _ in self.navigator.toLogin() })
        let checkLogin = input.checkLoginTrigger
            .flatMapLatest { [unowned self] _ in
                return self.authModel.checkLogin()
                    .map { [unowned self] isLogin in
                        if isLogin { self.navigator.toList() }
                }
                .trackError(state.error)
                .asDriver(onErrorJustReturn: ())
            }
        
        return SignUpViewModel.Output(
            checkLogin: checkLogin,
            signUp: signUp,
            login: login,
            error: state.error.asDriver()
        )
    }
}
