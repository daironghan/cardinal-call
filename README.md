# CardinalCall
This app aims to help users identify bird species by analyzing their calls using real-time audio matching. Inspired by music identification tools like Shazam, this project will use Apple’s ShazamKit to create an offline audio catalog of bird calls, focusing specifically on species native to the Stanford area. 

## Features

### Real-time Bird Call Identification
- Tap the microphone button to record nearby bird calls.  
- The app automatically matches the sound to a known species.  
- Tap on the bird’s name to open its detailed bird card.  

<p float="left">
    <img src="https://github.com/daironghan/cardinal-call/blob/main/Screenshots/Simulator%20Screenshot%20-%20iPhone%2016%20Pro%20-%202025-08-23%20at%2021.40.03.png?raw=true" width="30%" />
    <img src="https://github.com/daironghan/cardinal-call/blob/main/Screenshots/Simulator%20Screenshot%20-%20iPhone%2016%20Pro%20-%202025-08-23%20at%2021.40.35.png?raw=true" width="30%" />
    <img src="https://github.com/daironghan/cardinal-call/blob/main/Screenshots/Simulator%20Screenshot%20-%20iPhone%2016%20Pro%20-%202025-08-23%20at%2021.40.21.png?raw=true" width="30%" />
</p>


### Bird Information Card
- Displays an image of the bird along with basic details.  
- Includes a link to the species page on [allaboutbirds.org](https://www.allaboutbirds.org).  

<img src="https://github.com/daironghan/cardinal-call/blob/main/Screenshots/Simulator%20Screenshot%20-%20iPhone%2016%20Pro%20-%202025-08-23%20at%2021.41.06.png?raw=true" width="30%" />

### Automatic History Tracking
- Each successful match is saved automatically.  
- Includes the date, time, and location of the observation.  
- Users can filter history by date or bird name.  
- History records can be deleted.

<p float="left"> 
    <img src="https://github.com/daironghan/cardinal-call/blob/main/Screenshots/Simulator%20Screenshot%20-%20iPhone%2016%20Pro%20-%202025-08-23%20at%2023.39.09.png?raw=true" width="30%" />
    <img src="https://github.com/daironghan/cardinal-call/blob/main/Screenshots/Simulator%20Screenshot%20-%20iPhone%2016%20Pro%20-%202025-08-23%20at%2022.02.57.png?raw=true" width="30%" />
    <img src="https://github.com/daironghan/cardinal-call/blob/main/Screenshots/Simulator%20Screenshot%20-%20iPhone%2016%20Pro%20-%202025-08-23%20at%2022.03.08.png?raw=true" width="30%" />
</p>

### Map View
- Displays all historical matches on a map.  
- Each bird species is assigned a unique color.  
- Includes a legend for quick reference.

<img src="https://github.com/daironghan/cardinal-call/blob/main/Screenshots/Simulator%20Screenshot%20-%20iPhone%2016%20Pro%20-%202025-08-23%20at%2022.03.37.png?raw=true" width="30%" />

### Explore View
- Browse a list of common birds around Stanford.  
- Pin your favorite species for quick access.

<img src="https://github.com/daironghan/cardinal-call/blob/main/Screenshots/Simulator%20Screenshot%20-%20iPhone%2016%20Pro%20-%202025-08-23%20at%2021.39.51.png?raw=true" width="30%" />

### Persistent Storage
- All data (history, pinned, etc.) is stored locally and remains available after restarting the app.  


## BirdCatalogGenerator
This is a command line application that generates the shazam catalog needed for CardinalCall. 
### Running the Generator
1. Open the project in **Xcode**.  
2. Place your `.mp3` or `.wav` bird call files into a folder.  
3. Update the file directory path inside the generator:  
    ```swift=
    let birdCallsDir = URL(fileURLWithPath: "Your_Bird_Call_Audio_Files_Directory_Here", isDirectory: true)
    ```
Run the project.
## Limitations
- ShazamKit Sensitivity:
    - ShazamKit is optimized for matching music recordings, not natural bird calls.
    - Matches require the input audio to be extremely similar to the catalog recording (same pitch, tempo, and background conditions).
    - Variations in call length, overlapping sounds, or noisy environments often prevent successful matches.
- Device Constraints:
    - Matching requires offline catalogs, which must fit within device storage limits.

## Future Work
- Expand the catalog beyond Stanford to cover a wider range of species.
- Add support for playback of previous recordings from history.
- Explore machine learning models trained specifically on bird calls.

## Resources
- [Bird calls audio](https://xeno-canto.org/) 
- [Bird info](https://www.birds.cornell.edu/home/)
- [Stanford bird info](https://web.stanford.edu/group/stanfordbirds/text/uspecies/tax_species.html)
- [Bird Images](https://unsplash.com/)
