class FarmingAdvice {
  static String getAdvice({
    required double temp,
    required int humidity,
    required double windSpeed,
    required String condition,
  }) {
    // 🌾 TOO HOT
    if (temp > 40) {
      return "⚠ Not good for farming (Extreme heat). Water crops carefully.";
    }

    // 🌧 RAINY
    if (condition.toLowerCase().contains("rain")) {
      return "✅ Good for farming (Natural irrigation from rain).";
    }

    // 💨 HIGH WIND
    if (windSpeed > 25) {
      return "⚠ Not good for spraying or irrigation (High wind).";
    }

    // 💧 LOW HUMIDITY + HIGH TEMP
    if (humidity < 25 && temp > 35) {
      return "⚠ Dry conditions (Need irrigation). Not ideal for crops.";
    }

    // 🌱 PERFECT RANGE
    if (temp >= 20 && temp <= 35 && humidity >= 30 && humidity <= 70) {
      return "✅ Excellent farming conditions today.";
    }

    return "ℹ Moderate farming conditions.";
  }
}