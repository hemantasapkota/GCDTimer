[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

### GCDTimer ###
Grand Central Dispatch (GCD) Timer in Swift

### Usage - Long running timer ###

```
import GCDTimer

class Demo {

  init() {
    let timer = GCDTimer(intervalInSecs: 20)
    
    timer.Event = {
      println("Hello World")
      
      // Send some data to the server
    }
    
    timer.start()
    
    //Don't forget to pause the timer in the AppDelegate:applicationWillResignActive(application: UIApplication) method.
  }

}

```

### Usage - Autofinishing timer ###

```
import GCDTimer

class Demo {

  init() {
    let timer = GCDTimer(intervalInSecs: 2)
    
    timer.Event = {
      timer.pause()
      //Process after finishing the timer
    }
    
    timer.start()
  }
  
}
```

### Installation ###

* Add ```github "hemantasapkota/GCDTimer"``` to your ```cartfile```
* Execute ```carthage update```

