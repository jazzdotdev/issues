# Issues app

Lighttouch app to better visualize github issues

## Filter writing params in the url

The filter work adding the name of the column double points `:` and the value to be searched

Example
```url
http://localhost:3000/issues?filters=model:change
```

Currently only works with the label tags and values, where the label ```model/change```, would be seached as in the example.
