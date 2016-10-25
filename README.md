# SwiftFSM

I needed a finite state machine for a game I was developing in Swift 3. I checked out other FSMs developed in Swift, but, they were either heavy or were not yet ported to Swift 3. Hence, SwiftFSM came about.

I intended SwiftFSM to be a single-file implementation. I also needed it to scale up to the needs of a complex FSM that my game required. SwiftFSM could achieve all that and still be generalized to support all kinds of states and triggers only because of the power of Swift's protocols and generics.

# Features

- Enums used for states and triggers.
- Closures bring about cleaner code.
- Callback for state changes.
- Callback before a state change to optionally prevent a state change.
- Logging with custom methods possible.
- The schema object can be created externally by conforming to a protocol. This lets you add custom functionality to the schema object.

# Installation

Download the .zip and extract the files. Open the project in Xcode 8+. Check out the Turnstile example demonstrated in the project by running the project. Drag and Copy the file 'SwiftFSM.swift' to your own project and use it.
