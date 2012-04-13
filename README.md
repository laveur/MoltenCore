#Project

##MoltenCore

A Collection of Utilities/Base Classes and other Tid-Bits to make Programming for iOS/OS X easier.

MoltenCore iis an Objective-C Framework that provides additional functionality like Data Modeling Classes for 
JSON and XML. It also includes Classes for implementing Webservice clients.

The Data Modeling system is intended to be used when CoreData can't be used. Like for instance when you make a 
webservice call, at present I am not sure you can take the JSON or XML that is returned and create Core Data 
Objects based on them. This is where my code steps in. Its fully KVC Compliant which means to a certain degree 
that it works with Bindings, NSArrayController, and NSTreeController. It also is designed so that you can 
instantiate entire trees/graphs of data models from a single init call. I think that this is a very powerful 
concept.

The Webservices component to this is designed to be very very flexible, and completely asynchronous. Its a little 
weird and break away from some tried and true programming things. Like Delegates based on @protocol's. But I've 
had many issues with doing Webservices like this. Mainly if you want your Webservice to be created as a singleton 
object you run into issues when you start a call, and waiting for it to return and the user switches something in 
your application causing the delegate object to be changed. Its a good way to cause a crash. My code solves this 
problem, and allows for rapid development and testing.

###Features
####Webservices
* Support for REST/XML-RPC/JSON-RPC 2.0
* Support for Fully Asynchronous Calls
* Method Queuing (Allows for multiple calls to run concurrently)
* Multi-threaded
* Support for Singleton classes (Single instance classes) without having issues when delegates change rapidly as the program runs.

####Data Modeling
* Support for XML Data Models (OS X Only)
* Support for JSON Data Models

####Other
* JSON parsing through JSONKit
* In memory data caching
* MD5 Hashing of Strings and Data
