# iOS Disclosure indicators done right

iOS disclosure indicators are hard to get right when you make a universal, that support iPhones and iPads.
On iPad, when using a UISplitViewController, the good practice is to not have disclosures indicators.
On iPhone, you should have them.

Things get even more complicated when you need to change the size class of your app (for example on iPhone 6 plus from landscape to portrait ; or on iPad with two apps side by side)

This sample code is an example of how I would implement the right behavior. I also wrote a [Blog article][blog] that explain how I achieved it, and how it works

[blog]: https://blog.thomasdurand.fr/swift3/ios/2016/08/12/ios-disclosure-indicator-done-right.html
