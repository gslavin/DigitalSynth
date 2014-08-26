#Statement  of  purpose/broader  impact  of  the  app
* Create a audio sequencer and effects station
* Easy block based composition

#Technical  challenges
* Create matlab audio API that supports generation and manipulation of tones
* Design intuitive user interface that incorporates an accelerometer

#Analysis
## Two Part Design
###Sound API
* Generates audio from tone sequences
* Manipulates audio using effect functions

###GUI
* Wraps the audio API in a user friendly package

#Solutions (Design)
##Basic features
* Setup serial port (serial port auto-find)
* Calibrate (and recalibrate if required)
* Start and stop reading sensor values
* Filtering noise out of sensor values
* Visualization
* Close serial port
* Quadruple threshold detection

##Advanced Features
* Dynamic loading of tones and plugins
* Matlab Synthizizer utility
* Accelerometer controlled UI (Accelerometer manipulates any slider)
* Plugin framework
* Wave visualization


#Limitations
* Plugins cannot be manipulated by accelerometer
* Limited Undo capability
* Workspace cannot be saved
* Only the current block can be edited

