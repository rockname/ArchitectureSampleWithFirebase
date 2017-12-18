import Foundation
import RxSwift
import RxCocoa

class LoginViewModel: ViewModelType {
    
    struct Input {
        let loginTrigger: Driver<Void>
        let email: Driver<String>
        let password: Driver<String>
    }
    
    struct Output {
        let login: Driver<User>
    }
    
    private let loginUseCase: LoginUseCase
    private let navigator: LoginNavigator
    
    init(with loginUseCase: LoginUseCase, and navigator: LoginNavigator) {
        self.loginUseCase = loginUseCase
        self.navigator = navigator
    }
    
    func transform(input: LoginViewModel.Input) -> LoginViewModel.Output {
        let requiredInputs = Driver.combineLatest(input.email, input.password)
        let login = input.loginTrigger
            .withLatestFrom(requiredInputs)
            .flatMapLatest { [unowned self] (email: String, password: String) in
                return self.loginUseCase.login(with: email, and: password)
                    .do(onNext: { [unowned self] user in
                        if user.isEmailVerified {
                            self.navigator.toList()
                        }
                    })
                    .asDriver(onErrorJustReturn: User(id: "", email: nil, isEmailVerified: false))
        }
        return LoginViewModel.Output(login: login)
    }
}
