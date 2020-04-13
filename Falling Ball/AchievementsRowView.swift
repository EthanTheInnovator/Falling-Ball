//
//  AchievementsRowView.swift
//  Falling Ball
//
//  Created by Ethan Humphrey on 3/11/20.
//  Copyright © 2020 Ethan Humphrey. All rights reserved.
//

import SwiftUI

struct AchievementsRowView: View {
    @State var achievement: Achievement
    
    @State var achievementRect: CGRect = .zero
    @State var achievementImage: UIImage? = nil
    @State var achievementString: String = ""
    @State var sharePresented: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Image(achievement.imageName)
                Text(achievement.name)
                Spacer()
                if achievement.progress >= 1 {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color(.systemGreen))
                }
                Button(action: {
                    self.achievementImage = UIApplication.shared.windows[0].rootViewController?.presentedViewController?.view.asImage(rect: self.achievementRect)
                    if self.achievement.progress == 0 {
                        self.achievementString = "I'm working my way towards earning the \(self.achievement.name) achievement in Stacker!"
                    }
                    else if self.achievement.progress >= 1 {
                        self.achievementString = "I've earned the \(self.achievement.name) achievement in Stacker!"
                    }
                    else {
                        self.achievementString = "I am \(self.achievement.progress*100)% of the way towards earning the \(self.achievement.name) achievement in Stacker!"
                    }
                    self.sharePresented = true
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .padding(.trailing)
                        .accentColor(Color(.systemPurple))
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
        .background(RectGetter(rect: self.$achievementRect))
        .sheet(isPresented: self.$sharePresented) {
            ShareSheet(activityItems: [self.achievementImage, self.achievementString])
            .accentColor(Color(.systemPurple))
        }
    }
}

struct RectGetter: View {
    @Binding var rect: CGRect

    var body: some View {
        GeometryReader { proxy in
            self.createView(proxy: proxy)
        }
    }

    func createView(proxy: GeometryProxy) -> some View {
        DispatchQueue.main.async {
            let frame = proxy.frame(in: .global)
            self.rect = CGRect(x: frame.minX, y: frame.minY - frame.height/2 + 7, width: frame.width, height: frame.height)
        }

        return Rectangle().fill(Color.clear)
    }
}

struct AchievementsRowView_Previews: PreviewProvider {
    static var previews: some View {
        AchievementsRowView(achievement: .kingAchievement)
    }
}
