import Tunnel from './NativeTunnel';

export function multiply(a: number, b: number): number {
  return Tunnel.multiply(a, b);
}

export function connectToTunnel(wgConfig: string) {
  return Tunnel.connectToTunnel(wgConfig);
}

export function removeTunnel() {
  return Tunnel.removeTunnel;
}

