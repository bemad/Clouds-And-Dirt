//
//  GrandCentralDispatchPerformUpdates.swift
//  TechWishList
//
//  Created by Bhavya Madan on 20/02/18.
//  Copyright © 2018 Bhavya Madan. All rights reserved.
//

import Foundation
func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
