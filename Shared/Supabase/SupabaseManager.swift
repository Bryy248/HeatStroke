//
//  SupabaseManager.swift
//  HeatStroke
//
//  Created by Nabiel Ahmad Ardhityo on 03/07/26.
//

import Foundation
import Supabase

enum SupabaseConfig {
    private static var config: [String: Any] {
        guard let url = Bundle.main.url(forResource: "SupabaseConfig", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let plist = try? PropertyListSerialization.propertyList(
                from: data,
                options: [],
                format: nil
              ) as? [String: Any] else {
            fatalError("Missing SupabaseConfig.plist")
        }

        return plist
    }

    static var supabaseURL: URL {
        guard let value = config["SUPABASE_URL"] as? String,
              let url = URL(string: value) else {
            fatalError("Invalid SUPABASE_URL")
        }

        return url
    }

    static var publishableKey: String {
        guard let value = config["SUPABASE_PUBLISHABLE_KEY"] as? String else {
            fatalError("Missing SUPABASE_PUBLISHABLE_KEY")
        }

        return value
    }
}

enum SupabaseManager {
    static let client = SupabaseClient(
        supabaseURL: SupabaseConfig.supabaseURL,
        supabaseKey: SupabaseConfig.publishableKey
    )
}
