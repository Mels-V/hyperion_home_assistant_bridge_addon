const dgram = require("node:dgram");
const os = require("os");
const server = dgram.createSocket("udp4");
const { getConfig } = require("./get-config.js");
const { lights } = getConfig();
const light_loop = require("./light-loop.js");
const latest_color = require("./latest_color.js");
const { TOKEN, PORT, MAX_BRIGHTNESS } = require("./env.js");

function getIPAddress() {
  const interfaces = os.networkInterfaces();
  for (const name of Object.keys(interfaces)) {
    for (const iface of interfaces[name]) {
      if ('IPv4' !== iface.family || iface.internal !== false) {
        continue;
      }
      return iface.address;
    }
  }
  return '127.0.0.1';
}

// Handle uncaught exceptions and unhandled rejections
process.on('uncaughtException', (err) => {
  console.error('❌ Uncaught Exception:', err);
  process.exit(1); // exit the process to avoid undefined states
});

process.on('unhandledRejection', (reason, promise) => {
  console.error('❌ Unhandled Rejection:', reason);
  process.exit(1); // exit the process to avoid undefined states
});

server.on("error", (err) => {
  console.error(`❌ Server Error:\n${err.stack}`);
  server.close();
});

const debug = false;

if (!TOKEN) {
  throw new Error(
    "❌ Provide the Home Assistant Long Lived Token as a HA_TOKEN environment variable. Go to /profile in Home Assistant and scroll down."
  );
}

console.log(
  `ℹ️ Remember to set the Hyperion output controller type to UDPRAW and set it to output ${lights.length} lights`
);

server.on("message", (msg, rinfo) => {
  latest_color.set(Array.from(msg).map((e) => parseInt(e)));
  if (debug) {
    console.log("📩 Received colors:", latest_color.get());
  }
});

server.on("listening", async () => {
  const address = server.address();
  const ipAddress = getIPAddress();
  console.log(`✅ Server is now listening on ${ipAddress}:${address.port}`);
  for (let i in lights) {
    console.log(`🔄 Starting light loop for light ${parseInt(i) + 1} (${lights[i].id}) with max brightness of ${MAX_BRIGHTNESS}`);
    light_loop(i, MAX_BRIGHTNESS, debug);
  }
});

server.bind(PORT);
