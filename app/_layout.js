import { Stack } from "expo-router"

const RootLayout = () => {
  return (
    <Stack
      screenOptions={{
        headerStyle: {
          backgroundColor: 'yellow',
        },
        headerTintColor: '#000',
        headerTitleStyle: {
          fontWeight: 'bold',
        },
      }}>
        <Stack.Screen name="(screens)" options={{headerShown: false}} />
        {/* <Stack.Screen name="index" /> */}
    </Stack>
  )
}

export default RootLayout