# Test task for the company **PROEXE**
Czerwiec 2018  
<br> 

## Part 1
Typical workload: 1-2 hour<br>
Branch: **MVP-version**


**The smartphone test application will be divided in two parts:**

1. A master part that displays items from the json array available at *client.proexe.eu/json.json* <br>
Each item cell will contain a text (name fields from ws) and an image (image fields from ws). Each cell takes as much width as possible. The image is on the left of the text. The content is aligned to the left of the cell.<br>
A touched cell will have a blue background with white text (for the time of being touched). A selected cell will have a red background with white text. Normal cells will have a transparent background with black text.<br>
When the user clicks on a cell it will launch a second screen displaying details.

2. A detail part containing again an image and a text.<br>
When running on a tablet in landscape mode , the master and detail will be displayed in the same screen (**taking 50% of width each**). In that case, the displayed item of the detail part will be selected in the master part.<br>

The first item of the master part should be selected by default. When running on a tablet in portrait mode the app will work **the same as on a smartphone**.<br>

You are allowed to use external libraries if needed.<br>

Use cases: The following use cases WILL BE tested against your application.

* Launch the application on a tablet. Turn the tablet in portrait. The master part is displayed alone in portrait. Click on a cell. The detail screen should be displayed in portrait. Turn the tablet in landscape. The master and detail part should be displayed with the previously selected cell selected and displayed.<br>
typical failure : the detail part is displayed alone in landscape <br>

* App will restore its state without crashing. Connect your device to your computer and launch DDMS. Navigate in the app. For each screen, click on the iOS home button. kill the application process with DDMS. Launch back the application via the recent applications screen. The app should be restored where it was left and with the same data displayed.<br>
typical failure: the app crash or is not displaying the previously displayed information <br>
