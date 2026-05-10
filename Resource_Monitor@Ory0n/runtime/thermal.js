import { convertTemperature } from "./metrics.js";

export function buildCpuTemperatureDisplay(results, preferredUnit, mode = "average") {
  let values = [];

  results.forEach((result) => {
    if (result.status !== "fulfilled") {
      return;
    }

    const temperature = parseInt(new TextDecoder().decode(result.value), 10);
    if (!isNaN(temperature)) {
      values.push(temperature / 1000);
    }
  });

  if (values.length === 0) {
    return null;
  }

  let resultTemperature;
  switch (mode) {
    case "highest":
      resultTemperature = Math.max(...values);
      break;
    case "lowest":
      resultTemperature = Math.min(...values);
      break;
    case "average":
    default:
      resultTemperature = values.reduce((a, b) => a + b, 0) / values.length;
      break;
  }

  const [value, unit] = convertTemperature(resultTemperature, preferredUnit);

  return {
    value,
    unit,
  };
}
