//
//  InternalNoticeView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/17.
//

import SwiftUI

struct InternalNoticeView: View {
    var body: some View {
        InternalWebView(url : URL(string: "https://www.jbnu.ac.kr/kor/?menuID=139")!)
    }
}

struct InternalNoticeView_Previews: PreviewProvider {
    static var previews: some View {
        InternalNoticeView()
    }
}
