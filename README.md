# summarize-text

This projects has three aims
1) Test to summarize text in R.
2) Test to make the function into an api endpoints uisng the package *plumber*.
3) Dockerizing the script and deploying it.


## Docker

Go to root of project and make following commands.

To build image.

```
docker build -t summarize-text-r .
```

To run image.

```
docker run --rm -p 8000:8000 summarize-text-r
```

To get container id.

```
docker ps
```
To stop container.

```
docker stop <containerId>
```
