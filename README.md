### Build the Project
There is no special need to build the project.

However, buiding without some element will cause some function not working:

- if there is no internet connection, there will be no score shown in `ScoreListsViewController`
- if user does not agree with using of location, the scores showin in `ScoreListsViewController` will be based on position (0,0)

### General Purpose Implementation

##### use of a database
There is a prepared database: db.sqlite3.
Upon program start in `AppDelegate.swift`, we will try to copy it to `/Document/db.sqlite3`.

Then it will be used in `Score.swift`.
We are using a library called `SQLite.swift`. It packaged all the SQLite C interface in a swift way.

The usage of the database is to store the score user got and show the highest score user ever got.

##### use of network/web services (Partly implemented)
The network part is used in `ScoreListsViewController.swift`.
Now we implemented GET (fake) user score list from server based on location.
However, the PUT user score part haven't been implemented yet.

##### use of location services
The location service is used in `Location.swift`
It gets the user location and stored in its signleton instance.
When `ScoreListsViewController.swift` GET the user score list, it use the location information to fetch list nearby.

##### use of email services
The email service is used in `StartViewController.swift`
The feedback button in start screen starts an email composition.

##### use of animation
The animation is used via `SKAction` in `SpriteKit` in `GameScene.swift`
It happens during all the game.

##### use of multi-threading
Our usage of multi-threading is based on `session.dataTaskWithRequest` which use another queue and when complete, reload table data in the main queue.


##### use of camera-related services (Not Implemented)
We didn't get enough time for implementation of camera-related services