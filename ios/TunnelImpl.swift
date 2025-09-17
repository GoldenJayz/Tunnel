import Foundation
import NetworkExtension
import React

@objc public
class TunnelImpl: NSObject {
    @objc
    public func connectToTunnel(_ resolve: @escaping RCTPromiseResolveBlock,
                  reject: @escaping RCTPromiseRejectBlock) {
        NETunnelProviderManager.loadAllFromPreferences { managers, error in
            if let error = error {
                reject("LOAD_ERROR", "Failed to load VPN managers", error)
                return
            }

            let manager = managers?.first ?? NETunnelProviderManager()
            let proto = NETunnelProviderProtocol()
            proto.providerBundleIdentifier = "org.auruminnovations.FixYourMusic.network-extension" // extension bundle ID
            proto.serverAddress = "WireGuard"

            // 👇 Pass the config string as plain data
            let wgConfig = """
            [Interface]
            PrivateKey = AGf4e+GnRh1ODnDoJotXQUVJjN4vb3PjVtl9oHXuQkg=
            Address = 10.10.11.11/24
            DNS = 8.8.8.8, 1.1.1.1

            [Peer]
            PublicKey = fq8r9sLIjOo3h0qrCXRo4dbf6ZPXyz0ImR2KrKqe0V0=
            AllowedIPs = 0.0.0.0/0
            Endpoint = 167.99.124.49:51820
            """

            proto.providerConfiguration = ["WgQuickConfig": wgConfig]

            manager.protocolConfiguration = proto
            manager.localizedDescription = "My WireGuard VPN"
            manager.isEnabled = true

            manager.saveToPreferences { error in
                if let error = error {
                    reject("SAVE_ERROR", "Could not save VPN prefs", error)
                    return
                }

                do {
                    try manager.connection.startVPNTunnel()
                    resolve("VPN started")
                } catch {
                    reject("START_ERROR", "Could not start VPN tunnel", error)
                }
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

