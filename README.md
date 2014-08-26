#DigitalSynth

A digital synthesizer and audio editor programmed in matlab.

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

* Notes as numbers
Each number input into the sequencer is converted into a musical note based on that number's relative distance away from the bass sequence number. When the bass sequence number is 40, the base note is set at middle C. Any numbers entered into the sample sequence box will then be added or subtracted from middle C. For example, if you enter (0 -1 1 2) into your sample sequence with a bass number of 40, your notes will be (C B C# D) around the octave of middle C.
Rests can be done by inputting "r" into the sample sequence.
* Using the bass sequence box effectively
The bass sequence box can be used in the same idea as the sample sequence box. You can input a list of numbers such as 40 40 44 40 and it will make your current sample iterate through your sample sequence switching to the next bass number each time.

###Audio Effect Plugins
Explain how the effect effects plugins work

###Import Custom Effects and Tones


###Exporting Songs
To export your creation, simply press the Export button in the bottom right of the User Interface.
