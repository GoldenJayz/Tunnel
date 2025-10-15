#import "Tunnel.h"
#import <Tunnel/Tunnel-Swift.h>

@implementation Tunnel {
  TunnelImpl *moduleImpl;
}
RCT_EXPORT_MODULE()

// function calla corresponding to TunnelImpl.swift
- (instancetype) init {
  self = [super init];
  if (self) {
    moduleImpl = [TunnelImpl new];
  }
  return self;
}
- (NSNumber *)multiply:(double)a b:(double)b {
    NSNumber *result = @(a * b);
  // return result;
  return @([moduleImpl multiplyWithA:a b:b]);
}

- (void)connectToTunnel:(NSString *)wgConfig resolve:(RCTPromiseResolveBlock)resolve
                            reject:(RCTPromiseRejectBlock)reject
{
  return [moduleImpl connectToTunnelWithWgConfig:wgConfig resolve:resolve reject:reject];
}

- (void)removeTunnel {
  return [moduleImpl removeTunnel];
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeTunnelSpecJSI>(params);
}

@end
