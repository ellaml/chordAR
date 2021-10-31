# ChordAR

## Description

ChordAR is a mobile application, which provides an easy and intuitive way of learning guitar chords.

The app displays visual instructions for where the user's fingers 
should be positioned in order to play chords, in real time, using the device's front camera.

The app was built using Flutter. The image processing is written in Python, utilizing the OpenCV library.

## Integration of Python and Flutter
- Preview the camera
- For every second:
  1. Take a frame
  2. Call Python script of image processing using chaquopy package of Flutter.
  3. Get from the script the coordinates of the notes of the chord in json format.
  4. Draw the coordinates on the revlant places on the preview of the camera.

All the related files of the image processing are at "integrateFlutterOpenCV/android/app/src/main/python".

'script.py':
  - Gets the frame from the local storage of the device
  - Run image processing with openCV to identify the coordinates of a certain chord of the guitar in the frame
   return json in the following format:
 
 ```
 {
     "notes_coordinates":[
      {
         "x":"1",
         "y":"2"
      },
      {
         "x":"20",
         "y":"30"
      },
      {
         "x":"50",
         "y":"10"
      }
    ],
    "numOfNotes":"3",
    "chordName":"A"
}
``` 
x = coordinate x of the note

y = coordinate y of the note

numOfNotes = The number of the notes of the chord
  
