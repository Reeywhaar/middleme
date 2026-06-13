# MiddleMe

![Icon](design/logo-128.png)

Simple app to make trackpad treat triple tap as middle click

## Installation

### Direct download

App can be installed from by downloading zip from [Release Page](https://github.com/Reeywhaar/middleme/releases)

### With Homebrew

```bash
brew tap reeywhaar/tap
brew install reeywhaar/tap/middleme
```

### With curl

Download the release zip and install the app to `/Applications`:

```bash
cd /tmp && \
curl -L -o MiddleMe.zip https://github.com/Reeywhaar/middleme/releases/latest/download/MiddleMe.zip && \
unzip -o -q MiddleMe.zip && \
rm -rf /Applications/MiddleMe.app && \
mv MiddleMe.app /Applications/
```

## Screenshots

<img src="design/screenshots/forbidden.png" width="392" alt="Forbidden state">

<img src="design/screenshots/granted.png" width="392" alt="Granted state">
