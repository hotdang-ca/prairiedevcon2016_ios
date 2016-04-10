# prairiedevcon2016_ios
Prairie Dev Con 2016 Unofficial iOS App; uses [prairiedevcon2016_web](https://github.com/hotdang-ca/prairiedevcon2016_web) API and  sample data, available at [HotDang Interactive](https://hotdang.ca/pdc2016/sampledata.sqlite).

Uses Cocoapods for:
* [RestKit](https://github.com/RestKit/RestKit) - Object Mapping to NSObject/NSManagedObject
* [BlocksKit](https://github.com/zwaldowski/BlocksKit) - Near-functional programming without the memory leaks of ReactiveCocoa
* [IHKeyboardAvoiding](https://github.com/IdleHandsApps/IHKeyboardAvoiding) - because i'm lazy and this just works.
don't forget to `pod install`.

Uses icons from [IconFinder](http://www.iconfinder.com)

I'm not a designer, but here are some shots:

![Session List](http://hotdang.ca/pdc2016/session_list.png)
Session List. Each Cell may or may not have other cells to swipe-right/left toward. 

![Session List Alt](http://hotdang.ca/pdc2016/session_list_2.png)
You can also favorite a session.

![Session Details](http://hotdang.ca/pdc2016/session_details.png)
Session details. Link to notes, favorite, and hey, Speaker is tappable...

![Session Speaker Details](http://hotdang.ca/pdc2016/speaker_details.png)
About as good of UI as I can get. I need help. But hey, there's some sessions for that speaker down there!

![Notes](http://hotdang.ca/pdc2016/speaker_notes.png)
Leave notes on Sessions or on Speakers.
