//
//  UserSearchViewModelTests.swift
//  UnitTests
//
//  Created by Murilo Clemente on 16/10/2020.
//

import XCTest
@testable import Features
@testable import Core
import RxSwift
import RxTest

class UserSearchViewModelTests: XCTestCase {
    var viewModel = UserSearchViewModel()
    var disposeBag = DisposeBag()
    var scheduler = TestScheduler(initialClock: 0)

    lazy var mockUserSearchProvider: MockUsersSearchProvider = {
        guard let provider = DependencyManager.resolve(UsersSearchProvider.self) as? MockUsersSearchProvider else {
            fatalError("Missing dependency")
        }
        return provider
    }()

    override func setUp() {
        super.setUp()
        UnitTestDependencyInjector.load()
        viewModel = UserSearchViewModel()
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
    }

    override func tearDown() {
        super.tearDown()
        UnitTestDependencyInjector.reset()
    }

    func testSearchUsers() {
        let userSectionObserver = scheduler.createObserver([UserListSection].self)
        let loadingObserver = scheduler.createObserver(Bool.self)
        let dataEmptyObserver = scheduler.createObserver(Bool.self)

        let mockedUsers = [User(id: 0, login: "test1"), User(id: 1, login: "test2")]

        mockUserSearchProvider.fetchHandler = { input in
            let result = input == "testUsers" ? mockedUsers : []
            return Observable.just(result)
        }

        let observable = scheduler.createColdObservable([
            .next(10, "a"),
            .next(20, "testEmpty"),
            .next(30, "testUsers")
        ]).flatMap(viewModel.handleSearchControllerTextChange)
            .observeOn(MainScheduler())

        observable.bind(to: userSectionObserver)
            .disposed(by: disposeBag)

        viewModel.loading
            .drive(loadingObserver)
            .disposed(by: disposeBag)

        viewModel.dataEmpty
            .drive(dataEmptyObserver)
            .disposed(by: disposeBag)

        scheduler.start()
        XCTAssertEqual(dataEmptyObserver.events, [
            .next(10, true),
            .next(20, true),
            .next(30, false)
        ])

        XCTAssertEqual(loadingObserver.events, [
            .next(20, true),
            .next(20, false),
            .next(30, true),
            .next(30, false)
        ])

        userSectionObserver.events.forEach { event in
            switch event.time {
            case 10...20: XCTAssertEqual(event.value.element?.first?.items.count, 0)
            case 30: XCTAssertEqual(event.value.element?.first?.items.count, 2)
            default: XCTFail("Received unexpected event")
            }
        }
    }

    func testCoordinatorToRepoSearch() {
        let nav = UINavigationController()
        let coordinator = UserSearchCoordinator(navigationController: nav)
        coordinator.start()
        wait(timeout: 0.4) // Wait until UIKit adds the VC in the structure
        XCTAssertTrue(nav.topViewController is UserSearchViewController)
        let controller = nav.topViewController as? UserSearchViewController
        controller?.didSelect(User(id: 1, login: ""))
        XCTAssertTrue(coordinator.childCoordinators.contains(where: {$0 is UserRepositoriesCoordinator}))
    }
}
