//
//  UserManagementResultModel.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/11/23.
//

import Foundation

enum UserManagementResultModel : Hashable{
    case success, networkError, userNotFound, userTokenExpired, tooManyRequests, invalidAPIKey, appNotAuthorized, keychainError, internalError, operationNotAllowed, wrongPassword, invalidEmail, userDisabled, unknownError, EmailAlreadyInUse, weakPassword, passwordNotEquals, emptyField, legacyUser, IDCardValidationFailed, registeredUser
}
