import { Text, View, StyleSheet } from 'react-native';
import { multiply, connectToTunnel, removeTunnel } from 'tunnel';

const result = multiply(3, 7);
const res = connectToTunnel();

export default function App() {
  
  console.log(res)

  res().then(e => console.log(e))
  .catch(e => console.error(e))
  console.log(removeTunnel())
  // console.log(result);
  return (
    <View style={styles.container}>
      <Text>Result: {result}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    color: "white",
    paddingTop: 50,
    backgroundColor: "white"
  },
});
