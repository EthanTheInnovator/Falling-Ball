//
//  AchievementsViewHostingController.swift
//  Falling Ball
//
//  Created by Ethan Humphrey on 3/6/20.
//  Copyright © 2020 Ethan Humphrey. All rights reserved.
//

import SwiftUI

final class AchievementsViewHostingController: UIHostingController<AchievementsView> {
    
    init() {
        super.init(rootView: AchievementsView())
        rootView.dismiss = dismiss
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }
}
