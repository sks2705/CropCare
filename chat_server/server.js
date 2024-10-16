// server.js

const express = require('express');
const http = require('http');
const socketIo = require('socket.io');
const multer = require('multer');
const path = require('path');
const fs = require('fs');

// === Configuration ===

// Define your server's base URL (replace with your actual server IP and port)
const SERVER_BASE_URL = 'http://10.3.168.183:3000'; // e.g., 'http://192.168.1.100:3000'

// Ensure the uploads directory exists
const uploadsDir = path.join(__dirname, 'uploads');
if (!fs.existsSync(uploadsDir)) {
  fs.mkdirSync(uploadsDir);
}

// Set up storage for uploaded files using multer
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, uploadsDir);
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + path.extname(file.originalname)); // e.g., 1633036800000.mp4
  },
});

const upload = multer({ storage: storage });

// === Initialize Express App and HTTP Server ===

const app = express();
const server = http.createServer(app);
const io = socketIo(server);

// Serve static files from the uploads directory
app.use('/uploads', express.static(uploadsDir));

// Middleware to parse JSON and URL-encoded data with increased limits
app.use(express.json({ limit: '100mb' })); // Adjust the limit as needed
app.use(express.urlencoded({ limit: '100mb', extended: true }));

// === Socket.IO Connection Handling ===

io.on('connection', (socket) => {
  const clientIp = socket.handshake.address;
  console.log(`A user connected from IP: ${clientIp}`);

  // Handle text messages
  socket.on('send_message', (message) => {
    console.log(`Message received from ${clientIp}: ${message}`);
    socket.broadcast.emit('receive_message', { message: message, ip: clientIp });
  });

  // Handle image messages
  socket.on('send_image', (data) => {
    console.log(`Image received from ${clientIp}`);
    socket.broadcast.emit('receive_image', { image: data.image, ip: clientIp });
  });

  // Handle video messages
  socket.on('send_video', (data) => {
    console.log(`Video received from ${clientIp}: ${data.video}`);
    socket.broadcast.emit('receive_video', { video: data.video, ip: clientIp });
  });

  // Handle client disconnection
  socket.on('disconnect', () => {
    console.log(`A user disconnected from IP: ${clientIp}`);
  });
});

// === HTTP Routes ===

// Handle video uploads
app.post('/upload_video', upload.single('media'), (req, res) => {
  // Check if file is uploaded
  if (!req.file) {
    console.error('No media file provided.');
    return res.status(400).send({ message: 'No media file provided.' });
  }

  // Get the sender's IP address
  const senderIp = req.ip; // Get the IP of the requester

  // Construct the full media URL
  const mediaUrl = `${SERVER_BASE_URL}/uploads/${req.file.filename}`;

  // Emit the video to all connected clients, except the uploader
  //io.sockets.emit('receive_video', { video: mediaUrl, ip: senderIp });

  // Respond to the uploader with the media path
  res.status(200).send({ mediaPath: mediaUrl });
});


// === Start the Server ===

const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
