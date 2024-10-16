import 'dart:io'; // To get the local IP address
import 'dart:convert';
import 'package:agri_easy/video_player_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

void main() {
  runApp(const HelpDesk());
}

class HelpDesk extends StatelessWidget {
  const HelpDesk({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ChatPageA(),
    );
  }
}

class ChatPageA extends StatefulWidget {
  const ChatPageA({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPageA> {
  late IO.Socket socket;
  final List<dynamic> messages = [];
  String serverIp = "10.3.168.183"; // Change this to your server's IP
  int serverPort = 3000;
  final TextEditingController messageController = TextEditingController();
  bool isConnected = false;
  String localIp = '';
  final ImagePicker _picker = ImagePicker();

  // New state variable to track video upload status
  bool isUploadingVideo = false;
  bool _isDownloading = false; // Indicates if a download is in progress
  String _videoPath = ''; // Store the path of the downloaded video

  @override
  void initState() {
    super.initState();

    _getLocalIp();
    _initializeSocket();
    _initializeBackgroundExecution();
  }

  Future<void> _initializeBackgroundExecution() async {
    await FlutterBackground.initialize(
      androidConfig: FlutterBackgroundAndroidConfig(
        notificationTitle: 'Chat App Background',
        notificationText: 'Running in Background',
        notificationIcon:
            AndroidResource(name: 'ic_launcher', defType: 'mipmap'),
      ),
    );
    FlutterBackground.enableBackgroundExecution();
  }

  Future<void> _getLocalIp() async {
    for (var interface in await NetworkInterface.list()) {
      for (var addr in interface.addresses) {
        if (addr.type == InternetAddressType.IPv4 && !addr.isLoopback) {
          setState(() {
            localIp = addr.address;
          });
          if (kDebugMode) {
            print('Local IP: $localIp');
          }
          return;
        }
      }
    }
  }

  void _initializeSocket() {
    socket = IO.io('http://$serverIp:$serverPort', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.onConnect((_) {
      setState(() {
        isConnected = true;
      });
      print('Connected to the server.');
    });

    socket.onDisconnect((_) {
      setState(() {
        isConnected = false;
      });
      print('Disconnected from the server.');
    });

    socket.on('receive_message', (message) {
      if (message['ip'] != localIp) {
        setState(() {
          messages.add({
            'type': 'text',
            'content': message['message'],
            'sender': message['ip'],
          });
        });
      }
    });

    socket.on('receive_image', (data) {
      if (data['ip'] != localIp) {
        setState(() {
          messages.add({
            'type': 'image',
            'content': data['image'],
            'sender': data['ip'],
          });
        });
      }
    });

    socket.on('receive_video', (data) {
      if (data['ip'] != localIp) {
        setState(() {
          messages.add({
            'type': 'video',
            'content': data['video'], // Ensure this matches server's emit
            'sender': data['ip'],
          });
        });
      }
    });

    socket.on('connect_error', (error) {
      print('Connection Error: $error');
    });
  }

  void _sendTextMessage() {
    if (messageController.text.isNotEmpty) {
      socket.emit(
        'send_message',
        messageController.text,
      );
      setState(() {
        messages.add({
          'type': 'text',
          'content': 'You: ${messageController.text}',
          'sender': 'user',
        });
      });
      messageController.clear();
    }
  }

  Future<void> _sendMedia() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      final image = img.decodeImage(bytes);
      final resizedImage = img.copyResize(image!, width: 800);
      final compressedBytes = img.encodeJpg(resizedImage, quality: 80);

      // Emit the image to the server
      socket.emit(
        'send_image',
        {'image': base64Encode(compressedBytes)},
      );
      setState(() {
        messages.add({
          'type': 'image',
          'content':
              base64Encode(compressedBytes), // Store as base64 for local use
          'sender': 'user',
        });
      });
    } else {
      print('No media selected.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image selected.')),
      );
    }
  }

// Other imports...

  Future<void> _sendVideo() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      final confirmSend = await _showConfirmationDialog();

      if (confirmSend) {
        setState(() {
          isUploadingVideo = true; // Start uploading
        });

        try {
          // Create a multipart request
          var request = http.MultipartRequest(
            'POST',
            Uri.parse('http://$serverIp:$serverPort/upload_video'),
          );

          // Add the video file to the request
          request.files.add(
            await http.MultipartFile.fromPath('media', pickedFile.path),
          );

          // Send the request
          final response = await request.send();

          if (response.statusCode == 200) {
            final mediaPath = await response.stream.bytesToString();
            final mediaUrl = jsonDecode(mediaPath)['mediaPath'];

            // Emit video URL to socket
            socket.emit(
              'send_video',
              {
                'video': mediaUrl,
                'ip': localIp,
              },
            );

            setState(() {
              messages.add({
                'type': 'video',
                'content': mediaUrl,
                'sender': 'user',
              });
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Video uploaded successfully!')),
            );
          } else {
            print('Failed to upload video: ${response.reasonPhrase}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text('Failed to upload video: ${response.reasonPhrase}')),
            );
          }
        } catch (e) {
          print('Error uploading video: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error uploading video: $e')),
          );
        } finally {
          setState(() {
            isUploadingVideo = false; // Upload complete
          });
        }
      } else {
        print('Video sending canceled.');
      }
    } else {
      print('No video selected.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No video selected.')),
      );
    }
  }

  // Helper method to show confirmation dialog
  Future<bool> _showConfirmationDialog() async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Send Video'),
          content: const Text('Are you sure you want to send this video?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Send'),
            ),
          ],
        );
      },
    ).then(
        (value) => value ?? false); // Return false if the dialog is dismissed
  }

  void _openSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SettingsPage(
          currentIp: serverIp,
          currentPort: serverPort.toString(),
          onSave: (newIp, newPort) {
            setState(() {
              serverIp = newIp;
              serverPort = int.tryParse(newPort) ?? serverPort;
            });
            _initializeSocket();
          },
        ),
      ),
    );
  }

  void _openFullImage(String mediaPath) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullImageScreen(mediaPath: mediaPath),
      ),
    );
  }

  void _openVideoPlayer(String videoUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            VideoPlayerPage(videoPath: videoUrl), // Ensure this matches
      ),
    );
  }

  @override
  void dispose() {
    socket.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Color.fromARGB(255, 0, 100, 3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'Help and Support',
          style: TextStyle(
              fontFamily: "Lobster",
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _openSettings,
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Connection Status
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      //color: isConnected ? Colors.green : Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  //Text(isConnected ? 'Connected' : 'Disconnected'),
                ],
              ),
              const SizedBox(height: 8),
              // Messages List
              Expanded(
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];

                    if (message['type'] == 'text') {
                      return Align(
                        alignment: message['sender'] == 'user'
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          margin: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: message['sender'] == 'user'
                                ? const Color.fromARGB(255, 94, 195, 102)
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Text(
                            message['content'],
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      );
                    } else if (message['type'] == 'image') {
                      return Align(
                        alignment: message['sender'] == 'user'
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () => _openFullImage(message['content']),
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            margin: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 10.0),
                            decoration: BoxDecoration(
                              color: message['sender'] == 'user'
                                  ? const Color.fromARGB(255, 94, 195, 102)
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Image.memory(
                              base64Decode(message['content']),
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    } else if (message['type'] == 'video') {
                      return Align(
                        alignment: message['sender'] == 'user'
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            // Initiate download on tap
                            if (!_isDownloading) {
                              setState(() {
                                _isDownloading = true; // Set downloading status
                              });

                              // Show a loading screen and delay the download
                              showDialog(
                                context: context,
                                barrierDismissible:
                                    false, // Prevent closing the dialog by tapping outside
                                builder: (BuildContext context) {
                                  return Center(
                                    child:
                                        CircularProgressIndicator(), // Show a loading spinner
                                  );
                                },
                              );

                              // Add a delay before starting the download (e.g., 2 seconds)
                              Future.delayed(const Duration(seconds: 0), () {
                                Navigator.of(context)
                                    .pop(); // Close the loading screen

                                _downloadVideo(message[
                                    'content']); // Start the download process after delay

                                setState(() {
                                  _isDownloading =
                                      false; // Reset the downloading status
                                });
                              });
                            } else {
                              // If already downloading, do nothing or show a message
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('Downloading in progress...')),
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            margin: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 10.0),
                            decoration: BoxDecoration(
                              color: message['sender'] == 'user'
                                  ? const Color.fromARGB(255, 94, 195, 102)
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: _isDownloading
                                ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<
                                                Color>(
                                            const Color.fromARGB(255, 36, 175,
                                                48) // Color of the loading indicator
                                            ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "Loading ...",
                                        style: TextStyle(color: Colors.black),
                                      ), // Download status text
                                    ],
                                  )
                                : Icon(
                                    Icons.videocam, // Show video icon
                                    size: 50,
                                    color: Colors.black,
                                  ),
                          ),
                        ),
                      );
                    }

                    // Placeholder for other message types

                    return const SizedBox.shrink();
                  },
                ),
              ),
              // Message Input
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    8.0, 8.0, 8.0, 65.0), // Outer padding
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 1.0, // Custom padding for the left side
                        right: 8.0, // Custom padding for the right side
                        top: 12.0, // Custom padding for the top
                        bottom: 4.0, // Custom padding for the bottom
                      ), // Adjust this padding around the Builder
                      child: Builder(
                        builder: (BuildContext context) {
                          return IconButton(
                            icon: const Icon(Icons.attach_file),
                            onPressed: () async {
                              // Calculate the position of the button
                              final RenderBox button =
                                  context.findRenderObject() as RenderBox;
                              final RenderBox overlay = Overlay.of(context)
                                  .context
                                  .findRenderObject() as RenderBox;

                              // Define the bottom padding for the popup menu
                              const double bottomPadding =
                                  180.0; // Adjust this value as needed

                              // Calculate position above the bottom panel with the specified gap
                              final RelativeRect position =
                                  RelativeRect.fromRect(
                                Rect.fromPoints(
                                  button.localToGlobal(
                                      Offset(0,
                                          button.size.height + -bottomPadding),
                                      ancestor: overlay),
                                  button.localToGlobal(
                                    Offset(
                                        button.size.width,
                                        button.size.height +
                                            bottomPadding), // Right edge for width
                                  ),
                                ),
                                Offset.zero & overlay.size,
                              );

                              // Show the popup menu
                              final result = await showMenu<String>(
                                context: context,
                                position:
                                    position, // Positioned above the bottom with a gap
                                items: [
                                  // PopupMenuItem for Image with custom padding
                                  PopupMenuItem<String>(
                                    value: 'Image',
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12.0, horizontal: 16.0),
                                      child: Row(
                                        children: const [
                                          Icon(Icons.image,
                                              color: Color.fromARGB(
                                                  255, 36, 175, 48)),
                                          SizedBox(width: 8),
                                          Text('Send Image'),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // PopupMenuItem for Video with custom padding
                                  PopupMenuItem<String>(
                                    value: 'Video',
                                    enabled: !isUploadingVideo,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12.0, horizontal: 16.0),
                                      child: Row(
                                        children: const [
                                          Icon(Icons.videocam,
                                              color: Colors.red),
                                          SizedBox(width: 8),
                                          Text('Send Video'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );

                              // Handle the result
                              if (result != null) {
                                if (result == 'Image') {
                                  _sendMedia(); // Function to send image
                                } else if (result == 'Video') {
                                  if (!isUploadingVideo) {
                                    _sendVideo(); // Function to send video
                                  }
                                }
                              }
                            },
                          );
                        },
                      ),
                    ),
                    // Message TextField
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        decoration: const InputDecoration(
                          hintText: 'Type a message...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Send Text Message Button
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _sendTextMessage,
                    ),
                    // Common Media Button (Image & Video)
                  ],
                ),
              ),
            ],
          ),
          // Loading Overlay for Video Upload
          if (isUploadingVideo)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text(
                      'Uploading Video...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _downloadVideo(String url) async {
    try {
      // Fetch the video from the URL
      final response = await http.get(Uri.parse(url));

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Get the application's document directory
        Directory appDocDir = await getApplicationDocumentsDirectory();
        String filePath = '${appDocDir.path}/downloaded_video.mp4';

        // Create a file and write the video content to it
        File videoFile = File(filePath);
        await videoFile.writeAsBytes(response.bodyBytes);
        _videoPath = filePath; // Store the path of the downloaded video

        // Inform the user that the video has been downloaded
        print('Video downloaded to: $_videoPath');
        // You can implement playback here or notify the user
        _openVideoPlayer(_videoPath); // Automatically play after downloading
      } else {
        // Handle the error
        print('Error downloading video: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions
      print('An error occurred while downloading video: $e');
    } finally {
      // Reset the downloading status
      setState(() {
        _isDownloading = false; // Reset downloading status
      });
    }
  }

  // Method to open the video player
}

class SettingsPage extends StatelessWidget {
  final String currentIp;
  final String currentPort;
  final Function(String, String) onSave;

  const SettingsPage({
    Key? key,
    required this.currentIp,
    required this.currentPort,
    required this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ipController = TextEditingController(text: currentIp);
    final portController = TextEditingController(text: currentPort);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Server IP TextField
            TextField(
              controller: ipController,
              decoration: const InputDecoration(labelText: 'Server IP'),
            ),
            const SizedBox(height: 10),
            // Server Port TextField
            TextField(
              controller: portController,
              decoration: const InputDecoration(labelText: 'Server Port'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            // Save Button
            ElevatedButton(
              onPressed: () {
                onSave(ipController.text, portController.text);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

class FullImageScreen extends StatelessWidget {
  final String mediaPath;

  const FullImageScreen({Key? key, required this.mediaPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Full Image'),
      ),
      body: Center(
        child: PhotoView(
          imageProvider: MemoryImage(base64Decode(mediaPath)),
        ),
      ),
    );
  }
}

// VideoListScreen widget to display the list of videos

class VideoListScreen extends StatelessWidget {
  final List<String> videoUrls;

  VideoListScreen({required this.videoUrls});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Video List')),
      body: ListView.builder(
        itemCount: videoUrls.length,
        itemBuilder: (context, index) {
          final videoUrl = videoUrls[index];
          return ListTile(
            title: Text('Video ${index + 1}'),
            subtitle: Text(videoUrl),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(
                      videoPath: videoUrl), // Pass the video URL correctly
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class VideoPlayerScreen extends StatelessWidget {
  final String videoPath;

  VideoPlayerScreen({required this.videoPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Video Player')),
      body: Center(
        // Add your video player widget here
        child: Text('Playing video: $videoPath'),
      ),
    );
  }
}

// VideoPlayerScreen widget to play the video

// Entry point
// void main() {
//   runApp(MaterialApp(
//     home: VideoListScreen(
//       videoUrls: [
//         'https://www.example.com/video1.mp4', // Replace with actual video URLs
//         'https://www.example.com/video2.mp4',
//         // Add more video URLs here
//       ],
//     ),
//   ));
// }

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({Key? key, required this.controller})
      : super(key: key);

  static const _iconSize = 50.0;
  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (controller.value.isPlaying) {
          controller.pause();
        } else {
          controller.play();
        }
      },
      child: Stack(
        children: <Widget>[
          if (!controller.value.isPlaying)
            Center(
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: _iconSize,
              ),
            ),
        ],
      ),
    );
  }
}
