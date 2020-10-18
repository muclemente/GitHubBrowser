//
//  UserListCellViewModelTests.swift
//  UnitTests
//
//  Created by Murilo Clemente on 17/10/2020.
//

import XCTest
@testable import Features
@testable import Core
import RxSwift
import RxTest

class UserListCellViewModelTests: XCTestCase {
    var viewModel = UserListCellViewModel()
    var disposeBag = DisposeBag()
    var scheduler = TestScheduler(initialClock: 0)

    lazy var mockImageProvider: MockUserProfileImageProvider = {
        guard let provider = DependencyManager.resolve(UserProfileImageProvider.self) as? MockUserProfileImageProvider else {
            fatalError("Missing dependency")
        }
        return provider
    }()

    override func setUp() {
        super.setUp()
        UnitTestDependencyInjector.load()
        viewModel = UserListCellViewModel()
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
    }

    override func tearDown() {
        super.tearDown()
        UnitTestDependencyInjector.reset()
    }

    func testCellBindAndImageLoading() {
        let usernameObserver = scheduler.createObserver(String.self)
        let loadingObserver = scheduler.createObserver(Bool.self)
        let imageObserver = scheduler.createObserver(UIImage.self)

        let image1 = UIImage()
        let image2 = mockImageProvider.mockedImage()

        mockImageProvider.fetchHandler = { url in
            if url.absoluteString.contains("redSquare") {
                return .just(image2)
            } else {
                return .just(image1)
            }
        }

        let user1 = User(id: 1, login: "user1", nodeId: "", avatarUrl: URL(string: "file://")!)
        let user2 = User(id: 2, login: "user2", nodeId: "", avatarUrl: URL(string: "file://redSquare")!)

        let observable = scheduler.createColdObservable([
            .next(10, user1),
            .next(20, user2)
        ]).flatMap(viewModel.updateUser)
            .observeOn(MainScheduler())

        observable.bind(to: imageObserver)
            .disposed(by: disposeBag)

        viewModel.loading
            .drive(loadingObserver)
            .disposed(by: disposeBag)

        viewModel.username
            .drive(usernameObserver)
            .disposed(by: disposeBag)

        scheduler.start()

        XCTAssertEqual(loadingObserver.events, [
            .next(10, true),
            .next(10, false),
            .next(20, true),
            .next(20, false)
        ])

        XCTAssertEqual(usernameObserver.events, [
            .next(10, "user1"),
            .next(20, "user2")
        ])

        XCTAssertEqual(imageObserver.events, [
            .next(10, image1),
            .next(20, image2)
        ])
    }
}
