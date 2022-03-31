//
//  UserManagementAlertModel.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/11/24.
//

import Foundation
import SwiftUI

class UserManagementAlertModel{
    func showAlert(code : UserManagementResultModel) -> Alert{
        var title = ""
        var contents = ""
        
        switch code{
        case .unknownError:
            title = "오류"
            contents = "내부 오류가 발생했습니다."
            
        case .success:
            title = "작업 완료"
            contents = "요청하신 작업이 정상적으로 처리되었습니다."
            
        case .networkError:
            title = "네트워크 오류"
            contents = "네트워크 오류가 발생했습니다.\n네트워크 연결 상태를 확인해주세요."

        case .userNotFound:
            title = "계정 없음"
            contents = "입력한 정보와 일치하는 계정이 없습니다."

        case .userTokenExpired:
            title = "만료된 토큰"
            contents = "요청하신 계정의 토큰이 만료되었습니다.\n다시 로그인하십시오."

        case .tooManyRequests:
            title = "요청 허용 횟수 초과"
            contents = "이 기기에서 단시간에 비정상적으로 많은 요청을 하셨습니다.\n나중에 다시 시도하십시오."

        case .invalidAPIKey:
            title = "허가되지 않은 앱"
            contents = "앱이 허가되지 않았습니다.\n앱을 업데이트하거나 재설치해주세요.\n시스템이 위변조된 경우 서비스를 사용하실 수 없습니다."
            
        case .appNotAuthorized:
            title = "허가되지 않은 인증 방식"
            contents = "이 인증 방식은 허가되지 않았습니다."

        case .keychainError:
            title = "키체인 오류"
            contents = "키체인 접근 중 오류가 발생했습니다."

        case .internalError:
            title = "서버 오류"
            contents = "내부 오류가 발생했습니다.\n나중에 다시 시도하십시오."

        case .operationNotAllowed:
            title = "허가되지 않은 동작"
            contents = "허가되지 않은 동작입니다."

        case .wrongPassword:
            title = "비밀번호 불일치"
            contents = "비밀번호가 일치하지 않습니다."

        case .invalidEmail:
            title = "계정 없음"
            contents = "입력한 정보와 일치하는 계정이 없습니다."

        case .userDisabled:
            title = "비활성화된 계정"
            contents = "해당 계정이 사용자 요청에 의해 비활성화되었거나, 정지된 계정입니다."

        case .EmailAlreadyInUse:
            title = "이미 사용 중인 E-Mail"
            contents = "이미 사용 중인 E-Mail 계정입니다."

        case .weakPassword:
            title = "안전하지 않은 비밀번호"
            contents = "보안을 위해 6자리 이상의 비밀번호를 입력해주세요."
            
        case .emptyField:
            title = "공백 필드"
            contents = "모든 필드를 채워주세요."
            
        case .passwordNotEquals :
            title = "비밀번호 불일치"
            contents = "비밀번호가 일치하지 않습니다."
            
        case .legacyUser :
            title = "이전 버전 사용자"
            contents = "데이터 변환이 필요한 사용자입니다."
            
        case .IDCardValidationFailed:
            title = "학생증 인증 실패"
            contents = "변조된 학생증이거나, 학생증의 이미지가 올바르지 않습니다."
            
        case .registeredUser:
            title = "이미 가입된 사용자"
            contents = "이미 가입된 학번입니다."
        }
        
        return Alert(title: Text(title), message: Text(contents), dismissButton: .default(Text("확인")))
    }
}
