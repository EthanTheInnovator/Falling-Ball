//
//  AchievementsView.swift
//  Falling Ball
//
//  Created by Ethan Humphrey on 3/3/20.
//  Copyright © 2020 Ethan Humphrey. All rights reserved.
//

import SwiftUI

struct AchievementsView: View {
    
    var dismiss: (() -> Void)?
    let allAchievements = Achievement.allAchievements
    
    var body: some View {
        NavigationView {
            List {
                ForEach (allAchievements) { achievement in
                    AchievementsRowView(achievement: achievement)
                }
            }
            .navigationBarTitle("Achievements")
            .navigationBarItems(trailing: Button(action: dismiss!, label: {
                Text("Done")
            }))
            .onAppear {
                UITableView.appearance().separatorStyle = .none
            }
            .onDisappear {
                UITableView.appearance().separatorStyle = .singleLine
            }
        }
        .accentColor(Color(.systemPurple))
    
    }
}

struct AchievementsView_Previews: PreviewProvider {
    static var previews: some View {
        AchievementsView()
    }
}
