//
//  PledgeDataModel.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/29.
//

import Foundation

struct PledgeDataModel : Hashable{
    var pledgeName : String
    var pledgeCategory : String
    var pledgeStatus : PledgeStatusModel
}
