//
//  EnterUserInfoView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/11/25.
//

import SwiftUI

struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var checkPassword = ""
    @State private var studentNo = ""
    @State private var name = ""
    @State private var phone = ""
    @State private var selectedCollege = 0
    @State private var pickedImage : Image?

    @State private var collegeList = ["간호대학", "공과대학", "글로벌융합대학", "농업생명과학대학", "사범대학", "사회과학대학", "상과대학", "생활과학대학", "수의과대학", "스마트팜학과", "약학대학", "예술대학", "의과대학", "인문대학", "자연과학대학", "치과대학", "환경생명자원대학"]
    
    @State private var showAlert = false
    @State private var showPicker = false
    @State private var showOverlay = false
    @State private var showActionSheet = false
    @State private var changeView = false
    @State private var showTutorial = false
    
    @State private var pickerType : UIImagePickerController.SourceType = .photoLibrary
    @State private var errorCode : UserManagementResultModel? = nil

    @FocusState private var activeField : UserManagementFocusField?
    @StateObject private var helper = UserManagement()
    
    private let alertModel = UserManagementAlertModel()

    private func openIDCard(){
        let url = "https://apps.apple.com/kr/app/%EC%A0%84%EB%B6%81%EB%8C%80%EC%95%B1/id1510698205"
        
        let appURL = URL(string: url)
        
        if UIApplication.shared.canOpenURL(appURL!){
            UIApplication.shared.openURL(appURL!)
        }
    }
    
    private func actionSheet() -> ActionSheet{
        let buttons = [
            ActionSheet.Button.default(Text("모바일학생증 이미지 불러오기")){
                self.showActionSheet = false
                self.pickerType = .photoLibrary
                self.showPicker = true
            },
            
            ActionSheet.Button.default(Text("모바일 학생증앱 열기")){
                self.showActionSheet = false
                openIDCard()
            },
            
            ActionSheet.Button.cancel(Text("취소"))
        ]
        
        let actionSheet = ActionSheet(title : Text("학생증 로드 방식 선택"),
                                      message: Text("원하시는 옵션을 선택하세요."),
                                      buttons: buttons)
        
        return actionSheet
    }
    
    var body: some View {
        ScrollView{
            ZStack{
                Color.background.edgesIgnoringSafeArea(.all)
                
                VStack{
                    Group {
                        HStack{
                            Image("ic_logo_no_slogan")
                                .resizable()
                                .frame(width : 150, height : 150)
                            
                            Spacer()
                        }
                                            
                        HStack {
                            Text("회원가입")
                                .font(.title)
                                .fontWeight(.semibold)
                            
                            Spacer()
                        }
                        
                        HStack {
                            Text("학우님의 정보를 입력해주세요.")
                            
                            Spacer()
                        }
                    }
                    
                    Spacer().frame(height : 40)
                    
                    Group{
                        HStack{
                            Image(systemName : "at.circle.fill")
                            
                            TextField("E-Mail", text : $email)
                                .focused($activeField, equals : .field_email)
                                .submitLabel(.continue)
                                .keyboardType(.emailAddress)
                        }.foregroundColor(activeField == .field_email ? .accent : .txtColor)
                            .padding(20)
                            .padding([.horizontal], 20)
                            .background(RoundedRectangle(cornerRadius: 30).foregroundColor(.btnColor).shadow(radius: 5)
                                            .padding([.horizontal],15))

                        Spacer().frame(height : 20)

                        HStack{
                            Image(systemName : "key.fill")
                            
                            SecureField("비밀번호", text : $password)
                                .focused($activeField, equals : .field_password)
                                .submitLabel(.done)
                        }.foregroundColor(activeField == .field_password ? .accent : .txtColor)
                            .padding(20)
                            .padding([.horizontal], 20)
                            .background(RoundedRectangle(cornerRadius: 30).foregroundColor(.btnColor).shadow(radius: 5)
                                            .padding([.horizontal],15))
                        
                        Spacer().frame(height : 20)

                        HStack{
                            Image(systemName : "key.fill")
                            
                            SecureField("비밀번호 확인", text : $checkPassword)
                                .focused($activeField, equals : .field_checkPassword)
                                .submitLabel(.done)
                        }.foregroundColor(activeField == .field_checkPassword ? .accent : .txtColor)
                            .padding(20)
                            .padding([.horizontal], 20)
                            .background(RoundedRectangle(cornerRadius: 30).foregroundColor(.btnColor).shadow(radius: 5)
                                            .padding([.horizontal],15))
                        
                        Spacer().frame(height : 20)
                        
                        HStack{
                            Image(systemName : "person.fill.viewfinder")
                            
                            TextField("이름", text : $name)
                                .focused($activeField, equals : .field_name)
                                .submitLabel(.continue)
                        }.foregroundColor(activeField == .field_name ? .accent : .txtColor)
                            .padding(20)
                            .padding([.horizontal], 20)
                            .background(RoundedRectangle(cornerRadius: 30).foregroundColor(.btnColor).shadow(radius: 5)
                                            .padding([.horizontal],15))
                        
                        Spacer().frame(height : 20)
                        
                        HStack{
                            Image(systemName : "phone.fill")
                            
                            TextField("휴대폰 번호", text : $phone)
                                .keyboardType(.numberPad)
                                .focused($activeField, equals : .field_phone)
                                .submitLabel(.continue)
                        }.foregroundColor(activeField == .field_phone ? .accent : .txtColor)
                            .padding(20)
                            .padding([.horizontal], 20)
                            .background(RoundedRectangle(cornerRadius: 30).foregroundColor(.btnColor).shadow(radius: 5)
                                            .padding([.horizontal],15))
                        
                    }
                    
                    Group{
                        Spacer().frame(height : 20)
                        
                        HStack{
                            Image(systemName : "person.crop.square.fill.and.at.rectangle")
                            
                            TextField("학번", text : $studentNo)
                                .keyboardType(.numberPad)
                                .focused($activeField, equals : .field_studentNo)
                                .submitLabel(.done)
                        }.foregroundColor(activeField == .field_studentNo ? .accent : .txtColor)
                            .padding(20)
                            .padding([.horizontal], 20)
                            .background(RoundedRectangle(cornerRadius: 30).foregroundColor(.btnColor).shadow(radius: 5)
                                            .padding([.horizontal],15))
                        
                        Spacer().frame(height : 20)

                        HStack {
                            Text("소속 단과대학을 선택해주세요.")
                                .fontWeight(.semibold)
                            
                            Spacer()
                        }
                        
                        HStack {
                            Picker(selection : $selectedCollege, label : Text("소속 단과대학 선택")){
                                ForEach(0..<collegeList.count){
                                    Text(collegeList[$0])
                                }
                            }
                            
                            Spacer()
                        }
                        
                        Spacer().frame(height : 20)

                        HStack {
                            Text("모바일 학생증 캡처 이미지를 불러와주세요.")
                                .fontWeight(.semibold)
                            
                            Spacer()
                        }
                        
                        Spacer().frame(height : 20)

                        HStack {
                            Button(action : {
                                showActionSheet = true
                            }){
                                HStack{
                                    Image(systemName : "person.crop.square.fill.and.at.rectangle")

                                    Text("모바일 학생증 불러오기")
                                }.padding(20)
                                .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btnColor).shadow(radius: 5))
                            }
                            
                            Spacer().frame(width : 30)
                            
                            Button(action : {
                                showTutorial = true
                            }){
                                Image(systemName : "questionmark.circle.fill")
                                    .resizable()
                                    .frame(width : 30, height : 30)
                                    .foregroundColor(.txtColor)
                            }
                        }
                        
                        Spacer().frame(height : 20)
                    }
                    
                    Button(action:{
                        if email == "" || password == "" || checkPassword == "" || name == "" || phone == "" || studentNo == "" || selectedCollege < 0 || pickedImage == nil{
                            errorCode = .emptyField
                            showAlert = true
                        }
                        
                        else if password != checkPassword{
                            errorCode = .passwordNotEquals
                            showAlert = true
                        }
                        
                        else{
                            showOverlay = true
                            
                            helper.ValidateIDCard(IDCard: pickedImage?.asUIImage(), studentNo: studentNo, name: name, college: collegeList[selectedCollege]){result in
                                guard let result = result else{return}
                                
                                if result != .success{
                                    showOverlay = false
                                    errorCode = result
                                    showAlert = true
                                }
                                
                                else{
                                    helper.signUp(email : email, password : password, userModel: UserInfoModel(name: name ?? "", phone: phone ?? "", studentNo: studentNo ?? "", college: collegeList[selectedCollege] ?? "", collegeCode : nil, uid : "", admin : nil, spot : "", profile : nil)){result in
                                        guard let result = result else{return}
                                        
                                        showOverlay = false
                                        
                                        if result != .success{
                                            errorCode = result
                                            showAlert = true
                                            
                                        }
                                        
                                        else{
                                            changeView = true
                                        }
                                    }
                                }
                            }
                        }
                    }){
                        HStack {
                            Text("다음 단계로")
                            
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(.white)
                        .padding([.horizontal], 80)
                        .padding([.vertical], 20)
                        .background(RoundedRectangle(cornerRadius: 30))
                    }
                    
                }
                .padding([.horizontal], 20)
                .actionSheet(isPresented : $showActionSheet, content:
                                actionSheet)
                
                .sheet(isPresented: $showPicker, content: {
                    ImagePickerView(sourceType: pickerType){(image) in
                        self.pickedImage = Image(uiImage: image)
                    }
                })
                
                .sheet(isPresented: $showTutorial, content: {
                    TutorialView()
                })
                
                .alert(isPresented : $showAlert, content : {
                    alertModel.showAlert(code: errorCode!)
                })
                
                .overlay(ProcessView().isHidden(!showOverlay))
                
                .fullScreenCover(isPresented : $changeView, content:{
                    TabManager().environmentObject(helper)
                })
            }
        }.background(Color.background.edgesIgnoringSafeArea(.all))

        
            
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
            .preferredColorScheme(.dark)
    }
}
