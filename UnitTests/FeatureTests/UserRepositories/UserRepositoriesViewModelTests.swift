//
//  UserRepositoriesViewModelTests.swift
//  UnitTests
//
//  Created by Murilo Clemente on 18/10/2020.
//

import XCTest
@testable import Features
@testable import Core
import RxCocoa
import RxSwift
import RxTest

class UserRepositoriesViewModelTests: XCTestCase {
    var disposeBag = DisposeBag()
    var scheduler = TestScheduler(initialClock: 0)

    lazy var mockUserRepoProvider: MockUserRepositoriesProvider = {
        guard let provider = DependencyManager.resolve(UserRepositoriesProvider.self) as? MockUserRepositoriesProvider else {
            fatalError("Missing dependency")
        }
        return provider
    }()

    override func setUp() {
        super.setUp()
        UnitTestDependencyInjector.load()
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
    }

    override func tearDown() {
        super.tearDown()
        UnitTestDependencyInjector.reset()
    }

    func testFetchRepos() {
        let loadingObserver = scheduler.createObserver(Bool.self)
        let dataEmptyObserver = scheduler.createObserver(Bool.self)
        let reposObserver = scheduler.createObserver([Repository].self)

        let userMock = User(id: 1, login: "testUser")
        let viewModel = UserRepositoriesViewModel(user: userMock)
        let emptyViewModel = UserRepositoriesViewModel(user: User(id: 3, login: "empty"))

        let repo1 = Repository(
            name: "repo1",
            id: 1,
            description: nil,
            forkCount: 10,
            stargazerCount: 2,
            watcherCount: 3,
            updatedDate: Date()
        )

        let repo2 = Repository(
            name: "repo2",
            id: 2,
            description: nil,
            forkCount: 1,
            stargazerCount: 2,
            watcherCount: 3,
            updatedDate: Date()
        )
        mockUserRepoProvider.fetchHandler = { input in
            input.id == userMock.id ?
                .just([repo1, repo2]) : .just([])
        }

        let observable = scheduler.createColdObservable([
            .next(10, emptyViewModel),
            .next(20, viewModel)
        ]).flatMap { $0.fetchRepositories() }
            .observeOn(MainScheduler())

        observable.bind(to: reposObserver)
            .disposed(by: disposeBag)

        Driver.merge([emptyViewModel.loading, viewModel.loading])
            .drive(loadingObserver)
            .disposed(by: disposeBag)

        Driver.merge([emptyViewModel.dataEmpty, viewModel.dataEmpty])
            .drive(dataEmptyObserver)
            .disposed(by: disposeBag)

        scheduler.start()

        XCTAssertEqual(loadingObserver.events, [
            .next(10, true),
            .next(10, false),
            .next(20, true),
            .next(20, false)
        ])

        XCTAssertEqual(dataEmptyObserver.events, [
            .next(10, true),
            .next(20, false)
        ])

        reposObserver.events.forEach { event in
            switch event.time {
            case 10:
                XCTAssertEqual(event.value.element?.count, 0)
            case 20:
                XCTAssertEqual(event.value.element?.count, 2)
            default: XCTFail("Received unexpected event")
            }
        }
    }
}
