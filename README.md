# Issues app

Lighttouch app to better visualize github issues

## Filters writing params in the url

The filter work adding the name of the field then double points `:` and the value to be searched

Example: `title:lighttouch`

The url will also accept multiple filters at once, with each different filter separated with a comma.

Example:

```url
http://localhost:3000/issues?filters=model:change,size:0.5
```

Note: also the page will fail to load if given an uncomplete filter or a filter with a wrong format.

## Filters

`lorem` can be any given text

| Filter Tag | GitHub API result | Searches for  |
|---|---|---|
| `title:lorem` | `"lorem" in:title`  | Issues that have the selected word in the title  |
| `body:lorem` | `"lorem" in:body`  | Issues that have the selected word in the body  |
| `comments:lorem` | `"lorem" in:comments`  | Issues that have the selected word in the comments  |
| `label:lorem`  | `label:"lorem"`  | Issues that have that label  |
| `lorem1:lorem2`  | `label:"lorem1/lorem2"`  | Using the tag system for labels this will help search for any label that uses the system of name and value like this `name/value`, and will search for issues that have this label  |

### Previous filters

Is a control parameter that is send in the url form if there were a filter of a previous search, allowing it to handle multiple filters.
