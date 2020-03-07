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
                    VStack {
                        HStack {
                            Image(achievement.imageName)
                            Text(achievement.name)
                            Spacer()
                            if achievement.progress >= 1 {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Color(.systemGreen))
                            }
                        }
                        .font(.headline)
                        Divider()
                        HStack {
                            Text(achievement.description)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        ProgressBar(value: achievement.progress, accentColor: achievement.progress >= 1 ? Color(.systemGreen) : Color(.systemPurple))
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(30)
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
