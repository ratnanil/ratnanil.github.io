
  // Create a non-dom allocated Audio element
var au = document.createElement('audio');

// Define the URL of the MP3 audio file
au.src = "https://ukw.fm/podlove/file/497/s/feed/c/mp3/ukw087-corona-weekly-goldene-triade.mp3";

// Once the metadata has been loaded, display the duration in the console
au.addEventListener('loadedmetadata', function(){
    // Obtain the duration in seconds of the audio file (with milliseconds as well, a float value)
    var duration = au.duration;

    // example 12.3234 seconds
    console.log("The duration of the song is of: " + duration + " seconds");
    // Alternatively, just display the integer value with
    // parseInt(duration)
    // 12 seconds
},false);
