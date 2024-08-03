# Image OCR to JSON

## Objective

This project extracts text from an image and converts it into JSON format.

## Features

- **Image Capture**: Take a photo with your camera or pick an image from your gallery.
- **OCR Processing**: Use OCR technology to read and extract text from the image.
- **JSON Conversion**: Turn the extracted text into a structured JSON format.
- **Display/Export JSON**: View the JSON data in the app and export it if needed.

## Requirements

1. **Image Capture**
   - Capture images using the camera or select them from the gallery.

2. **OCR Processing**
   - Extract readable text from the selected or captured image.

3. **JSON Conversion**
   - Convert the text into a well-organized JSON format.

4. **Display/Export JSON**
   - Show the JSON data on the screen and offer an option to export it.

## Evaluation Criteria

- How well the app integrates with the camera and gallery.
- The effectiveness of the OCR in extracting text.
- The accuracy and organization of the JSON data.
- The overall quality of the code and documentation.

## Packages Used

- `image_picker`: To select images from the gallery or take new ones.
- `flutter_image_compress`: To compress images if needed.
- `http`: For handling network requests.
- `shared_preferences`: To store simple data locally.
- `provider`: For managing app state.
- `printing`: To print or export data.
- `path_provider`: To find commonly used locations on the device.
- `permission_handler`: To handle permissions for accessing the camera and gallery.

## Font

- **Poppins**: Used for text in the app.

## State Management

- **Provider**: Manages the state of the application.

## Installation

1. Clone the repository:
   ```sh
   git clone <repository-url>
