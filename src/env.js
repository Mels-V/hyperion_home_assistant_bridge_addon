const TOKEN = process.env.SUPERVISOR_TOKEN;
const HA_URL = "http://supervisor/core";
const PORT = parseInt(process.env.HA_BRIDGE_PORT || "41234");
const TRANSITION_DURATION_DIVIDER = parseInt(process.env.HA_DURATION_DIVIDER || "1");
const MAX_BRIGHTNESS = parseFloat(process.env.HA_MAX_BRIGHTNESS || "0.8");

let lights;
try {
    lights = JSON.parse(process.env.HA_LIGHTS);
} catch (error) {
    console.error("Invalid lights configuration:", error);
    process.exit(1);
}

module.exports = { TOKEN, HA_URL, PORT, TRANSITION_DURATION_DIVIDER, MAX_BRIGHTNESS, lights };
