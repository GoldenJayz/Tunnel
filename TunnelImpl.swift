//
//  TunnelImpl.swift
//  Pods
//
//  Created by Jaden Daniels on 7/11/25.
//

import Foundation

@objc public class TunnelImpl: NSObject {
  @objc public func multiply(a: Int, b: Int) -> Int {
    return (a*b)+4
  }
  
  @objc public func connectToTunnel() -> Void {
    print("hi this is connect to tunnel")
  }
  
  @objc public func removeTunnel() -> Void {
    print("hi this is remove tunnel")
  }
}
