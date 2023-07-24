import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Tutorial extends StatefulWidget {
  const Tutorial({Key? key});

  @override
  State<Tutorial> createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize the YouTube video controller
    _controller = YoutubePlayerController(
      initialVideoId: 'dQw4w9WgXcQ',
      flags: YoutubePlayerFlags(
        autoPlay: true,
      ),
    );
  }

  @override
  void dispose() {
    // Dispose the YouTube video controller
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios,color: Colors.black,)),
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text('Tutorial',style: TextStyle(color: Colors.black),),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            'Tutorial Steps',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                StepItem(
                  stepNumber: 1,
                  title: 'Step 1: Lorem ipsum dolor sit amet',
                  description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                ),
                StepItem(
                  stepNumber: 2,
                  title: 'Step 2: Sed do eiusmod tempor incididunt',
                  description: 'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                ),
                StepItem(
                  stepNumber: 3,
                  title: 'Step 3: Ut enim ad minim veniam',
                  description: 'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                ),
                StepItem(
                  stepNumber: 4,
                  title: 'Step 4: Duis aute irure dolor in reprehenderit',
                  description: 'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
                ),
                StepItem(
                  stepNumber: 5,
                  title: 'Step 5: Excepteur sint occaecat cupidatat non proident',
                  description: 'Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Video Tutorial',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: false,
          ),
        ],
      ),
    );
  }
}

class StepItem extends StatelessWidget {
  final int stepNumber;
  final String title;
  final String description;

  const StepItem({
    required this.stepNumber,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Color.fromRGBO(53, 85, 235, 1),
        child: Text(stepNumber.toString()),
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(description),
    );
  }
}
