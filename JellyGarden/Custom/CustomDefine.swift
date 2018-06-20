//
//  CustomDefine.swift
//
//  Created by zzy on 2018/4/10.
//  Copyright © 2018年 zzy. All rights reserved.
//

import Foundation
import UIKit

//沙盒路径

//iTunes会自动备份此目录
let documentPath:String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
//iTunes不会自动备份此目录
let libraryPath:String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
//iTunes不会自动备份此目录
let cachePath:String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]

var User_Path = "\(documentPath)/User"//用户信息路径



let ScreenWidth:CGFloat = UIScreen.main.bounds.size.width
let ScreenHeight:CGFloat = UIScreen.main.bounds.size.height


let kFont_SmallNormal = kFont_system13
let kFont_Normal = UIFont.systemFont(ofSize: 15)
let kFont_system10 = UIFont.systemFont(ofSize: 10);
let kFont_system11 = UIFont.systemFont(ofSize: 11);
let kFont_system12 = UIFont.systemFont(ofSize: 12);
let kFont_system13 = UIFont.systemFont(ofSize: 13);
let kFont_system14 = UIFont.systemFont(ofSize: 14);
let kFont_system15 = UIFont.systemFont(ofSize: 15);
let kFont_system16 = UIFont.systemFont(ofSize: 16);
let kFont_system17 = UIFont.systemFont(ofSize: 17);
let kFont_system18 = UIFont.systemFont(ofSize: 18);
let kFont_system19 = UIFont.systemFont(ofSize: 19);
let kFont_system20 = UIFont.systemFont(ofSize: 20);
let kFont_system21 = UIFont.systemFont(ofSize: 21);
let kFont_system22 = UIFont.systemFont(ofSize: 22);
let kFont_system23 = UIFont.systemFont(ofSize: 23);


let SCALE = ScreenWidth / 320.0







let alertTitle = "提示"
let alertWarmTitle = "温馨提示"
let alertConfirm = "确定"
let alertCancel = "取消"












