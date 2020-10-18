//
//  MockUserProfileImageProvider.swift
//  UnitTests
//
//  Created by Murilo Clemente on 16/10/2020.
//

@testable import Core
import RxSwift

public class MockUserProfileImageProvider: UserProfileImageProvider {
    public init() { }

    public private(set) var fetchCallCount = 0
    public var fetchHandler: ((URL) -> (Observable<UIImage>))?
    public func fetch(url: URL) -> Observable<UIImage> {
        fetchCallCount += 1
        if let fetchHandler = fetchHandler {
            return fetchHandler(url)
        }
        return Observable<UIImage>.empty()
    }

    func mockedImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 20, height: 20))
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.red.cgColor)
        context?.fill(CGRect(x: 5, y: 5, width: 10, height: 10))
        guard let cgImage = context?.makeImage() else {
            return UIImage()
        }
        return UIImage(cgImage: cgImage)
    }
}
