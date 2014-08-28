#DigitalSynth

A digital synthesizer and audio editor programmed in matlab.
Run the app by going into the GUI folder and running testGUI.m

#EPED Requirements
##Basic features
* Quadruple threshold detection
* Setup serial port (serial port auto-find)
* Calibrate (and recalibrate if required)
* Start and stop reading sensor values
* Filtering noise out of sensor values
* Visualization
* Close serial port

##Advanced Features
* Dynamic loading of tones and plugins
* Matlab Synthesizer/Sequencer utility
* Accelerometer controlled UI (Accelerometer manipulates any slider)
* Plugin framework
* Wave visualization

##Main Features
* Customize your tone using the two onscreen oscilators.
* Create your own custom riffs using the built in sequencer.
* Edit your song using the built in effects plugins
* Load in custom tones and effects to further enhance your tune.
* Export your creation to a wav file and share with friends.

###Customizing Your Tone
The tone your sequence will use is determined by the two oscillators located in the bottom
left of the user interface.  Both oscillators have a wave type (sin, square, saw, or custom) as well as adjustable parameters (amplitude, damping, detuning).  Combine two damped sin waves for a soft, smooth tone or pair a sin wave with a sawtooth for more gritty sound.

###Using The Sequencer
The sequencer works using a block structure method. You input a sequence of notes in the sample sequence box as a series of numbers (see note on notes as numbers at the bottom of this section), and these notes can be played back using the "Start Sample" button. Once you are happy with the sequence, you must add the sequence to the current block using the add button.
At any time, if you would like to hear what your current block sounds like, just press the "Start Sample" button. If you would like to hear the current block without the sample sequence you are currently working on, you must also press the "Mute Sequence" radio button. 
If you desire to add another part over top of the sequence that was just added, simply enter another desired sample sequence and press the "Add" button again! This will layer your new sequence over top of the previous one.
If you want to move on to a new block of the song, press the "Append" button. This will place the block you were working on into the entire song and allow you to start working on a new block. 
NOTE: When working on a new block, always remember to press the "Reset Sample" button, unless you wish to include your entire previous block's signal in your next block.
If at any point you would like to listen to your entire song so far, press the "Start Song" button.

* Notes as numbers: 
Each number input into the sequencer is converted into a musical note based on that number's relative distance away from the bass sequence number. When the bass sequence number is 40, the base note is set at middle C. Any numbers entered into the sample sequence box will then be added or subtracted from middle C. For example, if you enter (0 -1 1 2) into your sample sequence with a bass number of 40, your notes will be (C B C# D) around the octave of middle C.
Rests can be done by inputting "r" into the sample sequence.
* Using the bass sequence box effectively: 
The bass sequence box can be used in the same idea as the sample sequence box. You can input a list of numbers such as 40 40 44 40 and it will make your current sample iterate through your sample sequence switching to the next bass number each time.

###Audio Effect Plugins
To use the built-in audio effect plugins, select what portion of the song you want the effect to go to work on by either choosing the entire song or your current selection using the first drop down menu next to the second graph down in the GUI. Next, use the drop down menu below it to choose what effect you would like. Hit the "Apply Effect" button and set your parameters inside the audio effect GUI. Press OKAY inside the audio effect GUI to apply the effect to the desired signal.

###Import Custom Effects and Tones
A great feature of this app is that it allows you to import your own custom tones and effects. It's easy! Here's a few steps to get this to work:
* Create your custom effect or tone m-file and save it in the same MATLAB directory that the app is running in. Make sure that if you are making a custom effect that you also make a GUI to go with it.
* For the custom effects, file names must be in the format: [delayname]GUI
* For the custom tones, you can name the m-file anything you would like
* To load your custom tone into the app, all you have to do is add another line of text into the Waveform Select dropdown menu. For example, if you want to add your custom tone DampedTechno, just add in the text "DampedTechno" on a new line in the dropdown menu.
* To load in a custom effect, the same step is taken as the custom tone. The only difference is the different dropdown menu and the text must be in the format [delayname]. Do NOT include the "GUI" text at the end of the file name.

###Exporting Songs
To export your creation, simply press the Export button in the bottom right of the User Interface.
