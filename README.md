# Currency Rates App
----------------

###  Prerequisites 

- You need [CocoaPods](https://guides.cocoapods.org/using/getting-started.html#installation) installed
    ```terminal
    $ sudo gem install cocoapods
    ```

### How to build

All 3rd party libraries should be installed **before** opening any project files. It should be done after each update from git. 
```terminal
$ cd currency-app
$ pod install
```

3rd party lIbraries are continuously updated by their developers and may change behavior, get new bugs and fixes. Library versions may be explicitly defined in `Podfile` and in companion file `Podfile.lock`, which lists explicit library versions that were installed by developer on his machine. It can be used to track regressions when libraries were updated.

Libraries are downloaded into `Pods` directory aside of project and is already added to gitignore. Do not edit anything manually in this directory as its content is managed by `CocoaPods`

- Open `CurrencyApp.xcworkspace` with Xcode;
- In the top-right select `target`, you are interested in `CurrencyApp`;
- Next to it select `device` - it may be `Simulator` or `real device`;
- Select menu `Product - Build (Cmd-B)` to build selected `target` for selected `device`;
- Click `Run` button or press `Cmd-R` to build and run selected `target` for selected `device`;

### How to run

If previous section passed successfully, then you may have been able to build and run app on your device or simulator;
If you are not developer, run on `real device` may **fail** for you in case if your device [`UDID`](http://whatsmyudid.com/) was not registered on [Apple Developer portal](https://developer.apple.com) page. 

iOS device can run app in case if it was `signed` by Apple, and it is true for installation from App Store. Also it can be installed when signed using `development` certificate + profile via cable from Xcode (what developer actually does on debug). And last of most popular ways to install `ipa` file built and signed with `production` certificate + profile. Last two options require real device `UDID` to limit real users count that can have app build bypassing App Store review, we call such users `testers` or `friends`, they cannot use real in-app purchases and may see test ads.

Registering a device has some bottlenecks with quantity-per-year limitations, thus ask actual developer to perform this step for you if you prefer `real device experience` over check on `simulator`.
