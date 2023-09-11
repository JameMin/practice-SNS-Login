//
//  ViewController.swift
//  praticeDelegate
//
//  Created by 서민영 on 2023/09/05.
//

import UIKit
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import Alamofire
import SwiftyJSON
import NaverThirdPartyLogin
import GoogleSignIn



class ViewController: UIViewController {
    
    
    
    @IBOutlet weak var bannerCollectionViews: UICollectionView!
    
    @IBOutlet weak var googleBtn: UIButton!
    @IBOutlet weak var naverLoginBtn: UIButton!
    @IBOutlet weak var kakaoLoginBtn: UIButton!
    // 현재페이지 체크 변수 (자동 스크롤할 때 필요)
    var nowPage: Int = 0
    var name: String = ""
    var phone: String = ""
    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    // 데이터 배열
    let dataArray: Array<UIImage> = [UIImage(named: "img4")!, UIImage(named: "img5")!, UIImage(named: "img6")!]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bannerCollectionViews.delegate = self
        bannerCollectionViews.dataSource = self

        print(dataArray.count)
        bannerTimer()
//        kakaoToken()
        loginInstance?.delegate = self

    }
    
    func kakaoToken() {
        // ✅ 유효한 토큰 검사
        if (AuthApi.hasToken()) {
            UserApi.shared.accessTokenInfo { (_, error) in
                if let error = error {
                    if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true  {
                        //로그인 필요
                    }
                    else {
                        //기타 에러
                                            }
                }
                else {
                    //토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
               

                    // ✅ 사용자 정보를 가져오고 화면전환을 하는 커스텀 메서드
//                    self.getUserInfo()
                }
            }
        }
        else {
            //로그인 필요
        }
    }

    @IBAction func googleLoginBtn(_ sender: Any) {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] signInResult, _ in
                    guard let self,
                          let result = signInResult,
                          let token = result.user.idToken?.tokenString else { return }
                    
                    print("Token : \(result)")
                var userID = result.user.userID
                name = result.user.profile?.name ?? ""
                var userEmail = result.user.profile?.email
                
                print("userID : \(userID)")
               
            
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "sampleViewController") as? sampleViewController else { return }
            vc.delegate = self
            vc.userName = name ?? ""
            vc.userEmail = userEmail ?? ""
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
         
                }
    }
    
    // 2초마다 실행되는 타이머
    func bannerTimer() {
        let _: Timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { (Timer) in
            self.bannerMove()
        }
    }
    
    
    // 배너 움직이는 매서드
    func bannerMove() {
        // 현재페이지가 마지막 페이지일 경우
        if nowPage == dataArray.count-1 {
            // 맨 처음 페이지로 돌아감
            bannerCollectionViews.scrollToItem(at: NSIndexPath(item: 0, section: 0) as IndexPath, at: .right, animated: true)
            nowPage = 0
            return
        }
        // 다음 페이지로 전환
        nowPage += 1
        bannerCollectionViews.scrollToItem(at: NSIndexPath(item: nowPage, section: 0) as IndexPath, at: .right, animated: true)
    }
    
    
    @IBAction func click(_ sender: Any)
    {
       
        
    }
    
    // MARK: -  카카오 @Functions
    
    // 카카오 로그인 버튼 클릭 시
    @IBAction func LoginKakaoBtn(_ sender: Any) {
        // 카카오톡 설치 여부 확인
        if UserApi.isKakaoTalkLoginAvailable() {
            // 카카오톡 로그인. api 호출 결과를 클로저로 전달.
            loginWithApp()
        } else {
            // 만약, 카카오톡이 깔려있지 않을 경우에는 웹 브라우저로 카카오 로그인함.
            loginWithWeb()
        }
//        self.presentToMain()
    }
    
    @IBAction func logOutBtn(_ sender: Any) {
        loginInstance?.requestDeleteToken()
        // ✅ 연결 끊기 : 연결이 끊어지면 기존의 토큰은 더 이상 사용할 수 없으므로, 연결 끊기 API 요청 성공 시 로그아웃 처리가 함께 이뤄져 토큰이 삭제됩니다.
//               UserApi.shared.unlink {(error) in
//                   if let error = error {
//                       print(error)
//                   }
//                   else {
//                       print("unlink() success.")
//
//                       // ✅ 연결끊기 시 메인으로 보냄
//                       self.dismiss(animated: false, completion: nil)
//                   }
//               }
    }
    // MARK: - 네이버
    

    @IBAction func naverLoginBtn(_ sender: Any) {
       
        loginInstance?.requestThirdPartyLogin()
    }

    @objc private func touchUpLogoutButton(_ sender: UIButton) {
      loginInstance?.requestDeleteToken()
    }
    
    private func getNaverInfo() {
      guard let isValidAccessToken = loginInstance?.isValidAccessTokenExpireTimeNow() else { return }
      
      if !isValidAccessToken {
        return
      }
      
      guard let tokenType = loginInstance?.tokenType else { return }
      guard let accessToken = loginInstance?.accessToken else { return }
      let urlStr = "https://openapi.naver.com/v1/nid/me"
      let url = URL(string: urlStr)!
      
      let authorization = "\(tokenType) \(accessToken)"
   
      let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
      req.responseData { response in
          
          print(response.result)
          switch response.result {
          case .success:
                        
                        print("검색성공!!")
                        
                        guard let statusCode = response.response?.statusCode else { return }
                        guard let value = response.value else { return }
                        print("답답해\(value.description)")
                        let json = JSON(value)
//                        let json = JSON(value)
                        var jsonItem = json["response"]
//                print(json)
              print("답답해\(json)")
              print ("답답해\(json["response"])")
           
              var dataitem = json["response"]
              self.name =  dataitem["name"].string ?? ""
              var mobile =  dataitem["mobile"].string
              var email =  dataitem["email"].string

              
              guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "sampleViewController") as? sampleViewController else { return }
              vc.delegate = self
              vc.userName = self.name ?? ""
              vc.userEmail = email ?? ""
              vc.mobile = mobile ?? ""
              vc.modalPresentationStyle = .overFullScreen
              self.present(vc, animated: true, completion: nil)
              
          case .failure(let error):
              print(error.localizedDescription)
          }
        }
    }

    
    // 화면 전환 함수
    func presentToMain() {
   
    }
  
    
  }


    // MARK: - Kakao Login Extensions

    extension ViewController {
        
        // 카카오톡 앱으로 로그인
        func loginWithApp() {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    print("loginWithKakaoTalk() success.")
                    
                    UserApi.shared.me {(user, error) in
                        if let error = error {
                            print(error)
                        } else {
                            let nickname = user?.kakaoAccount?.profile?.nickname
                            let email = user?.kakaoAccount?.email
                            let token = user?.groupUserToken
                        
                            print("이름\(nickname)")
                            print("이름\(email)")
                       
                        }
                    }
                }
            }
       
        }
        
        // 카카오톡 웹으로 로그인
        func loginWithWeb() {
            UserApi.shared.loginWithKakaoAccount {(_, error) in
                if let error = error {
                    print(error)
                } else {
                    print("loginWithKakaoAccount() success.")
                    
                    UserApi.shared.me {(user, error) in
                        if let error = error {
                            print(error)
                        } else {
                            print("카카오 로그인 성공")
                 
                        }
                    }
                }
            }
          
        }


}

extension ViewController: CustomDelegate {
    func returnValue(num: String?, message: String?) {
        DispatchQueue.main.async {
        }
    }

}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //컬렉션뷰 개수 설정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    //컬렉션뷰 셀 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = bannerCollectionViews.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath) as! BannerCell
        cell.imageView.image = dataArray[indexPath.row]
        return cell
    }
    
    // UICollectionViewDelegateFlowLayout 상속
    //컬렉션뷰 사이즈 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: bannerCollectionViews.frame.size.width  , height:  bannerCollectionViews.frame.height)
    }
    
    //컬렉션뷰 감속 끝났을 때 현재 페이지 체크
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        nowPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    
}

extension ViewController: NaverThirdPartyLoginConnectionDelegate {
    // 로그인에 성공한 경우 호출 됨
       func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
           print("네이버 로그인 성공")
           getNaverInfo()
       }
       // 토큰 갱신 성공 시 호출 됨
       func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
           print("네이버 토큰 갱신 성공")
           getNaverInfo()
      
       }
       // 연동해제 성공한 경우 호출 됨
       func oauth20ConnectionDidFinishDeleteToken() {
           print("네이버 연동 해제 성공")
           loginInstance?.requestDeleteToken()
       }
       // 모든 error인 경우 호출 됨
       func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
           let alert = UIAlertController(title: "네이버 SNS 로그인 실패", message: "이유: \(String(error.localizedDescription))\n문제가 반복된다면 관리자에게 문의하세요.", preferredStyle: .alert)
           let ok = UIAlertAction(title: "확인", style: .default)
           alert.addAction(ok)
           
           //topViewController를 구해서, 있으면 alert을 띄움
//           if let vc = UIApplication.topViewController(base: nil) {
//               vc.present(alert, animated: true)
//           }
       }

}



