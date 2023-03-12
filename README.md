# MovieListAssignment

# Used design pattern and App architecture

The design patterns used in the app are as follows:
    1. Coordinator pattern for navigation
    2. Singleton pattern for coredata Manager class and network request class
 
In application simple MVC architecture has been followed in which some of the connected UI screens has been created in storyboard and rest of the screens has been created in separate xib files

 
# Code Structure

- App (AppDelegate, SceneDelegate)
- Model (API data model classes)
- Network (Network request manager class)
- Extension (A few extensions used for UIViewController & UIImageView)
- Manager (CoreData manager class to handle user favorite data)
- Coordinator (Corrdinator class to manage controllers navigation)
- Controller (MovieListVC, SearchMoviesVC, FavMoviesVC, MovieDetailVC all these controllers has been added along with their respective cells)

# User guide to use the app

- Open app
- User will see a list of movies 
- At top there are two buttons "Fav" (star icon) & "Search" 
- Clicking on any item will navigate to detail screen where user can see the poster, title, release date and a brief overview of the movie and can also add to favorite list.
- Clicking on "STAR" visible on each item will add that specific movie to favorite list
- Clicking on "Star" icon at top will move user to the list of favorite list
- Clicking on "Search" icon will move user to search screen where user can search any movie by writing its name and the query will be saved for future


# Third parties used

- No third party library has been used (-) 
