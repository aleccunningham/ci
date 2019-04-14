Place `dbuild.json` in the root of your repository:

```Json
{
    "language": "python",
    "services": {
        "required": true,
        "custom": [
            "postgres",
            "redis"
        ]
    },
    "dependencies": {
        "override": false,
        "custom": [
            "apt install -y phantomjs",
            "bower install"
        ]
    },
    "setup": {
        "override": false,
        "custom": [
            "apt install -y phantomjs",
            "bower install"
        ]
    },
    "test": {
        "override": true,
        "custom": [
            "pytest -vvv"
        ]
    }
}
```

Pull the image:

```
docker pull r.alec.cx/runner
````

Use buildkit to use your ssh keys and run the build:

```
export DOCKER_BUILDKIT=1
run
```

Magic ✨
