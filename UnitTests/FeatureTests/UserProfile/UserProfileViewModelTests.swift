//
//  UserProfileViewModelTests.swift
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

class UserProfileViewModelTests: XCTestCase {
    var disposeBag = DisposeBag()
    var scheduler = TestScheduler(initialClock: 0)

    lazy var mockUserProfileProvider: MockUserProfileProvider = {
        guard let provider = DependencyManager.resolve(UserProfileProvider.self) as? MockUserProfileProvider else {
            fatalError("Missing dependency")
        }
        return provider
    }()

    lazy var mockImageProvider: MockUserProfileImageProvider = {
        guard let provider = DependencyManager.resolve(UserProfileImageProvider.self) as? MockUserProfileImageProvider else {
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

    func testFetchUserProfile() {
        let mockUser = User(id: 1, login: "testUser")
        let viewModel = UserProfileViewModel(user: mockUser)
        let loadingObserver = scheduler.createObserver(Bool.self)
        let imageObserver = scheduler.createObserver(UIImage.self)
        let profileObserver = scheduler.createObserver(UserDetails.self)

        mockUserProfileProvider.fetchHandler = { _ in
            self.mockUserProfileProvider.jsonData(json: self.mockUserProfileProvider.detailJSONString)
        }
        let mockedImage = self.mockImageProvider.mockedImage()
        mockImageProvider.fetchHandler = { url in
            .just(mockedImage)
        }

        let observable = scheduler.createColdObservable([
            .next(10, viewModel)
        ])

        let profileObservable = observable.flatMap { $0.fetch() }
            .observeOn(MainScheduler())

        let imageObservable = observable.flatMap { $0.fetchImage() }
            .observeOn(MainScheduler())

        imageObservable.bind(to: imageObserver)
            .disposed(by: disposeBag)

        profileObservable.bind(to: profileObserver)
            .disposed(by: disposeBag)

        viewModel.loading
            .drive(loadingObserver)
            .disposed(by: disposeBag)

        scheduler.start()

        XCTAssertEqual(loadingObserver.events, [
            .next(10, true),
            .next(10, false)
        ])
        imageObserver.events.forEach { event in
            switch event.time {
            case 10:
                XCTAssertEqual(event.value.element, mockedImage)
            default: XCTFail("Received unexpected event")
            }
        }

        profileObserver.events.forEach { event in
            switch event.time {
            case 10:
                let detail = event.value.element
                XCTAssertEqual(detail?.name, "monalisa octocat")
                XCTAssertEqual(detail?.location, "San Francisco")
                XCTAssertEqual(detail?.followers, 20)
            default: XCTFail("Received unexpected event")
            }
        }
    }

    func testCoordinatorBack() {
        let nav = UINavigationController()
        nav.pushViewController(UIViewController(), animated: false)
        let coordinator = UserProfileCoordinator(navigationController: nav, user: User(id: 1, login: ""))
        coordinator.start()
        wait(timeout: 0.4) // Wait until UIKit adds the VC in the structure
        XCTAssertEqual(nav.viewControllers.count, 2)
        XCTAssertTrue(nav.topViewController is UserProfileViewController)
        let controller = nav.topViewController as? UserProfileViewController
        controller?.didTapBack()
        wait(timeout: 0.4)
        XCTAssertEqual(nav.viewControllers.count, 1)
    }
}
