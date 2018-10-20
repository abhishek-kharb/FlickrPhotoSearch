# Flickr Photo Search Implementation

This project implements the photo search API of Flickr and displays the results in an infinite collection view.  
Note: This project is a part implementation of the architecture described in [this](https://blog.hike.in/building-your-own-design-pattern-55064b5f5926) blog post written by me.  
Following are some of the main components of the architecture used in this project:

## FlickrNetworkHandler:
* This class is responsible for making network calls to the server, to fetch search results of the text entered by user. It conforms to the **FlickrNetworkHandlerProtocol** wherein we define interface methods that the outside world uses to interact with this class.

## FlickrDataSource:
* This class is the single source of truth for providing any data needed by the outside world. Any implementation detail of how this data is stored is internal to this class, and the outside world knows nothing about it. It conforms to the **FlickrDataSourceProtocol** through which data can be accessed.

## FlickrViewController:
* This is the central component of the architecture, and binds all components together.  
* It's initialised with a data source conforming to a protocol, which this class will use to access any data it needs.  
* This class initialises view components, like the collection view, search bar etc. and listens to all the callbacks from these views, and takes appropriate actions.  

## FlickrPhotoDataModel:
* This class is the data model for a photo fetched. It contains all information needed to fetch the image from the server like the secret, photo identifier etc.

## FlickrPhotoDataManager:
* All the photos fetched by the server are cached on the client within this class. Anytime an image is needed by the cell to render in its view, this class internally first checks in its in memory cache, and if not found, asks the FlickrNetworkHandler to fetch that asset. It then updates its cache and returns the image.

## FlickrPhotoSearchResponseValidator:
* Any checks needed to be put on the response data before adding it to the data source go into this class.
* As of now we only validate the info needed to construct the URL to fetch the image, but more checks can be added on scaling the project, say checking for Title, Owner etc.

## FlickrHeader:
All the protocols and typedefs that are needed throughout the project are added to this header file. This file is added to the pch file of the project to avoid being imported everywhere.

### Requirements
* iOS 10.0 and above.

## License
[MIT](https://choosealicense.com/licenses/mit/)
