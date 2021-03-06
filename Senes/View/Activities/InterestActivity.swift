//
//  InterestActivity.swift
//  senes
//
//  Created by Apprenant 49 on 03/12/2021.
//

import SwiftUI

struct InterestActivity: View {
    @ObservedObject var currentUser: CurrentUser
    
    @State private var text = ""
    
    let activities: [Activity]
    let interest: CenterOfInterest
    
    var activitiesFiltered: [Activity] {
        switch interest {
        case .cuisine:
            return activities.filter { $0.centerOfInterest == .cuisine }
        case .couture:
            return activities.filter { $0.centerOfInterest == .couture }
        case .arts:
            return activities.filter { $0.centerOfInterest == .arts }
        case .jardinage:
            return activities.filter { $0.centerOfInterest == .jardinage }
        case .sport:
            return activities.filter { $0.centerOfInterest == .sport }
        case .literature:
            return activities.filter { $0.centerOfInterest == .literature }
        }
    }

    var filteredActivity: [Activity] {
        if text == "" { return activitiesFiltered }
        return activitiesFiltered.filter {
            $0.title.lowercased().contains(text.lowercased())
        }
    }

    var body: some View {
        ScrollView {
            ForEach(filteredActivity) { activity in
                NavigationLink(destination: ActivityInfo(currentUser: currentUser, activity: activity)){
                    ActivityCard(activity: activity)
                }
                
                
            }
            .buttonStyle(.plain)

            .navigationBarTitle("\(interest.rawValue)")
            .navigationBarTitleDisplayMode(.inline)
            
        }
        .searchable(text: $text)
    }
}

struct InterestActivity_Previews: PreviewProvider {
    static let activities = Bundle.main.decode([Activity].self, from: "activities.json", dateDecodingStrategy: .iso8601)
    static var interests: [Interest] = Bundle.main.decode([Interest].self, from: "interests.json")
    
    static var previews: some View {
        InterestActivity(currentUser: CurrentUser(), activities: activities, interest: .arts)
            .environment(\.locale, Locale(identifier: "fr"))
//            .environment(\.sizeCategory, .accessibilityExtraExtraLarge)
    }
}

