//
//  Category.swift
//  SQLiteDB-iOS
//
//  Created by JACK on 9/8/19.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

#if os(iOS)
	import UIKit
#else
	import AppKit
#endif

class Category: SQLTable {
  var id :Int64 = -1
  var ckid :Int64 = -1
  var myid :Int64 = -1
  var mycusid = ""
	var name = ""
  //var date = ""
  var prize = ""
  //var gover:Date = Date()
  var lototype = 5
  var winners = ""
	
	override var description:String {
		return "id: \(id), name: \(name)"
	}
}
