>Capstone Project - "TechWishList"

This is the final project app for Udacity's iOS developer Nanodegree.
Tl;Dr:
-Tap Add to add an item(provide details).
-Search YouTube using Inspiration Button.
-Tap Items Photo to see/edit it.
-Data is saved using coreData.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

"TechWishList" provides a simple interface for creating, editing, and easily accessing all of your tech item wishlist. 
It is like a notepad page with the tech products you wish to acquire in the near future.
When the app is launced for the first time, an empty page is displayed. 
Pressing the "Add" button takes you to a screen(Add Tech Scene) where you can enter items name, specifications and preferences, as well as add a photo of your techie-item using your Phone's camera, or choose a photo from camera roll (Clicking on the picture view).
After entering the item's info (all fields optional), tapping "Save" saves the item to Core Data and navigates you back to the item list, where the newly created item is now visible.
The app keeps track of item's by their names. Each item must have a unique name, and if you try to add an item with a duplicate title, the app will prevent this from happening.
Clicking on a saved item takes you to that item's details. Tapping "Edit" at the top of this screen allows you to modify your saved item's title, photo, specs, and or preferences.
Tapping "Save" saves these updates in Core Data, immediately.
This app has the added capability of letting you search for and discover brand new tech items by searching for and watching YouTube videos. 
Tapping "InspirationList" takes you to a search screen where you can search for YouTube videos by keyword.
Tapping search sends the keyword query to YouTube's data API, which returns a list of videos whose title and or description match the user's search. 
These results are displayed in a table view.
When you select a particular YouTube video from the table view, a screen will be displayed that
automatically starts playing the YouTube video in-line on the screen.
(YouTube video playback was achieved by using https://github.com/youtube/youtube-ios-player-helper.)
You can add the item described in a particular YouTube video by tapping the "Add To Your Techs" button.
Doing this takes you to the "Add Tech" screen, where the item's title and image fields are pre-populated with the YouTube video's title and thumbnail image, respectively(isn't that cool!).
After adding the specs and prefs, tapping "Save" saves the item on Core Data. 

To build and run this app:
1. Open the zip
2. Open the '.xcodeproj' file in Xcode and press the Run button.
3. Profit?