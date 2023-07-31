//
//  MockData.swift
//  AVPlayerApp
//
//  Created by Max Ward on 29/07/2023.
//

import Foundation

class MockData {
    static var items: [URL] = [
        Bundle.main.url(forResource: "01", withExtension: "mp4")!,
        Bundle.main.url(forResource: "02", withExtension: "mp4")!,
        //Bundle.main.url(forResource: "03", withExtension: "mp4")!,
        Bundle.main.url(forResource: "04", withExtension: "mp4")!,
        Bundle.main.url(forResource: "05", withExtension: "mp4")!
    ]
}
