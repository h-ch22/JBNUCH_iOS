![ ](ReadMe/render_final.png)</br>
# JBNU General Student Council</br>
### An official mobile application of Jeonbuk National University Student Council. The fastest way to access campus notices and welfare.<br>
ⓒ 2022-2024. Changjin Ha. All Rights Reserved.<br><br>

## 🚀 Tech Stack

### Client (iOS)
- **Framework:** SwiftUI (Declarative UI / iOS 15.0+)
- **Architecture:** Feature-based Modular Structure (Home, Notice, Sports, Rent, etc.)
- **Maps:** Naver Maps SDK for Campus POI (Points of Interest)

### Backend (BaaS & Serverless)
- **Firebase Auth:** Authentication
- **Firebase Firestore:** Real-time data sync for rental items & petitions, notifications, associate stores
- **Firebase Functions:** Serverless business logic for sports matching & push triggers
- **Firebase Messaging (FCM):** Push notifications for council notices
- **Firebase Storage:** Handling image uploads for petitions and notices


## 🏗️ Architecture

```mermaid
graph TD
    %% Client Modular Structure
    subgraph ClientApp [📱 JBNU-CH: SwiftUI Client]
        subgraph ModularDesign [Feature-based Modules]
            Notice[Notice]
            Petitions[Petitions]
            Map[Campus Map / NaverMaps]
            Sports[Sports Matching]
            Rental[Rent items]
            Stores[Associate Stores]
        end
        
        subgraph InternalLayer [Module Internal]
            View[SwiftUI View]
            Model[Data Models]
            Helper[Helper / Service]
        end

        View <--> Model
        Model <--> Helper
    end

    %% Firebase Infrastructure
    subgraph Firebase [☁️ Firebase Backend]
        Auth[Auth]
        FS[(Firestore)]
        Functions[Cloud Functions]
        FCM[Cloud Messaging]
    end

    %% Flow
    Helper <--> Auth
    Helper <--> FS
    Helper --> Functions
    Functions --> FCM
    FCM -.->|Push| ClientApp
    Map -->|External| NMaps[Naver Maps SDK]
```

## 🧱 If I were to rebuild it in 2026

| Layer | Original | 2026 Pick | Reason |
|---|---|---|---|
| Package manager | CocoaPods | Swift Package Manager | Removes Ruby dep, faster CI, native Xcode integration |
| Firebase SDK | 6.34.0 | 11.x via SPM | Unblocks security patches, async/await APIs, smaller binary |
| ML features | `Firebase/MLVision` 0.21.0 | `GoogleMLKit` standalone | Direct successor, Firebase-version-independent |
| Async model | Completion handlers | `async/await` + `AsyncStream` | Cleaner code, native Swift Concurrency error handling |
| State | `ObservableObject` + `@Published` | `@Observable` (iOS 17+) or backport | Eliminates boilerplate, finer-grained invalidation |
| Navigation | `NavigationView` | `NavigationStack` | Programmatic routing, deep-linking, state restoration |
| Image loading | `SDWebImageSwiftUI` | Native `AyncImage` + `URLSession` cache | Zero dep, iOS 15+ is already required |
| JSON parsing | `SwiftyJSON` | `Codable` + `FirebaseFirestoreSwift` | Already in Podfile, type-safe, no extra dep |
| HTTP Client | Alamofire | `URLSession` async/await | Simpler for typical REST calls |
| Maps | `NMapsMap` 3.16.0 | `NMapsMap` (SPM) + latest | Same SDK, just via SPM |

## ✨ Core Features</br>
<details>
<summary>Show Contents</summary>

#### Home</br>
> Check out the features you use often and the latest news on one screen.</br>

![](imgs/home.PNG)<br>

#### Associate Stores</br>
> List of affiliates, location, benefits, representative menus, and everything from one touch to the phone.</br>

![](imgs/affiliates.PNG)
![](imgs/affiliates_2.PNG)
![](imgs/affiliates_maps.PNG)
![](imgs/affiliates_details.PNG)<br>

#### Notice</br>
> The quickest way to check student council announcements<br>

![](imgs/notice.PNG)
![](imgs/notice_details.PNG)<br>

#### JBNU Petitions</br>
> Revised school regulations that Shape university regulations with your own hands.<br>

![](imgs/petition.PNG)
![](imgs/petition_details.PNG)<br>

#### Remaining quantity of rental items</br>
> Even if you don't come to the student council room, check the items and rental records at a glance in real time<br>

![](imgs/products.PNG)
![](imgs/producs_log.PNG)<br>

#### Campus Map</br>
> Never get lost on campus again.</br>

![](imgs/campusMap.PNG)<br>

#### Sports mercenary system<br>
> Looking for someone to work out with anytime, anywhere</br>

![](imgs/sports.PNG)<br>

#### HandWriting</br>
> A peek at the successful candidate's secret</br>

![](imgs/handWriting.PNG)<br>

#### Real-time pledge fulfillment rate</br>
> Student council's promise fulfillment rate in real time<br>

![](imgs/pleges.PNG)<br>

#### Feedback Hub</br>
> From school facilities to apps, now make it with your ideas<br>

![](imgs/feedbackHub.PNG)<br>

## Compatibility</br>
> JBNU-CH is compatible with these devices. </br>
### iPhone</br>

> iPhone 15 Pro Max </br>
 iPhone 15 Pro </br>
 iPhone 15 Plus </br>
 iPhone 15 </br>
 iPhone 14 Pro Max </br>
 iPhone 14 Pro </br>
 iPhone 14 Plus </br>
 iPhone 14 </br>
 iPhone SE (3rd-Generation) </br>
 iPhone 13 Pro Max </br>
 iPhone 13 Pro </br>
 iPhone 13 </br>
 iPhone 13 mini </br>
 iPhone 12 Pro Max </br>
 iPhone 12 Pro </br>
 iPhone 12 </br>
 iPhone 12 mini </br>
 iPhone SE (2nd-Generation) </br>
 iPhone 11 Pro Max </br>
 iPhone 11 Pro </br>
 iPhone 11 </br>
 iPhone Xs Max </br>
 iPhone Xs </br>
 iPhone X<sub>R</sub> </br>
 iPhone X </br>
 iPhone 8 Plus </br>
 iPhone 8 </br>
 iPhone 7 Plus </br>
 iPhone 7 </br>
 iPhone SE </br>
 iPhone 6s Plus </br>
 iPhone 6s </br>

### iPad</br>

> iPad Pro 12.9 (6th-Generation) </br>
 iPad Pro 11 (4th-Generation) </br>
 iPad Pro 12.9 (5th-Generation) </br>
 iPad Pro 11 (3rd-Generation) </br>
 iPad Pro 12.9 (4th-Generation) </br>
 iPad Pro 11 (2nd-Generation) </br>
 iPad Pro 12.9 (3rd-Generation) </br>
 iPad Pro 11 </br>
 iPad Pro 12.9 (2nd-Generation) </br>
 iPad Pro 10.5 </br>
 iPad Pro 12.9 (1st-Generation) </br>
 iPad Pro 9.7 </br>
 iPad Air (5th-Generation) </br>
 iPad Air (4th-Generation) </br>
 iPad Air (3rd-Generation) </br>
 iPad Air 2 </br>
 iPad mini (6th-Generation) </br>
 iPad mini (5th-Generation) </br>
 iPad mini 4 </br>
 iPad (10th-Generation) </br>
 iPad (9th-Generation) </br>
 iPad (8th-Generation) </br>
 iPad (7th-Generation) </br>
 iPad (6th-Generation) </br>
 iPad (5th-Generation) </br>

 * Required iOS/iPadOS 15 or up. </br>
 * 500MB or higher storage required for install application.




</details>
