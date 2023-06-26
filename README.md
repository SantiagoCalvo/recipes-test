# recipes App

technical assesment for amaris iOS developer position.
An iOS thay communicates with the `https://spoonacular.com/food-api` API in order to retrieve a list of random recipes and hace the ability to search recipies using a key word.

### architecture
The app was implemented using the following architecture:

![newAppArchitecture drawio](https://github.com/SantiagoCalvo/recipes-test/assets/79017401/bc3cf36c-3996-4c9d-a314-c8165a7fa8b1)

In the previous architecture de UI was implemented using the MVC pattern so all the logic of presentation resides inside the `RecipeViewController` which communicates with the `RecipeLoader` interface to get the Recipe data that needs to render. 
the `RemoteRecipeLoader` implements the `RecipeLoader` protocol so can be injected into the presentation layer in the composition root of the app, this class also communicates with the `HTTPClient` protocol which hides all the infrastructure details, so you can use the networking library that you prefer. This way the app is modular and you can change components without breaking the behavior of the app.
