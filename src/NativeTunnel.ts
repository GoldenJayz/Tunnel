import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';

export interface Spec extends TurboModule {
  multiply(a: number, b: number): number;
  connectToTunnel(wgConfig: string): Promise<Boolean>;
  removeTunnel(): void;
}

export default TurboModuleRegistry.getEnforcing<Spec>('Tunnel');
