# Ground Station 2019

This project is a data processing and command center for a remotely operated
telemetry device, run by software such as [cs2019](https://github.com/sf314/cs2019).

It was created in Xcode and runs as a macOS application. 

## Quick start

Simply open the project file in Xcode and hit the `Run` button. Export the 
project as a native Mac app by "archiving" the project. 

[to be completed]


## Explanation of software components

This project was designed around a single main file, `ViewController.swift`, 
with lots of extra files to support it. 


### ViewController.swift

This file defines the "main" class, called `ViewController`. It entirely 
handles the user interface and serial commands. Crucially, I very strongly use
`extension` in Swift to extend the class definition across multiple files:

- `ViewController.swift`: the main code logic, i.e. for declaring UI, buttons, 
etc. All variables must be declared in this file (not in extension files). 
- `SerialEvents.swift`: extends ViewController to add all the serial protocol
functions of ORSSerialPort. I didn't want to pollute the main file with this 
stuff, so I put it all here. Everything here is technically still part of the
ViewController class. 
- `ConfigureLayout.swift`: extends ViewController to add all the UI for the
graphs, and to make sure they're laid out properly. The rest of the UI is in
the Storyboard. Everything here is technically still part of the ViewController
class. 
- `UpdateGraphs.swift`: extends the ViewController to add the functions 
necessary for updating all of the graphs. It basically works by adding a new
point to each graph in the `graphs` array. Not all graphs line up nicely to 
telem fields, so I unfortunately couldn't just loop thru it. Everything here is 
technically still part of the ViewController class. 
- `UpdateLabels.swift`: extends the ViewController to add the function 
necessary for updating all of the telemetry labels (in the left sidebar). 
Everything here is technically still part of the ViewController class. 


### Panel.swift

`Panel` is the base class for all the graphs that I create, so all `GraphView`s 
are of type `Panel`. This is basically an abstraction so I can easily control 
(and often override) the background color of all the graphs using `setColor()`.


### Model.swift

This file is the place where I define all the data structures and utilities 
for the project. This includes the `Telemetry` and `TelemetryField` classes, a
`Parser` class (used for handling serial data), 

If adapting this project for future use, you should only really need to change
the Telemetry class to change the fields to fit the mission, and the Parser
class. Also, look for the configuration variables at the top of the file.


### FileWrite.swift

This is a simple class that I wrote that saves telemetry to a file. When you
start the ground station, the very first thing it does is create and open a 
new telemetry file. Then, as we parse out more data, I add a line to this file.


### GraphView.swift

This is a the class that is responsible for displaying the individual graphs.
Each GraphView stores an array of points and a name. When you add a new data
point and refresh the graph (call `updateDisplay()`), the list of points will 
draw themselves, going from right to left (rightmost point is the most recent).

The function `ViewController.updateGraphs(using: telem)` is responsible for
updating all the graphs at once using the latest telemetry object (defined in
`UpdateGraphs.swift`).


## External dependencies

### ORSSerialPort

ORSSerialPort is a free and open-source library, written in Objective-C, for 
using USB serial communications on macOS. It is the only external dependency of 
this project, and the requisite bridging header is provided here for you 
in order to expose the Objective-C functions as Swift functions. 

ORSSerialPort is basically just a protocol (think "interface" in Java). 

You should not have to interact with ORSSerialPort at all, as the SerialEvents
extension implements all the protocol methods for you.

The only functions you should care about in this library are:

- `func serialPort(_ serialPort: ORSSerialPort, didReceive data: Data)`: this 
function gets called whenever data is received from the USB port! Thus, all
of the data parsing stuff starts here. You can see that I do a simple check
that the data is a String type, before I start parsing it. Who knows, you might
randomly get junk binary data sometimes. 
- `@IBAction func connect(_ sender: Any)`: I created this function to handle 
the `Connect` button in the UI. It looks at the name of your serial port 
selection and tries to `open()` or `close()` the port with that name. 

Both of these functions can be found in `SerialEvents.swift`.