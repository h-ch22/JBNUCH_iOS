//
//  CheckBox.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/11/25.
//

import SwiftUI

struct CheckBox: View {
    @Binding var checked: Bool

    var body: some View {
        Image(systemName: checked ? "checkmark.circle.fill" : "circle")
            .foregroundColor(.accent)
            .onTapGesture {
                self.checked.toggle()
            }
    }
}

struct CheckBox_Previews: PreviewProvider {
    static var previews: some View {
        CheckBox(checked: .constant(false))
    }
}
