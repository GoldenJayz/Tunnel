//
//  TunnelImpl 2.swift
//  Pods
//
//  Created by Jaden Daniels on 7/17/25.
//


//
//  TunnelImpl.swift
//  Pods
//
//  Created by Jaden Daniels on 7/11/25.
//

import Foundation
import NetworkExtension

@objc public class TunnelImpl: NSObject {
  @objc public func multiply(a: Int, b: Int) -> Int {
    return (a*b)+17
  }
  
  
  @objc public func removeTunnel() {
    print("remove tunnel")
  }
  
  @objc public func connectToTunnel(completionHandler: @escaping (Bool) -> Void) -> Void {

           // We use loadAllFromPreferences to see if this app has already added a tunnel
  // to iOS Settings or (macOS Preferences)
  NETunnelProviderManager.loadAllFromPreferences { tunnelManagersInSettings, error in
  if let error = error {
     NSLog("Error (loadAllFromPreferences): \(error)")
     completionHandler(false)
     return
  }

  // If the app has already added a tunnel to Settings, we are going to modify that.
  // If not, we create a new instance and save that to Settings.
  // We will always have either 0 or 1 tunnel only in Settings for this app.
  let preExistingTunnelManager = tunnelManagersInSettings?.first
  let tunnelManager = preExistingTunnelManager ?? NETunnelProviderManager()

  // Configure the custom VPN protocol
  let protocolConfiguration = NETunnelProviderProtocol()

  // Set the tunnel extension's bundle id
  protocolConfiguration.providerBundleIdentifier = "<your app identifier>.network-extension"

  // Set the server address as a non-nil string.
  // It would be good to provide the server's domain name or IP address.
  protocolConfiguration.serverAddress = "server"

  let wgQuickConfig = """
  [Interface]
  PrivateKey = your private key
  Address = address
  DNS = dns

  [Peer]
  PublicKey = pub key
  PresharedKey = preshared if you have
  Endpoint = endoint with port
  AllowedIPs = 0.0.0.0/0,::/0
  """

  protocolConfiguration.providerConfiguration = [
     "wgQuickConfig": wgQuickConfig
  ]

  tunnelManager.protocolConfiguration = protocolConfiguration
  tunnelManager.isEnabled = true

  // Save the tunnel to preferences.
  // This would modify the existing tunnel, or create a new one.
  tunnelManager.saveToPreferences { error in
     if let error = error {
         NSLog("Error (saveToPreferences): \(error)")
         completionHandler(false)
         return
     }
     // Load it back so we have a valid usable instance.
     tunnelManager.loadFromPreferences { error in
         if let error = error {
             NSLog("Error (loadFromPreferences): \(error)")
             completionHandler(false)
             return
         }

         // At this point, the tunnel is configured.
         // Attempt to start the tunnel
         do {
             NSLog("Starting the tunnel")
             guard let session = tunnelManager.connection as? NETunnelProviderSession else {
                 fatalError("tunnelManager.connection is invalid")
             }
             try session.startTunnel()
         } catch {
             NSLog("Error (startTunnel): \(error)")
             completionHandler(false)
         }
         completionHandler(true)
        }
      }
    }
  }

}
