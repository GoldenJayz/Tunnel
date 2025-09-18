import Foundation
import NetworkExtension
import React

@objc public
class TunnelImpl: NSObject {
    @objc
    public func connectToTunnel(_ resolve: @escaping RCTPromiseResolveBlock,
                  reject: @escaping RCTPromiseRejectBlock) {
      // We use loadAllFromPreferences to see if this app has already added a tunnel
      // to iOS Settings or (macOS Preferences)
      NETunnelProviderManager.loadAllFromPreferences { tunnelManagersInSettings, error in
          if let error = error {
              NSLog("Error (loadAllFromPreferences): \(error)")
              resolve(false)
              return
          }
          
          // If the app has already added a tunnel to Settings, we are going to modify that.
          // If not, we create a new instance and save that to Settings.
          // We will always have either 0 or 1 tunnel only in Settings for this app.
        print(tunnelManagersInSettings?.count)
          let preExistingTunnelManager = tunnelManagersInSettings?.first // grabs the first tunnel manager
          let tunnelManager = preExistingTunnelManager ?? NETunnelProviderManager()
          

        
              tunnelManager.loadFromPreferences { error in
                  if let error = error {
                      NSLog("Error (loadFromPreferences): \(error)")
                      resolve(false)
                      return
                  }
                  
                  // At this point, the tunnel is configured.
                  // Attempt to start the tunnel
                  do {
                      NSLog("Starting the tunnel")
                      guard let session = tunnelManager.connection as? NETunnelProviderSession else {
                          fatalError("tunnelManager.connection is invalid")
                      }
                    print(session)
                      try session.startTunnel()
                    
                  } catch {
                      NSLog("Error (startTunnel): \(error)")
                      resolve(false)
                  }
                  resolve(true)
              }
          }
    
  }
  @objc public func multiply(a: Int, b: Int) -> Int {
    return (a * b) + 17
  }

  @objc public func removeTunnel() {
    print("remove tunnel")
  }
}

