Arduino LED Ambient Lighting
========================

###### Presenting Arduino Ambient Lighting System.

Enable a backlight LED ambient system on your monitor/TV controlled via computer or iPhone. You’ll be able to switch lights on/off, control light power or run predefined light pattern changes directly from your iPhone or computer.

Watch it here: https://www.youtube.com/watch?v=3XSnY920Ywg

*********

######This project features smaller projects inside which you may find interesting independently:

- **Arduino power control using transistors**. Follow this tutorial: http://www.ladyada.net/products/rgbledstrip/#introduction Although this tutorial is oriented to RGB LED strips, the connection between Arduino, transistor and a single-LED strip is essentially the same. Just use one transistor instead of three. I’ve used a TIP120 NPN transistor (0,57 €) instead of the N-Channel model it recommends.

- **Serial port communication between Arduino and Objective-C**, taken from http://todbot.com/blog/2006/12/06/arduino-serial-c-code-to-talk-to-arduino/ and added a few lines more.

- **Bonjour discovery and connection** between Server (OS X) and iPhone, taken from  
	- (http://bill.dudney.net/roller/objc/entry/bonjour_network_server_for_iphone) (thanks +Bill Dudney) and
	- http://www.sunsetlakesoftware.com/sites/default/files/MacNetworkingTesting.zip

***********

######Things you need:

- An Arduino Board. (I used Diecimila model).
- A LED strip (hundreds in Dealextreme).
- A transistor (I used a TIP120).
- A Mac or something running OS X. I used Lion 10.7.2.
- Optionally, an iPhone, iPad or iWhatever to run the mobile version.

The **source code** contains:

- Arduino software. Just upload it to the board.
- OS X Arduino controller and Bonjour server. Just change your arduino tty file:

		#define kARDUINO_FILE @"/dev/tty.usbserial-A6004l98" and run it.
		
- iPhone App. Just run it.


-----------

_Note: This project is made for hacking purposes only and expects a straight forward behavior by the user. It doesn’t take into account exceptional situations and the code may be not be optimized._