# looneytube

The looneytube.tv application

On Android side, the app is intended to work on phones, tablets and TVs

## Setup your env

```
.env

LOONEYTUBE_USER=admin
LOONEYTUBE_PASSWORD=password
LOONEYTUBE_API=https://api.looneytube.tv
```

## Run 

Use Android Studio to run and release the app.

## Video controls

- On phones and tablets, tap to pause or play, double tap to rewind or forward
- On TVs, press the select button to pause or play, press left or right to rewind or forward

## Three branches

Common evolutions must be performed in `master`

Then, merged into `phone` and `android-tv` that hold the specific developments