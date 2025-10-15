import Foundation
import NetworkExtension
import React

@objc public
class TunnelImpl: NSObject {
  @objc
  public func connectToTunnel(wgConfig: String, resolve: @escaping RCTPromiseResolveBlock,
                  reject: @escaping RCTPromiseRejectBlock) {
      // We use loadAllFromPreferences to see if this app has already added a tunnel
      // to iOS Settings or (macOS Preferences)
    //d
    NSLog("the configggg")
    NSLog(wgConfig)
      NETunnelProviderManager.loadAllFromPreferences { tunnelManagersInSettings, error in
          if let error = error {
              NSLog("Error (loadAllFromPreferences): \(error)")
              resolve(false)
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
          protocolConfiguration.providerBundleIdentifier = "org.auruminnovations.FixYourMusic.network-extension"

          // Set the server address as a non-nil string.
          // It would be good to provide the server's domain name or IP address.
          protocolConfiguration.serverAddress = "167.99.124.49"

          let wgQuickConfig = """
[Interface]
PrivateKey = AGf4e+GnRh1ODnDoJotXQUVJjN4vb3PjVtl9oHXuQkg=
Address = 10.10.11.11/24
DNS = 8.8.8.8, 1.1.1.1

[Peer]
PublicKey = fq8r9sLIjOo3h0qrCXRo4dbf6ZPXyz0ImR2KrKqe0V0=
AllowedIPs = 0.0.0.0/0
Endpoint = 167.99.124.49:51820
"""

          protocolConfiguration.providerConfiguration = [
              "wgQuickConfig": wgConfig
          ]

          tunnelManager.protocolConfiguration = protocolConfiguration
          tunnelManager.isEnabled = true

          // Save the tunnel to preferences.
          // This would modify the existing tunnel, or create a new one.
          tunnelManager.saveToPreferences { error in
              if let error = error {
                  NSLog("Error (saveToPreferences): \(error)")
                  resolve(false)
                  return
              }
              // Load it back so we have a valid usable instance.
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
                      try session.startTunnel()
                  } catch {
                      NSLog("Error (startTunnel): \(error)")
                      resolve(false)
                  }
                  resolve(true)
              }
          }
      }
  }
  @objc public func multiply(a: Int, b: Int) -> Int {
    return (a * b) + 17
  }

  @objc public func removeTunnel() {
    print("remove tunnel")
    NETunnelProviderManager.loadAllFromPreferences { tunnelManagersInSettings, error in
      if let error = error {
        NSLog("Error (loadAllFromPreferences): \(error)")
        return
      }
      if let tunnelManager = tunnelManagersInSettings?.first {
        guard let session = tunnelManager.connection as? NETunnelProviderSession else {
          fatalError("tunnelManager.connection is invalid")
        }
        switch session.status {
        case .connected, .connecting, .reasserting:
          NSLog("Stopping the tunnel")
          session.stopTunnel()
        default:
          break
        }
      }
    }
  }
}

