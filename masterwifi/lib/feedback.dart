import 'package:flutter/material.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _descriptionController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isSubmitEnabled = false;

  @override
  void initState() {
    super.initState();
    // Listeners to update the submit button status
    _descriptionController.addListener(_updateSubmitButtonStatus);
    _emailController.addListener(_updateSubmitButtonStatus);
  }

  void _updateSubmitButtonStatus() {
    setState(() {
      _isSubmitEnabled = _descriptionController.text.isNotEmpty &&
          _emailController.text.isNotEmpty;
    });
  }

  void _handleSubmit() {
    // Handle submit logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Thank you for submitting your feedback!'),
        duration: Duration(seconds: 2), // Duration the snackbar is shown
      ),
    );

    // Optionally, you can clear the text fields after submission
    _descriptionController.clear();
    _emailController.clear();
    Navigator.of(context).pop();
  }

  void _handleClick(String text) {
    // Handle clickable text field
    print('Clicked on: $text');
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // TextArea for Description
              TextField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              // TextField for Contact Email
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Contact Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              // Submit Button
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitEnabled ? _handleSubmit : null,
                  child: Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isSubmitEnabled ? Colors.blue : Colors.grey,
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.04),

              // Clickable TextFields
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildClickableTextField('How to Use'),
                  SizedBox(height: screenHeight * 0.02),
                  _buildClickableTextField('Failed to Connect'),
                  SizedBox(height: screenHeight * 0.02),
                  _buildClickableTextField('Hotspot Sharing'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClickableTextField(String text) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _handleClick(text),
        style: ElevatedButton.styleFrom(
          //  primary: Colors.transparent,
          //  onPrimary: Colors.blue,
          padding: EdgeInsets.symmetric(vertical: 16),
          side: BorderSide(color: Colors.blue),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
