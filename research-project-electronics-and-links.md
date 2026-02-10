# Sourcing Electronics for your Project

If you are to build your wearable from scratch, you'll need to source parts.  Sure, you might be able to find what you need on Amazon, but I'd like to encourage you to consider the links that I have provided below.  No, I do not have any affiliation, these are just companies that I know and trust.  But before we get into that, let's talk about _what_ you'll need!

## Microprocessor
There is a good chance that you'll need a microprocessor of some sort.  This will serve as the data coordinator.  Some sensors can be plugged into a USB port, but even more make use of I2C, SPI (both of which are a serial communication protocol), or even an analog interface.  If you have a mix of these, you really will need something to get data from each and then save or transmit that data to where you can use it.

### Arduino
The easiest, by far, is to use an Arduino.  Arduino is (fairly) easy to learn to program.  Further, there is a plethora of documentation of "how-tos" on the internet.  Arduino can speak I2C, SPI, analog, binary logic, and UART (USB / rs232) through it's General Purpose Input / Output (GPIO) pins.  In 50 lines of code or less, you can coordinate data collection, can build up a "packet" with formatted data, and send it back to the computer or to a microsd card.

### Raspberry Pi
Not quite as easy, but incredibly functional, is the Raspberry Pi.  A Pi gives you a full GNU Linux stack, which is awesome, but might be overkill.  Like the Arduino, the PI has a General Purpose Input / Output (GPIO).  If you are planning a project that requires a USB sensor, super high sample rate, real-time calculation from semi-complex models, or time synchronization between multiple nodes, the Pi might be for you.  But if you don't need those, you might find an Arduino still meets or even exceeds your expectations.

### Processing.org
Okay, so Processing.org is not a microprocessor.  Processing.org is an integrated development environment (IDE) for desktop applications.  It makes serial interfacing really easy and uses a language dang similar to Arduino.  Arduino is based on Wiring (C/C++).  Processing is based on Java.  [Wikipedia / Processing](https://en.wikipedia.org/wiki/Processing)

### Data Storage
You'll need to save your collected data somewhere.  You could send this over USB to your computer and capture it all there in the Arduino or Processing.org IDEs, or ... save it to a microsd card.  I'm going to be specific in this suggestion - consider using an OpenLog.

### Time Tracking
You may need to record when your sample was taken.  If so, look for a Real Time Clock that supports I2C or SPI.  These can be used to set the time on your Raspberry Pi or to record a start time on an Arduino.  Generally, they are easy to work with.  Clever code might even make use of querying the time every few thousand samples, so as to account for clock drift on your microprocessor.

## Sensors
Here are a few sensors you may want to consider.  This list isn't exhaustive, but instead focuses on the sensors that are relatively easy to work with.

### Accelerometers / Rate Gyroscopes / Inertial Measurement Units (IMUs)
Accelerometers measure linear acceleration.  Rate gyroscopes measure rotational movement.  And IMUs combine those with (typically) a magnetometer that measures magnetic fields (which way is North?).  Most of these units support I2C or SPI, and some support analog out.  I2C and SPI make interfacing easy.  Suppose you wanted to count steps, an accelerometer could get you there.

### Photoplethysmography (PPG) Heart Rate
These little units can measure your heart rate through optical deformations in your skin when your heart beats.  We can throw a pulse oximeter in here too, which measures your bloods oxygen saturation with a similar technology.  Like the accelerometers, output types vary.

### Bend or Pressure
Bend / flex sensors and pressure / force sensors typically vary their resistance according to the bend or pressure applied.  These are easy to use, assuming that your microprocessor has an analog to digital converter (ADC), which the Arduino does!  These sensors typically have some negligible hysteresis.  If you expect to need to know the exact force, or bend, applied, these might not be for you.  But if you need to know the ballpark, they are cheap and easy to use!

### Strain or Force Gauges
Strain gauges, which I want to call "real" force sensors, can measure applied forces with substantial accuracy.  If you wanted to calculate the ground reaction force on a person's foot, this would be a great choice.  If on the other hand you just needed to identify if a person has ground contact or not, a pressure sensor might be a better choice.

### Sonar or Infrared Distance
Sonar and infrared are two different technologies, though they can both be used to calculate distance to an object.  In our case, it's likely that sonar would be more helpful, as sonar works at human scale distances, while infrared works at finger scale.  Many sonar units output a timed pulse, though some also speak serial protocols.  Timing can be critical with these, and missing data can become an issue if your microprocessor is under powered for you tasks.

### Sound
Should you want to capture the relative noise in the environment of a user, there are some microphone units that support an analog voltage output that corresponds to the relative loudness.  This is much easier to use than the microphones audio signal, which changes very quickly (up to 20,000 times a second).

### Light
Ambient light, or photo resistors, allow you to measure the intensity of light.  This can be helpful in determining if a person is indoors or out.

### Electromyography (EMG)
EMG sensors are typically more than just the sensors.  EMG units typically measure the differential voltage between two electrodes placed on the skin.  If those electrodes are placed over a muscle, they can detect the muscle activation.  But here's the challenge to them.  First, repeated placement location.  Small changes to where they are placed can make or break the muscle activation detection.  Second, skin moves when you do!  Pick a spot in roughly your mid forearm and place your fingers on it. Now rotate your wrist.  Do you always feel the exact same muscle, tendon, or bones underneath?  Probably not.  These sensors are really neat, a lot of fun to use, but also can be noisy.  Just be prepared for that if you want to measure muscle activation.

### Others
You are welcome to use other sensors that I have not outlined above.  I suggest these because of the availability and ease of use.

## Where do I get my sensors?
I am a big fan of [Sparkfun](https://www.sparkfun.com/sensors.html) and [Adafruit](https://www.adafruit.com/category/35).  Both provide solid examples of how to use their breakout boards.  On that note, get breakout boards (these have all the electronics for the sensor on a single printed circuit board) when ever possible.  The exceptions might be the flex, pressure, and light sensors.