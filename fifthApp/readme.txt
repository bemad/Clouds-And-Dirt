>Second Last Project - "Virtual Tourist"

This is the 5th project for Udacity's iOS developer Nanodegree.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

"Virtual Tourist" provides a simple interface for storing and displaying Flickr images from certain area with use of mapview. 
When the app is launched for the first time, an empty map is displayed.
Long pressing triggers a gesture which drops a pin on map. User can keep on dropping pins. Pins so dropped will be saved even if the app is closed. This is achieved using CoreData functionality which stores latitude and longitude of each pin. Each time the app is opened a fetch-request is sent to retrieve saved pins. If some pins are found then they are displayed.

Tapping on the Edit button changes its text to "Done" and flips the variable canBeDeleted. After clicking the edit button the user can tap on the pins and those pins will be removed.Also, it is removed from db so when app is re-opened it does not load the deleted pin.

Tapping on a pin triggers a new segue which opens CollectionViewController. This View-Controller has a mapView, a collection-view and a new collection Button. mapView displays a zoomed in region of the pin.The Collection view shows the images and new collection button, well fetches new photos.
The collection view further has an imageView and an activity indicator. The response from Flickr contains images which are displayed here. These images are also stored locally on users device.
So when the app is re-opened photos are revived from the DB. Pressing the New Collection button retrieves more images from Flickr and deletes the previous ones.

To build and run this app:
1. Open the zip
2. Open the '.xcodeproj' file in Xcode and press the Run button.