//
//  AppDelegate.swift
//  praticeDelegate
//
//  Created by 서민영 on 2023/09/05.
//

import UIKit
import RealmSwift
import KakaoSDKCommon
import NaverThirdPartyLogin
import FirebaseCore
import GoogleSignIn
import Firebase
@available(iOS 13.0, *)
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        NaverThirdPartyLoginConnection.getSharedInstance().application(app, open: url, options: options)
        return true
    }
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        KakaoSDK.initSDK(appKey: "78de2b7afdd52285ae10cfde4d800f33")
       
        let instance = NaverThirdPartyLoginConnection.getSharedInstance()
            
            // 네이버 앱으로 인증하는 방식을 활성화
            instance?.isNaverAppOauthEnable = false
            
            // SafariViewController에서 인증하는 방식을 활성화
            instance?.isInAppOauthEnable = true
            
            // 인증 화면을 iPhone의 세로 모드에서만 사용하기
//            instance?.isOnlyPortraitSupportedInIphone()
            
            // 네이버 아이디로 로그인하기 설정
            // 애플리케이션을 등록할 때 입력한 URL Scheme
         
     
            // 애플리케이션을 등록할 때 입력한 URL Scheme
            instance?.serviceUrlScheme = kServiceAppUrlScheme
        
            // 애플리케이션 등록 후 발급받은 클라이언트 아이디
            instance?.consumerKey = kConsumerKey
            // 애플리케이션 등록 후 발급받은 클라이언트 시크릿
            instance?.consumerSecret = kConsumerSecret
            // 애플리케이션 이름
            instance?.appName = kServiceAppName

        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 3,

            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 2) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
            })

        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config

        // Now that we've told Realm how to handle the schema change, opening the file
        // will automatically perform the migration
        let realm = try! Realm()
        return true
    }

    // MARK: UISceneSession Lifecycle


    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

