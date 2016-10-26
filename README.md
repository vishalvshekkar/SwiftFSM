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

# Further Reading

https://medium.com/sift-through-swift/finite-state-machine-in-swift-ba0958bca34f#.rv8pfot27
