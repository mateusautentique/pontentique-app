//
//  LoadingIconView.swift
//  Pontentique
//
//  Created by Mateus Zanella on 19/01/24.
//

import SwiftUI

struct LoadingIconView: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
    }
}

#Preview {
    LoadingIconView()
}
