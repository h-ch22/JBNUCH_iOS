//
//  ProcessView.swift
//  SOZIP
//
//  Created by 하창진 on 2021/07/30.
//

import SwiftUI

struct ProcessView: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
            .padding(20)
            .background(RoundedRectangle(cornerRadius: 15.0).foregroundColor(.white).opacity(0.5))
    }
}

struct ProcessView_Previews: PreviewProvider {
    static var previews: some View {
        ProcessView()
    }
}
