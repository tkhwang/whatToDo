import { Auth } from "@/components/Auth";
import { View, Text } from "react-native";

export default function login() {
  return (
    <View className="flex-1 justify-center items-center">
      <Auth />
    </View>
  );
}
