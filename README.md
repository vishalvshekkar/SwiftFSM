![alt tag](https://raw.githubusercontent.com/vishalvshekkar/SwiftFSM/master/SwiftFSMBannerFinal.png)

I needed a finite state machine for a game I was developing in Swift 3. I checked out other FSMs developed in Swift, but, they were either heavy or were not yet ported to Swift 3. Hence, SwiftFSM came about.

I intended SwiftFSM to be a single-file implementation. I also needed it to scale up to the needs of a complex FSM that my game required. SwiftFSM could achieve all that and still be generalized to support all kinds of states and triggers only because of the power of Swift's protocols and generics.

# Features

- **Type Agnostic** - States and Triggers could be represented by any type. Enums, structs (Int, String...) and so on. This gives a lot of leeway to represent states and triggers based on your requirement. All the FSM cares about is if you are able to distinguish between two state or two trigger objects.
- **Closures** - Closures are used instead of delegates to bring about cleaner and a more readable code.
- **Alerts** - Callback for state changes.
- **Allows Exceptions** - Callback before a state change to optionally block a state change.
- **Freedom in Logging** - Logging with custom methods possible.
- **Freedom in Schema Object** - The schema object can be created externally by conforming to a protocol. This lets you add custom functionality to the schema object.

# Installation

Download the .zip and extract the files. Open the project in Xcode 8+. Check out the Turnstile example demonstrated in the project by running the project. Drag and Copy the file 'SwiftFSM.swift' to your own project and use it.

# Build Instructions

Yes. This is a wall of text, but it’s a pretty simple solution for an annoying problem.

The example project is configured to code sign the app. For code signing, you need a valid Apple Developer code signing certificate in your keychain, and you need to specify your Apple Developer Program TeamID in the build settings of an Xcode project. 

To do this, create a new file `DEVELOPMENT_TEAM.xcconfig` in your working copy and add the following build setting to the file:

```
DEVELOPMENT_TEAM = [Your TeamID]
```

The `DEVELOPMENT_TEAM.xcconfig` file should not be added to any git commit. The `.gitignore` file will prevent it from getting committed to the repository. 

See the file `Xcode-Config/Shared.xcconfig` for a more detailed explanation of how to set this up for this or for your own projects. 

A big thank-you goes to [Jeff Johnson](https://github.com/lapcat/Bonjeff) who has come up with this way of handling the `DEVELOPMENT_TEAM` issue for open-source projects. 

Without the above solution, every developer would have to change the `DEVELOPMENT_TEAM` for themselves and keep the change from getting into version control. Otherwise, every other developer would get conflicts and non-working builds. 

# Further Reading

https://medium.com/sift-through-swift/finite-state-machine-in-swift-ba0958bca34f#.rv8pfot27
