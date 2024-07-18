# Building and Running the Flutter Application

## Prerequisites:
Before you begin, ensure you have the following installed:
- **Flutter SDK:** Follow the official Flutter installation instructions for your operating system.
- **Dart SDK:** Flutter requires the Dart SDK. It's included with the Flutter SDK, so you don't need to install it separately.
- **Android Studio/VS code or Xcode:** Depending on whether you're targeting Android or iOS, you'll need either Android Studio/VS code or Xcode installed.
## Getting Started:
1. Clone the repository:
	```
	https://github.com/shivangsorout/polaris_test
	```
2. Navigate to the project directory:
	```
	cd <project_directory>
	```
3. Install dependencies:
	```
	flutter pub get
	```
## Running the Application:
- **Android**   
Ensure you have an Android device connected via USB or an Android emulator running.   

- Run the command in terminal:
 ```
 flutter run
 ```
- **iOS**   
Ensure you have a macOS machine with Xcode installed.   

- Run the command in terminal:
 ```
 flutter run
 ```

## AWS Setup for Flutter Application Using Amplify
### Prerequisites
- An AWS account
- AWS Amplify CLI installed
- Flutter SDK installed
- Amplify Flutter packages

### Step 1: Install Amplify CLI
Install the Amplify CLI if you haven't already:
```
npm install -g @aws-amplify/cli
```
### Step 2: Configure Amplify CLI
Run the following command to configure the Amplify CLI:
```
amplify configure
```
Follow the prompts to set up your AWS profile.

### Step 3: Initialize Amplify in Your Project
Navigate to your Flutter project directory and initialize Amplify:
```
amplify init
```
Follow the prompts:
- Enter a name for the project.
- Choose the default editor.
- Choose the type of app (Flutter).
- Choose the default settings for everything else.

### Step 4: Add Amplify Storage
Add storage to your Amplify project:
```
amplify add storage
```
Follow the prompts:
- Select "Content (Images, audio, video, etc.)".
- Provide a friendly name.
- Provide a bucket name.
- Set access as needed.
- Configure settings for authenticated and guest users.

### Step 5: Push Your Changes to AWS
Push the changes to your AWS account:
```
amplify push
```
This will create the necessary AWS resources (S3 bucket, IAM roles, etc.).

Following these steps will help you set up AWS Amplify in your Flutter application for efficient image storage and synchronization.
## Additional Notes
- Error Handling: Implement robust error handling to manage upload failures.
- Security: Secure your AWS credentials and ensure your bucket policies follow best practices.

By following these instructions, you'll be able to build, run, and configure the Flutter application to use the AWS S3 securely.
