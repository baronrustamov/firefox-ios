// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0

import SwiftUI
import WidgetKit
import UIKit
import Combine
import SiteImageView

// Tab provider for Widgets
struct TabProvider: TimelineProvider {
    public typealias Entry = OpenTabsEntry
    var tabsDict: [String: SimpleTab] = [:]

    func placeholder(in context: Context) -> OpenTabsEntry {
        OpenTabsEntry(date: Date(), favicons: [String: Image](), tabs: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (OpenTabsEntry) -> Void) {
        let openTabs = SimpleTab.getSimpleTabs().values.filter {
            !$0.isPrivate
        }

        let simpleTabs = SimpleTab.getSimpleTabs()
        let siteImageFetcher = DefaultSiteImageFetcher.factory()

        Task {
            let tabFaviconDictionary = await withTaskGroup(of: (String, SiteImageModel).self,
                                                           returning: [String: Image].self) { group in
                for (_, tab) in simpleTabs {
                    group.addTask {
                        await (tab.imageKey,
                               siteImageFetcher.getImage(urlStringRequest: tab.url?.absoluteString ?? "",
                                                         type: .favicon,
                                                         id: UUID(),
                                                         usesIndirectDomain: false))
                    }
                }

                return await group.reduce(into: [:]) { $0[$1.0] = Image(uiImage: $1.1.faviconImage ?? UIImage()) }
            }

            let openTabsEntry = OpenTabsEntry(date: Date(), favicons: tabFaviconDictionary, tabs: openTabs)
            completion(openTabsEntry)
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<OpenTabsEntry>) -> Void) {
        getSnapshot(in: context, completion: { openTabsEntry in
            let timeline = Timeline(entries: [openTabsEntry], policy: .atEnd)
            completion(timeline)
        })
    }
}

struct OpenTabsEntry: TimelineEntry {
    let date: Date
    let favicons: [String: Image]
    let tabs: [SimpleTab]
}
